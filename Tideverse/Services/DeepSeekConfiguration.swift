import Foundation

/// Base64 fragments are obfuscation, not encryption or a secure secret store.
/// Embedded at the app owner's explicit request. Never log this value.
enum DeepSeekConfiguration {
    static let endpoint = URL(string: "https://api.deepseek.com/chat/completions")!
    static let model = "deepseek-flash"

    static var apiKey: String? {
        let parts = [
            "c2stMzA2NmI0YmM5",
            "MTkyNDY0MGE3YWNm",
            "M2JiZWE4OGU3ZTM="
        ]
        guard let data = Data(base64Encoded: parts.joined()),
              let key = String(data: data, encoding: .utf8), !key.isEmpty else { return nil }
        return key
    }
}
