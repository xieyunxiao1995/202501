import Foundation
import SwiftData

/// One persisted row per scene; its complete, versioned JSON document is the source of truth.
@Model
final class StoredScene {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var updatedAt: Date
    var isFavorite: Bool
    var isArchived: Bool
    var json: Data

    init(document: SceneDocument, isFavorite: Bool = false, isArchived: Bool = false) {
        id = document.id
        name = document.name
        category = document.kind.rawValue
        updatedAt = Date()
        self.isFavorite = isFavorite
        self.isArchived = isArchived
        json = (try? JSONEncoder().encode(document)) ?? Data()
    }
    var document: SceneDocument {
        (try? JSONDecoder().decode(SceneDocument.self, from: json)) ?? .blank()
    }
    func update(with document: SceneDocument) {
        guard let encoded = try? JSONEncoder().encode(document) else { return }
        id = document.id
        name = document.name
        category = document.kind.rawValue
        updatedAt = Date()
        json = encoded
    }
}
