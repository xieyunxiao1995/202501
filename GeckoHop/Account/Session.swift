import Foundation

struct Session: Codable {
    struct User: Codable {
        let email: String
        let uuid: String
        let trafficRemainingBytes: Int64?
        let uploadLimitBytesPerSecond: Int64?
        let downloadLimitBytesPerSecond: Int64?
        let maxSessions: Int?
        let expiresAt: Int64?
    }

    let accessToken: String
    let tokenExpiresAt: Int64
    let user: User
    let activePlanType: String?

    init(response: [String: Any]) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try decoder.decode(Self.self, from: JSONSerialization.data(withJSONObject: response))
    }
}
