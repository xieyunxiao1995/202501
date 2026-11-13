import Foundation

/// Local drafts never enter prompts or backups until the user sends a message.
struct ChatDraftStore {
    private static var directory: URL {
        URL.applicationSupportDirectory.appending(path: "Tideverse/Drafts", directoryHint: .isDirectory)
    }

    static func load(characterID: String) throws -> String {
        let url = directory.appending(path: characterID + ".txt")
        guard FileManager.default.fileExists(atPath: url.path) else { return "" }
        let data = try Data(contentsOf: url)
        guard data.count <= 100_000, let text = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        return text
    }

    static func save(_ text: String, characterID: String) throws {
        let url = directory.appending(path: characterID + ".txt")
        if text.isEmpty {
            if FileManager.default.fileExists(atPath: url.path) { try FileManager.default.removeItem(at: url) }
            return
        }
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try Data(text.prefix(20_000).utf8).write(to: url, options: [.atomic, .completeFileProtection])
    }

    static func delete(characterID: String) throws {
        try save("", characterID: characterID)
    }

    static func deleteAll() throws {
        if FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.removeItem(at: directory)
        }
    }
}
