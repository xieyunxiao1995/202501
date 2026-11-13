import Foundation
import SwiftData

@MainActor
struct StoryEngine {
    enum StoryError: LocalizedError {
        case alreadyFinished
        case invalidChoice
        case outOfDate

        var errorDescription: String? {
            switch self {
            case .alreadyFinished: return "This story is already complete."
            case .invalidChoice: return "That choice is not part of this chapter."
            case .outOfDate: return "The chapter has changed. Please review your choices."
            }
        }
    }

    @discardableResult
    static func choose(_ choice: StoryChoice, in chapter: ChapterDefinition, story: StoryDefinition, character: CharacterDefinition, context: ModelContext) throws -> StoryMoment {
        let storyID = story.id
        let descriptor = FetchDescriptor<JourneyProgress>(predicate: #Predicate { $0.storyID == storyID })
        let existing = try context.fetch(descriptor).first
        let progress = existing ?? JourneyProgress(storyID: storyID)
        guard !progress.isComplete else { throw StoryError.alreadyFinished }
        guard progress.chapterIndex >= 0, progress.chapterIndex < story.chapters.count, story.chapters[progress.chapterIndex].id == chapter.id else { throw StoryError.outOfDate }
        guard progress.history.count == progress.chapterIndex else { throw StoryError.outOfDate }
        guard story.characterID == character.id,
              let canonicalChoice = story.chapters[progress.chapterIndex].choices.first(where: { $0.id == choice.id }) else { throw StoryError.invalidChoice }
        let oldIndex = progress.chapterIndex
        let oldComplete = progress.isComplete
        let oldChoices = progress.choicesJSON
        let oldUpdatedAt = progress.updatedAt
        let item = ChoiceHistoryEntry(id: UUID(), chapterID: chapter.id, chapterTitle: chapter.title, choiceID: canonicalChoice.id, choiceLabel: canonicalChoice.label, outcome: canonicalChoice.outcome, selectedAt: Date())
        let updatedHistory = progress.history + [item]
        let encoded = try JSONEncoder().encode(updatedHistory)
        progress.choicesJSON = String(decoding: encoded, as: UTF8.self)
        progress.chapterIndex += 1
        progress.isComplete = progress.chapterIndex >= story.chapters.count
        progress.updatedAt = Date()
        if existing == nil { context.insert(progress) }
        let moment = StoryMoment(storyID: story.id, characterID: character.id, chapterID: chapter.id, title: chapter.title, decision: canonicalChoice.label, recap: canonicalChoice.outcome, sceneAsset: character.sceneAsset)
        context.insert(moment)
        do { try context.save() }
        catch {
            context.delete(moment)
            if existing == nil { context.delete(progress) }
            else {
                progress.chapterIndex = oldIndex
                progress.isComplete = oldComplete
                progress.choicesJSON = oldChoices
                progress.updatedAt = oldUpdatedAt
            }
            throw error
        }
        return moment
    }

    static func progress(for story: StoryDefinition, in records: [JourneyProgress]) -> JourneyProgress? {
        records.first(where: { $0.storyID == story.id })
    }

    /// Reopens a finished journey when authored chapters were added after the
    /// user completed it. Returns true when the stored completion flag changed.
    @discardableResult
    static func reopenIfExtended(_ progress: JourneyProgress, story: StoryDefinition, context: ModelContext) throws -> Bool {
        guard progress.isComplete, progress.chapterIndex < story.chapters.count,
              progress.history.count == progress.chapterIndex else { return false }
        progress.isComplete = false
        try context.save()
        return true
    }

    /// The most recent earlier decision that this chapter can acknowledge.
    static func echo(for chapter: ChapterDefinition, history: [ChoiceHistoryEntry]) -> String? {
        guard let echoes = chapter.echoes else { return nil }
        for entry in history.reversed() where echoes[entry.choiceID] != nil {
            return echoes[entry.choiceID]
        }
        return nil
    }
}
