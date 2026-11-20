import Foundation

final class ContractURLProtocol: URLProtocol, @unchecked Sendable {
    private static let lock = NSLock()
    nonisolated(unsafe) private static var awaitingReady: [String: String] = [:]

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}

    override func startLoading() {
        let fields = requestJSON()
        let body = fields as? [String: String]
        let authorization = request.value(forHTTPHeaderField: "Authorization")
        switch (request.httpMethod, request.url?.path) {
        case ("POST", "/user/register") where body?["email"] == "test@example.com" &&
            body?["password"] == "test-pass" && body?["code"] == "314159" && body?["invite_code"] == "ABCDEFGH":
            reply(201, session("registration", expires: 2_100_000_000))
        case ("POST", "/user/login") where body == ["email": "test@example.com", "password": "test-pass"]:
            reply(200, session("login", expires: 2_100_000_000))
        case ("GET", "/user/info") where authorization == "Bearer login":
            reply(200, session("renewed", expires: 2_100_000_001))
        case ("GET", "/user/invite") where authorization == "Bearer renewed":
            reply(401, ["error": "token_revoked"])
        case ("DELETE", "/user/account") where authorization == "Bearer login" && fields == nil:
            if request.url?.host?.hasPrefix("deletion-conflict.") == true {
                reply(409, ["error": "membership_active"])
            } else {
                reply(200, ["status": "deleted"])
            }
        case ("GET", "/nodes"):
            reply(200, ["nodes": [["id": "tokyo", "name_en": "Tokyo", "region_code": "JP"],
                                  ["id": "osaka", "name_en": "Osaka", "region_code": "JP"]]])
        case ("POST", "/v2/user/connection-config") where authorization == "Bearer renewed" &&
            body == ["node_id": "tokyo", "device_key": "public-key"]:
            reply(202, ["status": "pending", "node_id": "tokyo"], headers: ["Retry-After": "2"])
        case ("POST", "/v2/user/connection-config") where authorization == "Bearer login":
            grant(body)
        case ("POST", "/user/captcha/challenge") where body?["email"] == "test@example.com" &&
            ["reset", "register"].contains(body?["purpose"] ?? ""):
            reply(200, ["challenge_id": "test-puzzle", "background": Self.png, "piece": Self.png,
                        "width": 240, "height": 120, "piece_width": 40, "y": 20])
        case ("POST", "/user/captcha/verify") where fields?["challenge_id"] as? String == "test-puzzle" && fields?["x"] as? Int == 63:
            reply(200, ["captcha_token": "test-puzzle-ticket"])
        case ("POST", "/user/register-code") where body == ["email": "test@example.com", "captcha_token": "test-puzzle-ticket"]:
            reply(200, ["sent": true, "retry_after": 60])
        case ("POST", "/user/password/reset-code") where body == ["email": "test@example.com", "captcha_token": "test-puzzle-ticket"]:
            reply(200, ["sent": true], headers: ["Retry-After": "45"])
        case ("POST", "/user/password/reset") where body == ["email": "test@example.com", "code": "314159", "new_password": "new-test-password"]:
            reply(200, ["reset": true])
        case ("POST", "/support/visitor") where body?["captcha_token"] == "visitor-ticket" && body?["source"] == "ios" &&
            body?["app_version"]?.range(of: #"^[0-9A-Za-z.+_-]{1,32}$"#, options: .regularExpression) != nil && authorization == nil:
            reply(200, ["visitor_token": "test-visitor"])
        case ("GET", "/support/conversation") where authorization == "Visitor test-visitor":
            reply(200, ["unread": 2, "contact_email": "test@example.com"])
        case ("GET", "/support/conversation") where authorization == "Bearer login":
            reply(200, ["unread": 4])
        case ("GET", "/support/revoked-test") where authorization == "Visitor test-visitor":
            reply(401, ["error": "invalid_token"])
        default:
            reply(400, ["error": "fixture_request_mismatch"])
        }
    }

    private func grant(_ body: [String: String]?) {
        guard let host = request.url?.host, let node = body?["node_id"], node == "tokyo",
              let key = body?["device_key"],
              key.range(of: #"^[a-zA-Z0-9_-]{43}$"#, options: .regularExpression) != nil else {
            reply(400, ["error": "invalid_device_key"])
            return
        }
        if host.hasPrefix("pending.") {
            Self.lock.lock()
            let firstKey = Self.awaitingReady.removeValue(forKey: host)
            if firstKey == nil { Self.awaitingReady[host] = key }
            Self.lock.unlock()
            guard let firstKey else {
                reply(202, ["status": "pending", "node_id": node], headers: ["Retry-After": "1"])
                return
            }
            guard firstKey == key else {
                reply(400, ["error": "device_key_changed"])
                return
            }
        }
        reply(200, [
            "status": "ready", "node_id": node, "sealed": "s2." + key, "user_type": "paid",
            "sealed_expires_at": host.hasPrefix("expired.") ? 1 : 2_100_000_000,
            "uuid": host.hasPrefix("foreign.") ? "aaaaaaaa-aaaa-4aaa-aaaa-aaaaaaaaaaaa" :
                "12345678-1234-4234-8234-123456789012"
        ])
    }

    private func session(_ token: String, expires: Int64) -> [String: Any] {
        ["access_token": token, "token_expires_at": expires, "active_plan_type": "traffic",
         "user": ["email": "test@example.com", "uuid": "12345678-1234-4234-8234-123456789012",
                  "traffic_remaining_bytes": 800_000]]
    }

    private func reply(_ status: Int, _ payload: [String: Any], headers: [String: String] = [:]) {
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: headers)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: try! JSONSerialization.data(withJSONObject: payload))
        client?.urlProtocolDidFinishLoading(self)
    }

    private static let png = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/6g0AAAAASUVORK5CYII="

    private func requestJSON() -> [String: Any]? {
        var data = request.httpBody ?? Data()
        if let stream = request.httpBodyStream {
            stream.open()
            defer { stream.close() }
            var buffer = [UInt8](repeating: 0, count: 1024)
            while true {
                let count = stream.read(&buffer, maxLength: buffer.count)
                guard count > 0 else { break }
                data.append(contentsOf: buffer.prefix(count))
            }
        }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
