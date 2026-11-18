#if DEBUG && targetEnvironment(simulator)
import Foundation

/// A local transport for UI tests. Requests never leave the simulator.
final class UITestService: URLProtocol, @unchecked Sendable {
    @MainActor
    static func client(run: String) -> APIClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [Self.self]
        return APIClient(base: "https://" + run + ".uitest.invalid", transport: URLSession(configuration: configuration))
    }

    override class func canInit(with request: URLRequest) -> Bool {
        request.url?.host?.hasSuffix(".uitest.invalid") == true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}

    override func startLoading() {
        let png = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/6g0AAAAASUVORK5CYII="
        let bearer = request.value(forHTTPHeaderField: "Authorization")
        switch (request.httpMethod, request.url?.path) {
        case ("GET", "/app/version"): reply(["version": "0.0.1", "build_number": 1])
        case ("GET", "/app/notices"): reply(["notices": []])
        case ("POST", "/user/captcha/challenge"):
            reply(["challenge_id": "fixture", "background": png, "piece": png,
                   "width": 320, "height": 160, "piece_width": 64, "y": 80])
        case ("POST", "/user/captcha/verify"): reply(["captcha_token": "puzzle-fixture"])
        case ("POST", "/support/visitor"):
            guard let fields = fields(), fields["captcha_token"] as? String == "puzzle-fixture",
                  let version = fields["app_version"] as? String,
                  version.range(of: #"^[0-9A-Za-z.+_-]{1,32}$"#, options: .regularExpression) != nil else {
                reply(["error": "invalid_request"], status: 400)
                return
            }
            reply(["visitor_token": "visitor-fixture"])
        case ("GET", "/support/conversation") where bearer != nil:
            reply(["status": "none", "unread": 0, "contact_email": ""])
        case ("GET", "/support/messages") where bearer != nil:
            let messages: [[String: Any]] = [
                ["seq": 1, "sender": "user", "text": "The connection drops when I switch from Wi-Fi to mobile data."],
                ["seq": 2, "sender": "admin",
                 "text": "Please attach a connection report so we can check which route was active when the network changed."]
            ]
            reply(["status": "human", "messages": messages])
        case ("POST", "/support/read") where bearer != nil: reply([:])
        case ("POST", "/user/login"), ("GET", "/user/info"):
            reply(["access_token": "account-fixture", "token_expires_at": 2_100_000_000,
                   "user": ["email": "test@example.com", "uuid": "12345678-1234-4234-8234-123456789012"]])
        case ("GET", "/nodes"):
            reply(["nodes": [
                ["id": "route-a", "name_en": "Tokyo", "name_zh": "东京", "region_code": "JP"],
                ["id": "route-b", "name_en": "Osaka", "name_zh": "大阪", "region_code": "JP"]
            ]])
        default: reply(["error": "fixture_request_mismatch"], status: 400)
        }
    }

    private func fields() -> [String: Any]? {
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

    private func reply(_ object: [String: Any], status: Int = 200) {
        guard let url = request.url, let response = HTTPURLResponse(url: url, statusCode: status,
              httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/json"]),
              let data = try? JSONSerialization.data(withJSONObject: object) else { return }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
}
#endif
