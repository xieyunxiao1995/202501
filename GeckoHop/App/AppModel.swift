import Combine
import CryptoKit
import Foundation

@MainActor
final class AppModel: ObservableObject {
    let api: APIClient
    let tunnel = Tunnel()
    private let storage: KeychainStore
    private let key = Curve25519.KeyAgreement.PrivateKey()
    private var generation = 0
    private var operation: Task<Void, Never>?
    private var refreshingSession = false
    private var bootstrapped = false
    @Published private(set) var session: Session?
    @Published private(set) var nodes: [Node] = []
    @Published private(set) var loadingNodes = false
    @Published private(set) var nodesError: String?
    @Published private(set) var preparing = false
    @Published private(set) var stopping = false
    @Published private(set) var changingAccount = false
    @Published private(set) var showDeletionReceipt = false
    @Published private(set) var restoring = true
    @Published var issue: String?
    @Published private(set) var selectedID = UserDefaults.standard.string(forKey: "selectedNode")
    var selected: Node? { nodes.first { $0.id == selectedID } ?? nodes.first }
    let serviceInfo = ServiceInfo()
    @Published var supportUnread = 0
    private var forwarding: [AnyCancellable] = []

    init(api: APIClient = APIClient()) {
        self.api = api
        storage = KeychainStore(namespace: api.base)
        // 子对象的变化转发出去，界面只需观察 AppModel。
        forwarding = [tunnel.objectWillChange, serviceInfo.objectWillChange].map {
            $0.sink { [weak self] _ in self?.objectWillChange.send() }
        }
    }

    func bootstrap() async {
        guard !bootstrapped else { return }
        defer { restoring = false }
        do { try await tunnel.load() }
        catch { if !Task.isCancelled { issue = error.localizedDescription } }
        do {
            let saved = try storage.read("session", as: Session.self)
            if let saved, saved.tokenExpiresAt > Int64(Date().timeIntervalSince1970) {
                session = saved
                await refreshSession()
            } else if saved != nil {
                try storage.write("session", value: Optional<Session>.none)
            }
            if let owner = tunnel.owner, owner != session?.user.uuid {
                try await tunnel.stop()
            }
        } catch {
            if !Task.isCancelled { issue = error.localizedDescription }
        }
        if !Task.isCancelled { bootstrapped = true }
    }

    func refreshNodes() async {
        guard !loadingNodes else { return }
        loadingNodes = true
        defer { loadingNodes = false }
        do {
            nodes = try await Node.decode(api.call("/nodes"))
            nodesError = nil
        } catch {
            if !Task.isCancelled { nodesError = error.localizedDescription }
        }
    }

    func select(_ node: Node) {
        selectedID = node.id
        UserDefaults.standard.set(node.id, forKey: "selectedNode")
    }

    func authenticate(path: String, body: [String: Any]) async throws {
        let snapshot = generation
        let value = try await Session(response: api.call(path, method: "POST", body: body))
        try Task.checkCancellation()
        guard snapshot == generation else { throw CancellationError() }
        try storage.write("session", value: value)
        generation += 1
        session = value
    }

    func refreshSession() async {
        guard let current = session, !refreshingSession else { return }
        refreshingSession = true
        defer { refreshingSession = false }
        do {
            let value = try await Session(response: authorized("/user/info"))
            guard session?.accessToken == current.accessToken,
                  value.tokenExpiresAt >= current.tokenExpiresAt else { return }
            try storage.write("session", value: value)
            session = value
        } catch {
            if !(error is CancellationError), !Task.isCancelled { issue = error.localizedDescription }
        }
    }

    func authorized(_ path: String, method: String = "GET", body: [String: Any]? = nil) async throws -> [String: Any] {
        guard let session else { throw APIError(status: 401, code: "invalid_token") }
        let snapshot = generation
        do {
            let value = try await api.call(path, method: method, body: body, authorization: "Bearer " + session.accessToken)
            guard snapshot == generation else { throw CancellationError() }
            return value
        } catch let error as APIError where error.status == 401 {
            if snapshot == generation, self.session?.accessToken == session.accessToken {
                clearSession()
                Task { await stop() }
            }
            throw error
        }
    }

    func signOut() async {
        guard !changingAccount else { return }
        changingAccount = true
        defer { changingAccount = false }
        clearSession()
        await stop()
    }

    func requestAccountDeletion() async {
        guard !changingAccount, session != nil else { return }
        showDeletionReceipt = true
        await signOut()
    }

    func dismissDeletionReceipt() { showDeletionReceipt = false }

    private func clearSession() {
        generation += 1
        session = nil
        supportUnread = 0
        do { try storage.write("session", value: Optional<Session>.none) }
        catch { issue = error.localizedDescription }
    }

    func connect() {
        guard operation == nil, !stopping, !changingAccount, !restoring, !tunnel.active,
              !serviceInfo.requiresUpdate, let selected, session != nil else { return }
        issue = nil
#if targetEnvironment(simulator)
        issue = L("请在签名后的 iPhone 或 iPad 上测试 VPN 隧道。", "Test the VPN tunnel on a signed iPhone or iPad.")
        return
#else
        preparing = true
        let snapshot = generation
        operation = Task {
            defer {
                if !Task.isCancelled {
                    preparing = false
                    operation = nil
                }
            }
            do {
                let config = try await connectionConfiguration(for: selected)
                try Task.checkCancellation()
                guard snapshot == generation, !serviceInfo.requiresUpdate else { return }
                try await tunnel.start(config)
            }
            catch is CancellationError { }
            catch { if !Task.isCancelled { issue = error.localizedDescription } }
        }
#endif
    }

    func switchTo(_ node: Node) async {
        guard !stopping, node.id != selected?.id else { return }
        let reconnect = tunnel.active || preparing
        if reconnect {
            issue = nil
            await stop()
            guard issue == nil else { return }
        }
        select(node)
        if reconnect { connect() }
    }

    func stop() async {
        guard !stopping else { return }
        let previous = operation
        previous?.cancel()
        operation = nil
        preparing = false
        stopping = true
        defer { stopping = false }
        await previous?.value
        do { try await tunnel.stop() }
        catch is CancellationError { }
        catch { issue = error.localizedDescription }
    }

    func connectionConfiguration(for node: Node) async throws -> [String: Any] {
        guard let account = session else { throw APIError(status: 401, code: "invalid_token") }
        let snapshot = generation
        let deadline = Date().addingTimeInterval(45)
        while Date() < deadline {
            let grant = try await authorized("/v2/user/connection-config", method: "POST",
                body: ["node_id": node.id, "device_key": base64URL(key.publicKey.rawRepresentation)])
            try Task.checkCancellation()
            guard !serviceInfo.requiresUpdate else { throw CancellationError() }
            guard snapshot == generation, grant["node_id"] as? String == node.id else {
                throw APIError(code: "node_config_unavailable")
            }
            if grant["status"] as? String == "pending" {
                let wait = min(15, max(1, grant["retry_after"] as? Int ?? 2))
                try await Task.sleep(seconds: Double(wait))
                continue
            }
            guard grant["status"] as? String == "ready", let sealed = grant["sealed"] as? String,
                  sealed.hasPrefix("s2."), sealed.count > 3,
                  let uuid = grant["uuid"] as? String, UUID(uuidString: uuid) != nil,
                  uuid == account.user.uuid, grant["user_type"] as? String == "paid",
                  let token = session?.accessToken else { throw APIError(code: "response") }
            if let expiry = grant["sealed_expires_at"] as? Int64, expiry <= Int64(Date().timeIntervalSince1970) {
                throw APIError(code: "device_clock_ahead")
            }
            var config: [String: Any] = [
                "nodeId": node.id, "nodeName": node.name, "uuid": uuid, "accountId": uuid,
                "sealed": sealed, "userType": "paid",
                "deviceSecret": base64URL(key.rawRepresentation), "apiBase": api.base, "apiToken": token,
                "configPath": "/v2/user/connection-config", "statusPath": "/user/connection-status"
            ]
            if UserDefaults.standard.bool(forKey: "smartRouting") {
                let custom = (UserDefaults.standard.array(forKey: "customRoutes") as? [[String: String]]) ?? []
                let data = try JSONSerialization.data(withJSONObject: ["mode": "rule", "custom": custom])
                config["routing"] = String(decoding: data, as: UTF8.self)
            }
            return config
        }
        throw APIError(code: "prepare_timeout")
    }

    private func base64URL(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
