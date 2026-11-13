import Foundation

/// Gateway limits are UTF-16 lengths. Preserve whole graphemes when selecting
/// older context so emoji or composed text never becomes malformed or oversized.
enum ChatTextBudget {
    static let message = 4000
    static let memory = 500
    static let history = 2400

    static func prefix(_ text: String, limit: Int) -> String {
        var result = ""
        var used = 0
        for character in text {
            let count = String(character).utf16.count
            guard used + count <= limit else { break }
            result.append(character)
            used += count
        }
        return result
    }
}
