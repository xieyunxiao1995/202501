import Foundation

/// A sheet item carries the actual pending action, avoiding stale Boolean captures.
enum ChatConsentAction: Identifiable {
    case send
    case retry(UUID)

    var id: String {
        switch self {
        case .send: return "send"
        case .retry(let messageID): return "retry-\(messageID)"
        }
    }
}
