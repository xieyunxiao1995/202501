import Combine
import Foundation
import NetworkExtension

@MainActor
final class Tunnel: ObservableObject {
    private var manager: NETunnelProviderManager?
    private var revision = 0
    private var rulesSynced = false
    private var sampling = false
    private var probe: Task<Void, Never>?
    @Published private(set) var internetReachable: Bool?
    @Published private(set) var ruleRouting = false
    @Published private(set) var status = "disconnected"
    @Published private(set) var nodeID = ""
    @Published private(set) var nodeName = ""
    @Published private(set) var upload: Int64 = 0
    @Published private(set) var download: Int64 = 0
    @Published private(set) var startedAt: Date?
    @Published private(set) var failure: String?

    var active: Bool { status != "disconnected" && status != "error" }
    var owner: String? { metadata["accountId"] as? String }
    private var providerID: String { (Bundle.main.bundleIdentifier ?? "com.GeckConnent.app") + ".PacketTunnel" }
    private var metadata: [String: Any] {
        (manager?.protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration ?? [:]
    }

    func load() async throws {
#if !targetEnvironment(simulator)
        let managers = try await NETunnelProviderManager.loadAllFromPreferences()
        manager = managers.first {
            ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == providerID
        }
#endif
    }

    func start(_ config: [String: Any]) async throws {
        revision += 1
        let current = revision
        failure = nil
        rulesSynced = false
        try await load()
        try ensureCurrent(current)
        let manager = self.manager ?? NETunnelProviderManager()
        guard [.invalid, .disconnected].contains(manager.connection.status) else { throw APIError(code: "vpn_running") }
        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = providerID
        proto.serverAddress = "GeckConnent"
        proto.providerConfiguration = ["version": 1]
        for field in ["nodeId", "nodeName", "accountId"] { proto.providerConfiguration?[field] = config[field] }
        manager.protocolConfiguration = proto
        manager.localizedDescription = "GeckConnent"
        manager.isEnabled = true
        manager.isOnDemandEnabled = false
        self.manager = manager
        try await manager.saveToPreferences()
        try ensureCurrent(current)
        try await manager.loadFromPreferences()
        try ensureCurrent(current)
        let bytes = try JSONSerialization.data(withJSONObject: config)
        try manager.connection.startVPNTunnel(options: ["configuration": bytes as NSData])
        status = "connecting"
    }

    func stop() async throws {
        revision += 1
        let current = revision
        failure = nil
        if manager == nil { try await load() }
        guard let connection = manager?.connection else { return }
        connection.stopVPNTunnel()
        let deadline = Date().addingTimeInterval(15)
        while ![.invalid, .disconnected].contains(connection.status) {
            try ensureCurrent(current)
            status = "disconnecting"
            guard Date() < deadline else { throw APIError(code: "disconnect_timeout") }
            try await Task.sleep(seconds: 0.2)
        }
        clear()
    }

    func sample() async {
        guard !sampling else { return }
        sampling = true
        defer { sampling = false }
        guard let session = manager?.connection as? NETunnelProviderSession else { return }
        let current = revision
        switch session.status {
        case .connecting: status = "connecting"
        case .disconnecting: status = "disconnecting"
        case .connected, .reasserting:
            let reply = await send(Data("status".utf8), to: session)
            guard current == revision, [.connected, .reasserting].contains(session.status) else { return }
            let previous = status
            status = reply?["state"] as? String ?? "checking"
            ruleRouting = reply?["routing"] as? String == "rule"
            if status != previous {
                probe?.cancel()
                internetReachable = nil
                if status == "connected" { probeInternet() }
            }
            upload = reply?["upload"] as? Int64 ?? upload
            download = reply?["download"] as? Int64 ?? download
            nodeID = reply?["nodeId"] as? String ?? metadata["nodeId"] as? String ?? ""
            nodeName = reply?["nodeName"] as? String ?? metadata["nodeName"] as? String ?? ""
            startedAt = session.connectedDate
            if status == "connected", !rulesSynced {
                rulesSynced = true
                await syncRules()
            }
        case .disconnected:
            if active, status != "disconnecting" {
                let error = await disconnectError(session)
                guard revision == current, session.status == .disconnected else { return }
                failure = error
                if error != nil {
                    probe?.cancel()
                    internetReachable = nil
                    status = "error"
                    startedAt = nil
                    rulesSynced = false
                    return
                }
            }
            if status != "error" { clear() }
        default: clear()
        }
    }

    func retry() async throws {
        guard let session = manager?.connection as? NETunnelProviderSession,
              [.connected, .reasserting].contains(session.status),
              await send(Data("retry".utf8), to: session) != nil else {
            throw APIError(code: "vpn_retry")
        }
    }

    func diagnostics() async -> [String: Any] {
        guard let session = manager?.connection as? NETunnelProviderSession else { return [:] }
        if [.connected, .reasserting].contains(session.status) {
            return await send(Data("diagnostics".utf8), to: session) ?? [:]
        }
        if let failure { return ["system": failure] }
        return [:]
    }

    func syncRules() async {
        guard let session = manager?.connection as? NETunnelProviderSession,
              let data = try? Data(contentsOf: RoutingRules.file),
              let local = RuleFile.version(data),
              let remote = await send(Data([1, 0]), to: session)?["rulesVersion"] as? Int64,
              local > remote,
              await send(Data([1, 1]), to: session) != nil else { return }
        for offset in stride(from: 0, to: data.count, by: 65_536) {
            let bytes = data[offset..<min(offset + 65_536, data.count)]
            guard await send(Data([1, 2]) + bytes, to: session) != nil else { return }
        }
        _ = await send(Data([1, 3]), to: session)
    }

    private func send(_ data: Data, to session: NETunnelProviderSession) async -> [String: Any]? {
        let response: Data? = await withCheckedContinuation { continuation in
            var pending: CheckedContinuation<Data?, Never>? = continuation
            let finish: @MainActor (Data?) -> Void = { value in
                pending?.resume(returning: value)
                pending = nil
            }
            do {
                try session.sendProviderMessage(data) { value in Task { @MainActor in finish(value) } }
            } catch { finish(nil) }
            Task {
                try? await Task.sleep(seconds: 2)
                finish(nil)
            }
        }
        return response.flatMap { (try? JSONSerialization.jsonObject(with: $0)) as? [String: Any] }
    }

    private func disconnectError(_ session: NETunnelProviderSession) async -> String? {
        // fetchLastDisconnectError 要 iOS 16；旧系统拿不到断开原因，按正常断开处理。
        guard #available(iOS 16, *) else { return nil }
        return await withCheckedContinuation { continuation in
            session.fetchLastDisconnectError { error in
                var current = error as NSError?
                var codes: [String] = []
                while let value = current, codes.count < 4 {
                    codes.append("\(value.domain):\(value.code)")
                    current = value.userInfo[NSUnderlyingErrorKey] as? NSError
                }
                let code = codes.isEmpty ? nil : codes.joined(separator: " / ")
                continuation.resume(returning: code)
            }
        }
    }

    private func ensureCurrent(_ expected: Int) throws {
        try Task.checkCancellation()
        guard expected == revision else { throw CancellationError() }
    }

    private func probeInternet() {
        probe = Task {
            let transport = URLSession(configuration: .ephemeral)
            var request = URLRequest(url: URL(string: "https://www.gstatic.com/generate_204")!)
            request.timeoutInterval = 5
            for attempt in 0..<3 {
                guard !Task.isCancelled else { return }
                let response = try? await transport.data(for: request).1 as? HTTPURLResponse
                guard !Task.isCancelled, status == "connected" else { return }
                if response?.statusCode == 204 {
                    internetReachable = true
                    return
                }
                if attempt < 2 {
                    do { try await Task.sleep(seconds: 3) } catch { return }
                }
            }
            internetReachable = false
        }
    }

    private func clear() {
        probe?.cancel()
        internetReachable = nil
        ruleRouting = false
        status = "disconnected"
        startedAt = nil
        upload = 0
        download = 0
        nodeID = ""
        nodeName = ""
        rulesSynced = false
    }
}
