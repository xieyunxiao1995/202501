import Foundation

extension APIClient {
    func loadPuzzle(email: String, purpose: String) async throws -> CaptchaChallenge {
        try await CaptchaChallenge(call("/user/captcha/challenge", method: "POST",
            body: ["email": email, "purpose": purpose]))
    }

    func verifyPuzzle(_ challenge: CaptchaChallenge, position: Double) async throws -> String {
        guard (0...(challenge.width - challenge.pieceWidth)).contains(position),
              let x = Int(exactly: position.rounded()) else {
            throw APIError(code: "captcha_position")
        }
        let response = try await call("/user/captcha/verify", method: "POST",
            body: ["challenge_id": challenge.id, "x": x])
        guard let ticket = response["captcha_token"] as? String, !ticket.isEmpty else {
            throw APIError(code: "response")
        }
        return ticket
    }

    func sendAccountCode(email: String, ticket: String, mode: AuthMode) async throws -> TimeInterval {
        let path: String
        switch mode {
        case .register: path = "/user/register-code"
        case .reset: path = "/user/password/reset-code"
        case .login: throw APIError(code: "response")
        }
        let result = try await call(path, method: "POST", body: ["email": email, "captcha_token": ticket])
        guard result["sent"] as? Bool == true else { throw APIError(code: "response") }
        return Self.emailRetryInterval(result["retry_after"] as? Int)
    }

    func resetPassword(email: String, code: String, password: String) async throws {
        let response = try await call("/user/password/reset", method: "POST",
            body: ["email": email, "code": code, "new_password": password])
        guard response["reset"] as? Bool == true else { throw APIError(code: "response") }
    }

    static func emailRetryInterval(_ seconds: Int?) -> TimeInterval {
        guard let seconds, seconds > 0 else { return 60 }
        return Double(min(seconds, 86_400))
    }
}
