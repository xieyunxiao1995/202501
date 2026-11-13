import Foundation

struct CharacterDefinition: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let age: Int
    let title: String
    let genre: String
    let tagline: String
    let profession: String
    let biography: String
    let personality: String
    let voice: String
    let colorHex: String
    let portraitAsset: String
    let avatarAsset: String
    let sceneAsset: String
    let storyID: String
    let storyTitle: String
    let openingLine: String
    let goal: String
    let boundary: String
    let aiDisclosure: String
}

struct StoryDefinition: Codable, Identifiable, Hashable {
    let id: String
    let characterID: String
    let title: String
    let tagline: String
    let premise: String
    let chapters: [ChapterDefinition]
}

struct ChapterDefinition: Codable, Identifiable, Hashable {
    let id: String
    let number: Int
    let act: Int?
    let title: String
    let setting: String
    let intro: String
    /// Prior choice IDs mapped to a sentence that acknowledges that earlier decision.
    let echoes: [String: String]?
    let objective: String
    let choices: [StoryChoice]

    var actLabel: String { "Act \(act ?? 1)" }
}

struct StoryChoice: Codable, Identifiable, Hashable {
    let id: String
    let label: String
    let outcome: String
    let memoryHint: String
}

struct ChoiceHistoryEntry: Codable, Identifiable {
    let id: UUID
    let chapterID: String
    let chapterTitle: String
    let choiceID: String
    let choiceLabel: String
    let outcome: String
    let selectedAt: Date
}
