import Foundation
import SwiftData

@Model
final class ChatRecord {
    @Attribute(.unique) var id: UUID
    var characterID: String
    var role: String
    var text: String
    @Attribute(.externalStorage) var imageData: Data?
    var createdAt: Date
    /// A canonical choice ID for the character's current chapter. AI and local
    /// intent only nominate it; the user applies it through StoryEngine.
    var suggestedChoiceID: String?

    init(id: UUID = UUID(), characterID: String, role: String, text: String, imageData: Data? = nil, createdAt: Date = Date(), suggestedChoiceID: String? = nil) {
        self.id = id
        self.characterID = characterID
        self.role = role
        self.text = text
        self.imageData = imageData
        self.createdAt = createdAt
        self.suggestedChoiceID = suggestedChoiceID
    }
}

@Model
final class JourneyProgress {
    @Attribute(.unique) var storyID: String
    var chapterIndex: Int
    var isComplete: Bool
    var choicesJSON: String
    var updatedAt: Date

    init(storyID: String, chapterIndex: Int = 0, isComplete: Bool = false, choicesJSON: String = "[]", updatedAt: Date = Date()) {
        self.storyID = storyID
        self.chapterIndex = chapterIndex
        self.isComplete = isComplete
        self.choicesJSON = choicesJSON
        self.updatedAt = updatedAt
    }

    var history: [ChoiceHistoryEntry] {
        guard let data = choicesJSON.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([ChoiceHistoryEntry].self, from: data)) ?? []
    }
}

@Model
final class StoryMoment {
    @Attribute(.unique) var id: UUID
    var storyID: String
    var characterID: String
    var chapterID: String
    var title: String
    var decision: String
    var recap: String
    var sceneAsset: String
    var createdAt: Date

    init(id: UUID = UUID(), storyID: String, characterID: String, chapterID: String, title: String, decision: String, recap: String, sceneAsset: String, createdAt: Date = Date()) {
        self.id = id
        self.storyID = storyID
        self.characterID = characterID
        self.chapterID = chapterID
        self.title = title
        self.decision = decision
        self.recap = recap
        self.sceneAsset = sceneAsset
        self.createdAt = createdAt
    }
}

@Model
final class MemoryRecord {
    @Attribute(.unique) var id: UUID
    var characterID: String
    var note: String
    var isPinned: Bool
    var createdAt: Date

    init(id: UUID = UUID(), characterID: String, note: String, isPinned: Bool = true, createdAt: Date = Date()) {
        self.id = id
        self.characterID = characterID
        self.note = note
        self.isPinned = isPinned
        self.createdAt = createdAt
    }
}
