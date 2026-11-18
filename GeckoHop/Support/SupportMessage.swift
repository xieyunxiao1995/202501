import Foundation

struct SupportMessage: Identifiable, Decodable {
    struct Attachment: Decodable {
        let url: URL?
        let expired: Bool?
    }
    let seq: Int
    let sender: String
    let text: String?
    let image: Attachment?
    let diagnostics: Bool?
    let createdAt: Double?
    var id: Int { seq }
}
