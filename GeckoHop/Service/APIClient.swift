import Foundation

@MainActor
struct APIClient {
    static let fallback = "https://api-GeckConnent.bigbaer77.top"
    let base: String
    let transport: URLSession

    init(base: String = Bundle.main.object(forInfoDictionaryKey: "VeilAPIBaseURL") as? String ?? Self.fallback,
         transport: URLSession = URLSession(configuration: .ephemeral)) {
        self.base = base.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        self.transport = transport
    }

    func call(_ path: String, method: String = "GET", body: [String: Any]? = nil,
              authorization: String? = nil) async throws -> [String: Any] {
        guard let url = URL(string: base + path), url.scheme == "https", url.host != nil else {
            throw APIError(code: "configuration")
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        let (data, response) = try await transport.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw APIError(code: "response") }
        var json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
        let retry = response.value(forHTTPHeaderField: "Retry-After").flatMap(Int.init)
        guard (200..<300).contains(response.statusCode) else {
            throw APIError(status: response.statusCode, code: json?["error"] as? String ?? "response",
                           retryAfter: retry, suggestion: json?["suggestion"] as? String)
        }
        if json?["retry_after"] == nil, let retry { json?["retry_after"] = retry }
        guard let json else { throw APIError(code: "response") }
        return json
    }
}
