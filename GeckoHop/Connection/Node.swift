import Foundation

struct Node: Identifiable, Decodable {
    let id: String
    let nameZh: String?
    let nameEn: String?
    let regionCode: String

    var name: String {
        let names = isChinese ? [nameZh, nameEn] : [nameEn, nameZh]
        return names.compactMap { $0 }.first { !$0.trimmingCharacters(in: .whitespaces).isEmpty } ?? id
    }

    static func decode(_ response: [String: Any]) throws -> [Self] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let nodes = response["nodes"] as? [[String: Any]] else { throw APIError(code: "response") }
        return try decoder.decode([Self].self, from: JSONSerialization.data(withJSONObject: nodes))
    }
}
