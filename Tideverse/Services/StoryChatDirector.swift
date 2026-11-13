import Foundation
import SwiftData

/// Connects free-form conversation to the authored story. A model or a local
/// intent match may only nominate an existing choice for the current chapter;
/// `StoryEngine` remains the only writer of chapter progress.
@MainActor
enum StoryChatDirector {
    struct Scene {
        let story: StoryDefinition
        let chapter: ChapterDefinition
        let chapterIndex: Int
        let history: [ChoiceHistoryEntry]
        let echo: String?

        var positionLabel: String { "Chapter \(chapterIndex + 1) of \(story.chapters.count)" }
        var nextChapter: ChapterDefinition? {
            let next = chapterIndex + 1
            return story.chapters.indices.contains(next) ? story.chapters[next] : nil
        }
    }

    struct IntentMatch {
        let choice: StoryChoice
        let score: Double
        let keywords: [String]
    }

    static func scene(story: StoryDefinition?, progress: JourneyProgress?) -> Scene? {
        guard let story else { return nil }
        let index = progress?.chapterIndex ?? 0
        guard story.chapters.indices.contains(index) else { return nil }
        let chapter = story.chapters[index]
        let history = progress?.history ?? []
        return Scene(story: story, chapter: chapter, chapterIndex: index,
                     history: history, echo: StoryEngine.echo(for: chapter, history: history))
    }

    static func validate(choiceID: String?, in scene: Scene) -> StoryChoice? {
        guard let choiceID else { return nil }
        return scene.chapter.choices.first(where: { $0.id == choiceID })
    }

    @discardableResult
    static func decide(choiceID: String, scene: Scene, character: CharacterDefinition, context: ModelContext) throws -> StoryMoment {
        guard let choice = validate(choiceID: choiceID, in: scene) else { throw StoryEngine.StoryError.invalidChoice }
        return try StoryEngine.choose(choice, in: scene.chapter, story: scene.story, character: character, context: context)
    }

    // MARK: - Free-form intent

    /// Matches what the user said against the current chapter's authored
    /// directions. Ambiguous messages deliberately return nil so the story
    /// keeps listening instead of guessing.
    static func match(_ text: String, in chapter: ChapterDefinition) -> IntentMatch? {
        let userTokens = tokens(in: text)
        guard !userTokens.isEmpty else { return nil }
        let phrase = normalized(text)
        let scored = chapter.choices.map { choice -> (StoryChoice, Double, [String]) in
            var score = 0.0
            var matched: [String] = []
            if phrase.contains(normalized(choice.label)) {
                score += 8
                matched.append(choice.label)
            }
            for token in tokens(in: choice.label) where userTokens.contains(token) {
                score += 4
                if !matched.contains(token) { matched.append(token) }
            }
            for token in tokens(in: choice.memoryHint) where userTokens.contains(token) {
                score += 1.25
                if !matched.contains(token) { matched.append(token) }
            }
            for token in tokens(in: choice.outcome) where userTokens.contains(token) {
                score += 0.75
                if !matched.contains(token) { matched.append(token) }
            }
            return (choice, score, matched)
        }.sorted { $0.1 > $1.1 }

        guard let best = scored.first, best.1 >= 4 else { return nil }
        if scored.count > 1, scored[1].1 >= 4, best.1 - scored[1].1 < 2.5 { return nil }
        return IntentMatch(choice: best.0, score: best.1, keywords: best.2)
    }

    // MARK: - Authored fallback

    /// Used when no AI service is configured. Everything here is bundled,
    /// authored prose, and the reply never leaves the device.
    static func authoredReply(to text: String, scene: Scene, character: CharacterDefinition, userTurnCount: Int) -> String {
        if let match = match(text, in: scene.chapter) {
            return "I can work with that. \(match.choice.memoryHint) Tell me what you notice, and we can decide what it means."
        }
        if let echo = scene.echo, userTurnCount <= 1 {
            return "\(echo) \(scene.chapter.objective) What would you do first?"
        }
        let openings = [
            "I keep thinking about \(scene.chapter.setting.lowercased()). \(scene.chapter.objective) What is your instinct?",
            "\(character.openingLine) Tell me what you would try first.",
            "I am glad you are here. Nothing about \(scene.chapter.setting.lowercased()) feels simple. What do you want me to do?",
            "There is more than one way through this. Say what you are thinking, and I will follow your lead."
        ]
        return openings[userTurnCount % openings.count]
    }

    // MARK: - Story beats

    static func decisionText(moment: StoryMoment, choice: StoryChoice, scene: Scene) -> String {
        var text = "Decision · \(scene.chapter.title)\n\n\(choice.label)\n\n\(choice.outcome)"
        if scene.nextChapter == nil {
            text += "\n\nThis journey is complete. The conversation can keep going."
        }
        return text
    }

    static func leadInText(for chapter: ChapterDefinition) -> String {
        "Chapter \(chapter.number) · \(chapter.title)\n\(chapter.setting)\n\n\(chapter.intro)\n\nObjective: \(chapter.objective)"
    }

    // MARK: - Tokenization

    private static let stopWords: Set<String> = [
        "the", "a", "an", "and", "or", "to", "of", "in", "on", "at", "for", "with",
        "is", "are", "was", "were", "be", "been", "being", "it", "its", "this", "that",
        "these", "those", "i", "we", "you", "he", "she", "they", "me", "us", "my",
        "our", "your", "his", "her", "their", "do", "does", "did", "can", "could",
        "should", "would", "will", "shall", "may", "might", "must", "not", "no", "yes",
        "if", "then", "than", "so", "but", "as", "by", "from", "about", "into", "over",
        "under", "after", "before", "up", "down", "out", "just", "really", "very",
        "maybe", "perhaps", "let", "lets", "want", "wants", "wanted", "need", "needs",
        "think", "thinking", "feel", "like", "please", "okay", "ok", "what", "how",
        "why", "when", "where", "who", "there", "here", "now", "first", "next"
    ]

    private static let synonymGroups: [[String]] = [
        ["study", "examine", "inspect", "analyze", "analyse", "investigate", "check", "look", "scrutinize", "scan", "search"],
        ["read", "decode", "translate", "interpret", "unfold"],
        ["visit", "go", "walk", "travel", "head", "explore", "approach"],
        ["protect", "preserve", "save", "keep", "hide", "guard", "conceal", "secure"],
        ["publish", "share", "reveal", "expose", "tell", "announce", "deliver", "hand"],
        ["ask", "question", "interview", "talk", "speak", "inquire", "consult"],
        ["follow", "chase", "track", "trace", "pursue"],
        ["wait", "stay", "observe", "watch", "listen", "pause"],
        ["take", "accept", "hold", "grab", "pick"],
        ["refuse", "decline", "reject", "leave", "abandon"],
        ["help", "assist", "support", "aid"],
        ["warn", "alert", "caution"],
        ["trust", "believe", "confide"],
        ["lie", "deceive", "trick", "bluff"]
    ]

    private static let canonicalSynonyms: [String: String] = {
        var map: [String: String] = [:]
        for group in synonymGroups {
            guard let canonical = group.first else { continue }
            for word in group where map[word] == nil { map[word] = canonical }
        }
        return map
    }()

    private static func tokens(in text: String) -> Set<String> {
        let words = text.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted)
        var result: Set<String> = []
        for word in words where word.count > 1 {
            guard !stopWords.contains(word) else { continue }
            result.insert(canonicalSynonyms[word] ?? word)
        }
        return result
    }

    private static func normalized(_ text: String) -> String {
        text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
