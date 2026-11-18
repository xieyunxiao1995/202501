import Foundation
import Network
import NetworkExtension
import VeilCore

// Only native Swift/Go code handles packets. The Flutter process is not needed
// to keep a running tunnel alive.
private final class PacketBridge: NSObject, MobilePacketWriterProtocol {
    private let flow: NEPacketTunnelFlow
    private let lock = NSLock()
    private var enabled = true
    private let input = DispatchQueue(label: "com.geckohop.app.packets")
    init(_ flow: NEPacketTunnelFlow) { self.flow = flow }
    func stop() { lock.lock(); enabled = false; lock.unlock() }
    private var active: Bool { lock.lock(); defer { lock.unlock() }; return enabled }
    func writePacket(_ packet: Data?) -> Bool {
        guard active, let packet, let first = packet.first else { return false }
        let family = first >> 4 == 6 ? AF_INET6 : AF_INET
        return flow.writePackets([packet], withProtocols: [NSNumber(value: family)])
    }
    func read(into engine: MobileEngine) {
        guard active else { return }
        flow.readPackets { [weak self] packets, _ in
            guard let self else { return }
            self.input.async {
                guard self.active else { return }
                for packet in packets { engine.injectPacket(packet) }
                self.read(into: engine)
            }
        }
    }
}

final class PacketTunnelProvider: NEPacketTunnelProvider {
    private let worker = DispatchQueue(label: "com.geckohop.app.tunnel")
    private let snapshotLock = NSLock()
    private var snapshot: [String: Any] = ["state": "disconnected", "message": "未连接"]
    private var config: [String: Any] = [:]
    private var engine: MobileEngine?
    private var bridge: PacketBridge?
    private var timer: DispatchSourceTimer?
    private var monitor: NWPathMonitor?
    private var deadline: TimeInterval = 0
    private var generation = 0
    private var stopped = true
    private var state = "disconnected"
    private var uploaded: Int64 = 0
    private var downloaded: Int64 = 0
    // Recent tunnel events for the app's copyable diagnostics, guarded by
    // snapshotLock. Only short reasons this file writes; never URLs, tokens or
    // raw core errors. Lost when the system terminates the extension.
    private var events: [(Date, String)] = []
    private var lastReason = ""
    // Recovery retries every second; once-notes repeat only after a plain note.
    private var since = Set<String>()
    private var network = "unknown"
    // Path updates that did not change the primary interface, guarded by snapshotLock.
    private var ignoredPaths = 0
    private var pathChange: DispatchWorkItem?
    // Path updates arrive here, off worker, so a new primary interface can cut
    // short the recovery attempt worker is blocked in (abandonAttempt).
    private let pathQueue = DispatchQueue(label: "com.geckohop.app.tunnel.path")
    // The recovery attempt on worker, guarded by attemptLock: the engine it
    // recovers, its control request, and whether a path update abandoned it.
    private let attemptLock = NSLock()
    private var attempting = false
    private var attemptAbandoned = false
    private var attemptEngine: MobileEngine?
    private var attemptSession: URLSession?
    // Whether the primary physical interface has IPv6 (MobileEngine.setDirectIPv6);
    // nil until the first path update. Only touched on worker.
    private var directIPv6: Bool?

    private func publish(_ state: String, _ message: String) {
        self.state = state
        let value: [String: Any] = [
            "state": state, "message": message,
            "nodeId": config["nodeId"] as? String ?? "",
            "nodeName": config["nodeName"] as? String ?? "",
            "accountId": config["accountId"] as? String ?? "",
            "routing": MobileDNSServer(config["routing"] as? String ?? "") == MobileDNSServer("") ? "global" : "rule",
            "upload": uploaded + (engine?.uploaded() ?? 0),
            "download": downloaded + (engine?.downloaded() ?? 0)
        ]
        snapshotLock.lock(); snapshot = value; snapshotLock.unlock()
    }
    private let onlineLimitMessage = "同时连接的设备数已达上限，请先断开其他设备后再连接。"
    // During recovery the slot is almost always this device's own session from
    // before the network changed; the node releases it within about a minute.
    private let onlineRecoveringMessage = "网络已切换，原连接约需 1～2 分钟释放，请稍后点「重试连接」。如仍提示，请断开其他设备。"
    private func isOnlineLimit(_ error: Error) -> Bool {
        (error as NSError).localizedDescription.hasPrefix("online_limit:")
    }
    private func note(_ text: String, once: Bool = false) {
        snapshotLock.lock(); defer { snapshotLock.unlock() }
        guard events.last?.1 != text else { return }
        if once { guard since.insert(text).inserted else { return } } else { since.removeAll() }
        if events.count >= 100 { events.removeFirst() }
        events.append((Date(), text))
    }
    private func fail(_ step: String, _ error: Error) {
        noteResolve()
        let reason = "\(step): \(Self.reason(error))"
        snapshotLock.lock(); lastReason = reason; snapshotLock.unlock()
        note(reason, once: true)
    }
    // When the core's fallback answered for the node's name, as on Android:
    // "resolve: doh (slow)" when the system had not answered within a second.
    // Never the name or the address.
    private func noteResolve() {
        let source = MobileTakeResolveSource()
        if !source.isEmpty && source != "system" { note("resolve: \(source)", once: true) }
    }
    private static func reason(_ error: Error) -> String {
        let value = error as NSError
        // failure(...) texts are written in this file.
        if value.domain == "com.geckohop.app.vpn" { return value.localizedDescription }
        if value.domain == NSURLErrorDomain { return "\(value.domain):\(value.code)" }
        return classify(value.localizedDescription) ?? "\(value.domain):\(value.code)"
    }
    // Same classes as Android. The core wraps every start failure as
    // "Veil server authentication failed: <cause>", so the prefix says nothing.
    private static func classify(_ message: String) -> String? {
        var detail = message.lowercased()
        let prefix = "veil server authentication failed: "
        if detail.hasPrefix(prefix) { detail.removeFirst(prefix.count) }
        let classes: [(String, [String])] = [
            ("online limit", ["online_limit:"]),
            ("online unavailable", ["online admission unavailable"]),
            ("protect failed", ["protection failed"]),
            ("dns", ["dns", "lookup", "resolve", "no such host"]),
            ("tls", ["tls", "certificate", "x509"]),
            ("timeout", ["timeout", "deadline"]),
            ("refused", ["refused"]),
            ("reset", ["reset", "broken pipe"]),
            ("unreachable", ["unreachable", "no route"]),
            ("eof", ["eof"]),
            ("closed", ["closed"]),
            // What a node answers for an unknown, disabled or expired credential.
            ("auth", ["unauthenticated", "unauthorized"]),
        ]
        return classes.first { $0.1.contains { detail.contains($0) } }?.0
    }
    private func diagnostics() -> [String: Any] {
        let format = DateFormatter()
        format.locale = Locale(identifier: "en_US_POSIX"); format.dateFormat = "MM-dd HH:mm:ss"
        snapshotLock.lock(); defer { snapshotLock.unlock() }
        return ["events": events.map { "\(format.string(from: $0.0)) \($0.1)" },
                "reason": lastReason, "env": "network=\(network) ignoredPaths=\(ignoredPaths)"]
    }
    private func failure(_ message: String) -> NSError {
        NSError(domain: "com.geckohop.app.vpn", code: 1,
                userInfo: [NSLocalizedDescriptionKey: message])
    }
    override func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        worker.async {
            guard self.stopped else { completionHandler(self.failure("VPN 正在运行")); return }
            guard let data = options?["configuration"] as? Data,
                  let config = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let sealed = config["sealed"] as? String, let uuid = config["uuid"] as? String,
                  UUID(uuidString: uuid) != nil, let node = config["nodeId"] as? String,
                  // The endpoint stays sealed; only the Go core can open it, with the
                  // device key the master sealed it to.
                  let secret = config["deviceSecret"] as? String, MobileSetDeviceSecret(secret, nil),
                  MobileSealedMatches(sealed, node, uuid),
                  let kind = config["userType"] as? String, ["paid", "free"].contains(kind)
            else { completionHandler(self.failure("请从 App 选择节点重新连接")); return }
            self.generation += 1
            let generation = self.generation
            self.config = config; self.stopped = false
            self.uploaded = 0; self.downloaded = 0
            self.note("start \(node)")
            self.publish("connecting", "正在连接服务器")
            // NetworkExtension requires a numeric remote address, not the WSS hostname.
            // The core resolves it so the hostname never leaves the sealed config,
            // falling back to public resolvers and the last good address.
            let remoteAddress = MobileResolveSealedRemote(sealed)
            guard !remoteAddress.isEmpty else {
                self.fail("start", self.failure("dns"))
                // The same code as a core start failing on DNS: the app reads only
                // the system's error once the extension has stopped.
                self.cleanup(); completionHandler(NSError(domain: "com.geckohop.app.core", code: 102)); return
            }
            let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: remoteAddress)
            let ipv4 = NEIPv4Settings(addresses: ["10.77.0.2"], subnetMasks: ["255.255.255.0"])
            ipv4.includedRoutes = [NEIPv4Route.default()]
            settings.ipv4Settings = ipv4
            let ipv6 = NEIPv6Settings(addresses: ["fd77::2"], networkPrefixLengths: [64])
            ipv6.includedRoutes = [NEIPv6Route.default()]
            settings.ipv6Settings = ipv6
            // Rule routing installs the core's in-tunnel resolver so no client
            // upgrades it to encrypted DNS, which would hide names from the core.
            let dns = NEDNSSettings(servers: [MobileDNSServer(config["routing"] as? String ?? "")])
            dns.matchDomains = [""]; settings.dnsSettings = dns; settings.mtu = 1280
            self.setTunnelNetworkSettings(settings) { error in
                self.worker.async {
                    guard !self.stopped, self.generation == generation else { completionHandler(self.failure("连接已取消")); return }
                    if let error {
                        self.fail("settings", error)
                        self.cleanup(); completionHandler(error); return
                    }
                    do {
                        try self.startEngine()
                        self.publish("connected", "已连接 · 全局 VPN")
                        self.noteResolve()
                        self.note("connected")
                        self.startSupervisor()
                        completionHandler(nil)
                    } catch {
                        self.fail("start", error)
                        if self.isOnlineLimit(error) {
                            if #available(iOS 16.0, macOS 13.0, *) {
                                self.cleanup()
                                self.publish("error", self.onlineLimitMessage)
                                completionHandler(NSError(domain: "com.geckohop.app.core", code: 106))
                            } else {
                                // iOS 15 cannot fetch a stopped provider's error.
                                // Keep routes installed without forwarding so status/retry remain available.
                                self.closeEngine()
                                self.publish("blocked", self.onlineLimitMessage)
                                self.startSupervisor()
                                completionHandler(nil)
                            }
                            return
                        }
                        self.cleanup()
                        self.publish("error", "GeckoHop 服务器认证失败，请重试")
                        // Classify internally without exposing URLs, tokens, or raw Go errors.
                        let code = switch Self.classify((error as NSError).localizedDescription) {
                        case "timeout": 101
                        case "dns": 102
                        case "tls": 103
                        case "auth": 104
                        default: 105
                        }
                        completionHandler(NSError(domain: "com.geckohop.app.core", code: code))
                    }
                }
            }
        }
    }
    // The WebSocket User-Agent: a browser's, like Android's. Nodes do not read it.
    #if os(iOS)
    private static let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1"
    #else
    private static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15"
    #endif
    private func startEngine() throws {
        let bridge = PacketBridge(packetFlow)
        var error: NSError?
        let remaining = deadline == 0 ? 8 : min(8, deadline - ProcessInfo.processInfo.systemUptime)
        guard remaining > 0 else { throw failure("recovery timeout") }
        guard let next = MobileStartPacketFlowSealedRouted(config["sealed"] as? String ?? "",
            Self.userAgent, config["routing"] as? String ?? "", Self.rulesFile.path,
            bridge, max(1, Int(remaining * 1000)), &error)
        else { bridge.stop(); throw error ?? failure("core start failed") }
        self.bridge = bridge; engine = next
        next.setDirectIPv6(directIPv6 == true)
        bridge.read(into: next)
    }
    private func closeEngine() {
        bridge?.stop()
        if let engine {
            engine.close()
            uploaded += engine.uploaded(); downloaded += engine.downloaded()
        }
        engine = nil; bridge = nil
    }
    private func cleanup() {
        generation += 1
        stopped = true; timer?.cancel(); timer = nil
        monitor?.cancel(); monitor = nil; directIPv6 = nil
        pathChange?.cancel(); pathChange = nil
        closeEngine(); deadline = 0; config = [:]
    }
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        worker.async {
            // 1 user, 2 provider failed, 3 no network, 13 superseded, 14 user logout,
            // 15 user switch, 16 connection failed, 17 sleep... (NEProviderStopReason).
            self.note("stop: reason \(reason.rawValue)")
            self.publish("disconnecting", "正在断开")
            self.cleanup(); self.publish("disconnected", "未连接")
            completionHandler()
        }
    }
    private func startSupervisor() {
        let generation = self.generation
        let timer = DispatchSource.makeTimerSource(queue: worker)
        timer.schedule(deadline: .now() + 1, repeating: 1)
        var ticks = 0
        timer.setEventHandler { [weak self] in
            guard let self, self.generation == generation else { return }
            // A new IPv6 address is unusable for about a second of duplicate
            // address detection, and its end may bring no path update.
            ticks += 1
            if ticks % 5 == 0, self.directIPv6 != nil, let path = self.monitor?.currentPath {
                self.checkDirectIPv6(path)
            }
            self.supervise()
        }
        self.timer = timer; timer.resume()
        let monitor = NWPathMonitor()
        // Worker only, like the timer above.
        var last: String?
        // pathQueue only: the primary interface of the latest update.
        var primary: String?
        // Updates arrive on pathQueue so a new primary interface cuts short a
        // recovery attempt worker is blocked in; the rest runs on worker.
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let key = Self.pathKey(path)
            if let seen = primary, seen != key { self.abandonAttempt() }
            primary = key
            self.worker.async { [weak self] in
                guard let self, !self.stopped, self.generation == generation else { return }
                let kind = path.status != .satisfied ? "none"
                    : path.usesInterfaceType(.wifi) ? "wifi"
                    : path.usesInterfaceType(.cellular) ? "cellular"
                    : path.usesInterfaceType(.wiredEthernet) ? "ethernet" : "other"
                self.snapshotLock.lock(); self.network = kind; self.snapshotLock.unlock()
                // Before the primary-interface check: IPv6 can come and go on the
                // same interface, as when its router advertisement arrives late.
                self.checkDirectIPv6(path)
                guard let previous = last else { last = key; return }
                // iOS also reports cellular coming and going under Wi-Fi, Low Data
                // Mode, DNS and similar changes. Carriers on an unchanged primary
                // interface still work, so only a new primary interface resets them;
                // a burst while switching settles into one reset.
                self.pathChange?.cancel(); self.pathChange = nil
                guard key != previous else {
                    self.snapshotLock.lock(); self.ignoredPaths += 1; self.snapshotLock.unlock()
                    return
                }
                let change = DispatchWorkItem { [weak self] in
                    guard let self, !self.stopped, self.generation == generation else { return }
                    self.pathChange = nil; last = key
                    self.note("network changed \(previous) -> \(key)")
                    self.engine?.resetNetwork(); self.deadline = 0
                    self.publish("checking", "正在检查连接")
                }
                self.pathChange = change
                self.worker.asyncAfter(deadline: .now() + 1, execute: change)
            }
        }
        self.monitor = monitor; monitor.start(queue: pathQueue)
    }
    // pathQueue. A recovery attempt bound to the old primary interface would
    // run out its timeouts there (4 s per control request, up to 8 s in the
    // core) before worker even sees the update; abortRecovery never blocks.
    private func abandonAttempt() {
        attemptLock.lock(); defer { attemptLock.unlock() }
        guard attempting, !attemptAbandoned else { return }
        attemptAbandoned = true
        attemptEngine?.abortRecovery()
        attemptSession?.invalidateAndCancel()
    }
    // Worker. Brackets one recovery attempt for abandonAttempt.
    private func beginAttempt() {
        attemptLock.lock(); defer { attemptLock.unlock() }
        attempting = true; attemptAbandoned = false
        attemptEngine = engine; attemptSession = nil
    }
    private func endAttempt() {
        attemptLock.lock(); defer { attemptLock.unlock() }
        attempting = false; attemptEngine = nil; attemptSession = nil
    }
    private var attemptWasAbandoned: Bool {
        attemptLock.lock(); defer { attemptLock.unlock() }
        return attemptAbandoned
    }
    // Notes a changed direct IPv6 answer and hands it to the core.
    private func checkDirectIPv6(_ path: Network.NWPath) {
        let ipv6 = Self.physicalIPv6(path)
        guard ipv6 != directIPv6 else { return }
        note("direct ipv6 \(ipv6 ? "yes" : "no")")
        directIPv6 = ipv6; engine?.setDirectIPv6(ipv6)
    }
    // The preferred physical interface, e.g. "wifi(en0)"; the tunnel's own utun is "other".
    private static func pathKey(_ path: Network.NWPath) -> String {
        guard path.status == .satisfied else { return "none" }
        guard let primary = path.availableInterfaces.first(where: { $0.type != .other && $0.type != .loopback })
        else { return "other" }
        let kind = switch primary.type {
        case .wifi: "wifi"
        case .cellular: "cellular"
        case .wiredEthernet: "ethernet"
        default: "other"
        }
        return "\(kind)(\(primary.name))"
    }
    // Whether the preferred physical interface reaches the IPv6 Internet: it
    // routes a public address and picks a global source for it, 2000::/3
    // without Teredo (2001::/32) and 6to4 (2002::/16), so not link-local or
    // ULA. A sniffed flow is accepted before it is dialed, so the core reads
    // IPv6 names only when direct sockets reach IPv6 too. Connecting a UDP
    // socket sends nothing. path.supportsIPv6 is not used: the path also lists
    // the tunnel's own utun, which has IPv6.
    private static func physicalIPv6(_ path: Network.NWPath) -> Bool {
        guard path.status == .satisfied,
              let primary = path.availableInterfaces.first(where: { $0.type != .other && $0.type != .loopback })
        else { return false }
        let fd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP)
        guard fd >= 0 else { return false }
        defer { close(fd) }
        var index = UInt32(primary.index)
        var target = sockaddr_in6()
        target.sin6_len = UInt8(MemoryLayout<sockaddr_in6>.size)
        target.sin6_family = sa_family_t(AF_INET6)
        target.sin6_port = UInt16(443).bigEndian
        var source = sockaddr_in6()
        var length = socklen_t(MemoryLayout<sockaddr_in6>.size)
        guard setsockopt(fd, IPPROTO_IPV6, IPV6_BOUND_IF, &index, socklen_t(MemoryLayout<UInt32>.size)) == 0,
              inet_pton(AF_INET6, "2606:4700:4700::1111", &target.sin6_addr) == 1,
              withUnsafePointer(to: &target, {
                  $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { connect(fd, $0, socklen_t(MemoryLayout<sockaddr_in6>.size)) }
              }) == 0,
              withUnsafeMutablePointer(to: &source, {
                  $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { getsockname(fd, $0, &length) }
              }) == 0
        else { return false }
        let b = source.sin6_addr.__u6_addr.__u6_addr8
        return b.0 & 0xE0 == 0x20 && !(b.0 == 0x20 && b.1 == 0x01 && b.2 == 0 && b.3 == 0) && !(b.0 == 0x20 && b.1 == 0x02)
    }
    // Requests originate in the provider so recovery does not depend on the
    // broken tunnel. Never follow redirects carrying credentials.
    private func request(_ path: String, _ body: [String: Any]) throws -> [String: Any] {
        guard let base = config["apiBase"] as? String, let url = URL(string: base + path),
              url.user == nil, url.query == nil, url.fragment == nil,
              url.scheme == "https" || (url.scheme == "http" && ["localhost", "127.0.0.1", "::1"].contains(url.host ?? "")),
              let token = config["apiToken"] as? String, !token.isEmpty
        else { throw failure("no credentials") }
        let remaining = min(4, deadline - ProcessInfo.processInfo.systemUptime)
        guard remaining > 0 else { throw failure("recovery timeout") }
        var request = URLRequest(url: url, timeoutInterval: remaining)
        request.httpMethod = "POST"; request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let delegate = ControlResponse()
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.connectionProxyDictionary = [:]
        sessionConfig.timeoutIntervalForRequest = remaining; sessionConfig.timeoutIntervalForResource = remaining
        let session = URLSession(configuration: sessionConfig, delegate: delegate, delegateQueue: nil)
        defer { session.invalidateAndCancel() }
        attemptLock.lock()
        let abandoned = attemptAbandoned
        attemptSession = session
        attemptLock.unlock()
        guard !abandoned else { throw failure("network changed") }
        session.dataTask(with: request).resume()
        guard delegate.done.wait(timeout: .now() + remaining) == .success else { throw failure("timeout") }
        if delegate.status != 0 && !(200..<300).contains(delegate.status) { throw failure("http \(delegate.status)") }
        if let error = delegate.error { throw error }
        guard let result = delegate.result else { throw failure("bad response") }
        return result
    }
    private func supervise() {
        guard !stopped, state != "blocked" else { return }
        if engine?.connected() == true {
            if deadline != 0 { noteResolve(); note("recovered") }
            deadline = 0; publish("connected", "已连接 · 全局 VPN"); return
        }
        if deadline == 0 {
            deadline = ProcessInfo.processInfo.systemUptime + 15
            note(engine == nil || engine?.failed() == true ? "lost: engine failed" : "lost: engine disconnected")
        }
        if ProcessInfo.processInfo.systemUptime >= deadline { block(); return }
        publish("checking", "正在检查连接")
        beginAttempt(); defer { endAttempt() }
        var step = "status"
        do {
            let uuid = config["uuid"] as? String ?? ""
            let kind = config["userType"] as? String ?? ""
            let node = config["nodeId"] as? String ?? ""
            let auth = try request("/user/connection-status", ["node_id": node, "uuid": uuid, "user_type": kind])
            guard auth["uuid"] as? String == uuid, auth["user_type"] as? String == kind else { throw failure("response mismatch") }
            if auth["status"] as? String == "invalid" {
                note("status: invalid")
                cleanup(); publish("disconnected", "连接已断开，请检查网络或可用权益")
                cancelTunnelWithError(nil); return
            }
            guard auth["status"] as? String == "valid" else { throw failure("unknown status") }
            note("status: valid", once: true)
            publish("reconnecting", "正在重连")
            var replace = engine == nil || engine?.failed() == true
            if kind == "paid" {
                step = "config"
                let deviceKey = MobileDevicePublicKey(config["deviceSecret"] as? String ?? "")
                let next = try request("/v2/user/connection-config", ["node_id": node, "device_key": deviceKey])
                guard next["node_id"] as? String == node,
                      // The account UUID is the credential, so matching it already pins the account.
                      next["status"] as? String == "ready", next["uuid"] as? String == uuid,
                      (next["user_type"] as? String ?? "paid") == "paid",
                      let sealed = next["sealed"] as? String, MobileSealedMatches(sealed, node, uuid)
                else { throw failure(next["status"] as? String == "pending" ? "pending" : "config not ready") }
                note("config: ready", once: true)
                // Seals are randomized, so only the core can tell whether the endpoint moved.
                replace = replace || engine?.matchesSealed(sealed) != true
                config["sealed"] = sealed
            }
            step = "engine"
            if replace { closeEngine(); try startEngine() }
            else {
                let remaining = min(8, deadline - ProcessInfo.processInfo.systemUptime)
                guard remaining > 0 else { throw failure("recovery timeout") }
                guard !attemptWasAbandoned else { throw failure("network changed") }
                try engine?.recover(within: max(1, Int(remaining * 1000)))
            }
            guard engine?.connected() == true else { throw failure("not connected") }
            noteResolve()
            note("recovered")
            deadline = 0; publish("connected", "已连接 · 全局 VPN")
        } catch {
            // Abandoned for a new primary interface: the update's reset follows.
            if attemptWasAbandoned { return }
            fail(step, error)
            if isOnlineLimit(error) {
                closeEngine(); publish("blocked", onlineRecoveringMessage); note("blocked"); return
            }
            publish("reconnecting", "正在重连")
            if ProcessInfo.processInfo.systemUptime >= deadline { block() }
        }
    }
    private func block() {
        // Keep network settings installed, but stop all packet forwarding.
        closeEngine()
        publish("blocked", "连接异常，已阻止直接联网。请重试或手动断开")
        note("blocked")
    }
    // The app cannot share files with the extension (macOS runs it as a system
    // extension), so a downloaded rule set arrives in messages and is kept here.
    private static let rulesFile = (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        ?? FileManager.default.temporaryDirectory).appendingPathComponent("rules/cn.vrs")
    private var incomingRules = Data()
    private static func rulesVersion(_ path: String) -> Int64 {
        var version: Int64 = 0
        return MobileRulesVersion(path, &version, nil) ? version : 0
    }
    private var installedRulesVersion: Int64 {
        max(Self.rulesVersion(""), Self.rulesVersion(Self.rulesFile.path))
    }
    // The core checks the file; only a newer set replaces the current one.
    private func installRules(_ data: Data) {
        let tmp = Self.rulesFile.appendingPathExtension("tmp")
        defer { try? FileManager.default.removeItem(at: tmp) }
        do {
            try FileManager.default.createDirectory(at: tmp.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: tmp, options: .atomic)
            guard Self.rulesVersion(tmp.path) > installedRulesVersion else { return }
            _ = try FileManager.default.replaceItemAt(Self.rulesFile, withItemAt: tmp)
            // Applies at once under rule routing; a full tunnel has nothing to swap.
            try? engine?.loadRules(data)
        } catch {}
    }
    /// Messages starting with 0x01: [1, 0] asks for the version, [1, 1] begins a
    /// transfer, [1, 2, bytes...] appends, [1, 3] installs. Each answers the version.
    private func handleRules(_ message: Data) -> Data? {
        switch message.count > 1 ? message[message.startIndex + 1] : 0 {
        case 1: incomingRules = Data()
        case 2:
            // Matches rules.MaxSize in the core.
            if incomingRules.count + message.count <= 4 << 20 { incomingRules.append(message.dropFirst(2)) }
        case 3: installRules(incomingRules); incomingRules = Data()
        default: break
        }
        return try? JSONSerialization.data(withJSONObject: ["rulesVersion": installedRulesVersion])
    }
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        if messageData.first == 1 {
            worker.async { completionHandler?(self.handleRules(messageData)) }
            return
        }
        if String(data: messageData, encoding: .utf8) == "diagnostics" {
            completionHandler?(try? JSONSerialization.data(withJSONObject: diagnostics()))
            return
        }
        if String(data: messageData, encoding: .utf8) == "retry" {
            worker.async {
                if self.state == "blocked" && !self.stopped {
                    self.note("retry")
                    self.deadline = 0; self.publish("checking", "正在检查连接"); self.supervise()
                }
            }
        }
        snapshotLock.lock(); let value = snapshot; snapshotLock.unlock()
        completionHandler?(try? JSONSerialization.data(withJSONObject: value))
    }
}

private final class ControlResponse: NSObject, URLSessionDataDelegate {
    let done = DispatchSemaphore(value: 0)
    private var data = Data()
    private var valid = false
    private(set) var result: [String: Any]?
    private(set) var status = 0
    private(set) var error: Error?
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) { completionHandler(nil) }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        status = (response as? HTTPURLResponse)?.statusCode ?? 0
        valid = (200..<300).contains(status)
        completionHandler(valid ? .allow : .cancel)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive chunk: Data) {
        if data.count + chunk.count > 8192 { valid = false; dataTask.cancel(); return }
        data.append(chunk)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.error = error
        if valid && error == nil { result = try? JSONSerialization.jsonObject(with: data) as? [String: Any] }
        done.signal()
    }
}
