import Foundation

struct ChatTurn: Codable {
    let role: String
    let text: String
}

struct StoryChoiceContext: Codable {
    let chapterID: String
    let choiceID: String
}

struct GatewayChatRequest: Encodable {
    let characterID: String
    let chapterIndex: Int
    let chapterID: String?
    let chapterTitle: String
    let storyChoices: [StoryChoiceContext]
    let recentMessages: [ChatTurn]
    let approvedMemories: [String]
    let message: String
    let imageBase64: String?
}

struct GatewayChatReply: Decodable {
    let reply: String
    /// Canonical current-chapter choice nominated by the character. Validated
    /// again locally before the user can apply it.
    let suggestedChoiceID: String?
}

enum ChatServiceError: LocalizedError {
    case unconfigured
    case connectionUnavailable
    case secureConnectionFailed
    case timedOut
    case consentRequired
    case invalidContext
    case contentBlocked
    case incompleteReply
    case invalidResponse
    case requestFailed(Int)
    case emptyReply
    case responseTooLarge

    static func networkFailure(_ code: URLError.Code) -> ChatServiceError {
        switch code {
        case .timedOut: return .timedOut
        case .secureConnectionFailed, .serverCertificateUntrusted, .serverCertificateHasBadDate,
             .serverCertificateHasUnknownRoot, .serverCertificateNotYetValid,
             .clientCertificateRejected, .clientCertificateRequired:
            return .secureConnectionFailed
        default: return .connectionUnavailable
        }
    }

    var errorDescription: String? {
        switch self {
        case .connectionUnavailable: return "The AI service could not be reached. Check your connection, then request a reply again. Your message is saved."
        case .secureConnectionFailed: return "A secure connection to the AI service could not be established. Try requesting the reply again. Your message is saved."
        case .timedOut: return "The AI service took too long to reply. Your message is saved; you can request a reply again."
        case .consentRequired: return "Review DeepSeek data permission before sending a message."
        case .invalidContext: return "This message or its story context is invalid. Reopen the conversation and try again."
        case .contentBlocked: return "This request could not be answered safely. Try a different story question."
        case .incompleteReply: return "The AI could not finish its reply. Your message is saved; try a shorter question."
        case .requestFailed(402): return "The AI service's usage balance is unavailable. Please contact support."
        case .unconfigured: return "AI conversation is currently unavailable. Your offline stories remain available."
        case .invalidResponse: return "The AI connection returned an unexpected response. Your message is saved."
        case .requestFailed(401), .requestFailed(403): return "The AI service could not authorize this request. Contact support if this continues."
        case .requestFailed(429): return "The AI service is busy or your request limit was reached. Please wait before trying again."
        case .requestFailed(500...599): return "The AI service is temporarily unavailable. Your message is saved; try again later."
        case .requestFailed: return "This message could not be processed. Review it before trying again."
        case .emptyReply: return "No answer was received. Your message is saved."
        case .responseTooLarge: return "The service response exceeded the supported limit. Please try again later."
        }
    }
}

struct AIChatService {
    static func send(_ payload: GatewayChatRequest, consentDefaults: UserDefaults = .standard) async throws -> GatewayChatReply {
        do {
            return try await performRequest(payload, consentDefaults: consentDefaults)
        } catch let error as URLError {
            if error.code == .cancelled { throw CancellationError() }
            throw ChatServiceError.networkFailure(error.code)
        }
    }

    private static func performRequest(_ payload: GatewayChatRequest, consentDefaults: UserDefaults) async throws -> GatewayChatReply {
        guard ConsentService.isGranted(in: consentDefaults) else { throw ChatServiceError.consentRequired }
        try Task.checkCancellation()
        let request = try DeepSeekChatAdapter.makeRequest(payload)
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        guard let response = response as? HTTPURLResponse else { throw ChatServiceError.invalidResponse }
        guard (200...299).contains(response.statusCode) else { throw ChatServiceError.requestFailed(response.statusCode) }
        guard response.mimeType?.lowercased() == "application/json" else { throw ChatServiceError.invalidResponse }
        guard response.expectedContentLength <= 128_000 else { throw ChatServiceError.responseTooLarge }
        var data = Data()
        for try await byte in bytes {
            try Task.checkCancellation()
            guard data.count < 128_000 else { throw ChatServiceError.responseTooLarge }
            data.append(byte)
        }
        try Task.checkCancellation()
        guard ConsentService.isGranted(in: consentDefaults) else { throw CancellationError() }
        return try DeepSeekChatAdapter.parseResponse(data, for: payload)
    }
}
