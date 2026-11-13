import Foundation

/// Author-created worlds and chapter decisions are bundled, versioned JSON.
/// AI-generated prose never becomes a source of truth for chapter progression.
final class ContentRepository {
    static let shared = ContentRepository()

    let characters: [CharacterDefinition]
    let stories: [StoryDefinition]

    private init() {
        characters = Self.load("characters", as: [CharacterDefinition].self)
        stories = Self.load("stories", as: [StoryDefinition].self)
        precondition(!characters.isEmpty && characters.count == stories.count, "Every bundled character needs an authored story")
        precondition(Set(characters.map(\.id)).count == characters.count, "Character IDs must be unique")
    }

    var chapterCount: Int { stories.reduce(0) { $0 + $1.chapters.count } }
    var outcomeCount: Int { stories.reduce(0) { $0 + $1.chapters.reduce(0) { $0 + $1.choices.count } } }

    func character(id: String) -> CharacterDefinition? {
        characters.first(where: { $0.id == id })
    }

    func story(id: String) -> StoryDefinition? {
        stories.first(where: { $0.id == id })
    }

    func story(for character: CharacterDefinition) -> StoryDefinition? {
        story(id: character.storyID)
    }

    private static func load<T: Decodable>(_ name: String, as type: T.Type) -> T {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(type, from: data) else {
            fatalError("Missing or invalid bundled \(name).json")
        }
        return result
    }
}
