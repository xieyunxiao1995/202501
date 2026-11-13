import Foundation
import SwiftData
import UniformTypeIdentifiers
import SwiftUI

struct JSONFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var data: Data

    init(data: Data) { self.data = data }

    init(configuration: ReadConfiguration) throws {
        guard let raw = configuration.file.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
        data = raw
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

struct ArchiveMessage: Codable {
    let id: UUID
    let characterID: String
    let role: String
    let text: String
    let imageData: Data?
    let createdAt: Date
}

struct ArchiveMemory: Codable {
    let id: UUID
    let characterID: String
    let note: String
    let isPinned: Bool
    let createdAt: Date
}

struct ArchiveMoment: Codable {
    let id: UUID
    let storyID: String
    let characterID: String
    let chapterID: String
    let title: String
    let decision: String
    let recap: String
    let sceneAsset: String
    let createdAt: Date
}

struct ArchiveProgress: Codable {
    let storyID: String
    let chapterIndex: Int
    let isComplete: Bool
    let choicesJSON: String
    let updatedAt: Date
}

struct TideverseArchive: Codable {
    let formatVersion: Int
    let exportedAt: Date
    let messages: [ArchiveMessage]
    let memories: [ArchiveMemory]
    let moments: [ArchiveMoment]
    let progresses: [ArchiveProgress]
}

enum BackupError: LocalizedError {
    case unsupportedArchive
    case archiveTooLarge
    case invalidRecord

    var errorDescription: String? {
        switch self {
        case .unsupportedArchive: return "This is not a supported Tideverse data archive."
        case .archiveTooLarge: return "This archive exceeds the 35 MB restore limit. When exporting, try turning off Include Attached Photos. No data has been removed."
        case .invalidRecord: return "The archive contains an invalid or unsupported character or story record."
        }
    }
}

@MainActor
struct BackupService {
    static func export(from context: ModelContext, includePhotos: Bool = true) throws -> Data {
        let messages = try context.fetch(FetchDescriptor<ChatRecord>()).map {
            ArchiveMessage(id: $0.id, characterID: $0.characterID, role: $0.role, text: $0.text, imageData: includePhotos ? $0.imageData : nil, createdAt: $0.createdAt)
        }
        let memories = try context.fetch(FetchDescriptor<MemoryRecord>()).map {
            ArchiveMemory(id: $0.id, characterID: $0.characterID, note: $0.note, isPinned: $0.isPinned, createdAt: $0.createdAt)
        }
        let moments = try context.fetch(FetchDescriptor<StoryMoment>()).map {
            ArchiveMoment(id: $0.id, storyID: $0.storyID, characterID: $0.characterID, chapterID: $0.chapterID, title: $0.title, decision: $0.decision, recap: $0.recap, sceneAsset: $0.sceneAsset, createdAt: $0.createdAt)
        }
        let progresses = try context.fetch(FetchDescriptor<JourneyProgress>()).map {
            ArchiveProgress(storyID: $0.storyID, chapterIndex: $0.chapterIndex, isComplete: $0.isComplete, choicesJSON: $0.choicesJSON, updatedAt: $0.updatedAt)
        }
        let backup = TideverseArchive(formatVersion: 1, exportedAt: Date(), messages: messages, memories: memories, moments: moments, progresses: progresses)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(backup)
        guard data.count <= maximumArchiveSize else { throw BackupError.archiveTooLarge }
        return data
    }

    static let maximumArchiveSize = 35_000_000

    /// Validate before showing an import confirmation; this never touches a model context.
    static func previewArchive(_ data: Data) throws -> TideverseArchive {
        guard data.count <= maximumArchiveSize else { throw BackupError.archiveTooLarge }
        let archive: TideverseArchive
        do { archive = try JSONDecoder().decode(TideverseArchive.self, from: data) }
        catch { throw BackupError.unsupportedArchive }
        guard archive.formatVersion == 1 else { throw BackupError.unsupportedArchive }
        let characters = Set(ContentRepository.shared.characters.map(\.id))
        let stories = Dictionary(uniqueKeysWithValues: ContentRepository.shared.stories.map { ($0.id, $0) })
        guard Set(archive.messages.map(\.id)).count == archive.messages.count,
              Set(archive.memories.map(\.id)).count == archive.memories.count,
              Set(archive.moments.map(\.id)).count == archive.moments.count,
              Set(archive.progresses.map(\.storyID)).count == archive.progresses.count,
              archive.messages.count <= 100_000,
              archive.moments.count <= 10_000,
              archive.memories.count <= 10_000,
              archive.progresses.count <= stories.count,
              archive.messages.allSatisfy({ characters.contains($0.characterID) && ["user", "assistant", "story"].contains($0.role) && $0.text.count <= 20_000 && ($0.imageData?.count ?? 0) <= 1_800_000 }),
              archive.memories.allSatisfy({ characters.contains($0.characterID) && $0.note.count <= 500 }),
              archive.moments.allSatisfy({ moment in
                  guard let story = stories[moment.storyID], story.characterID == moment.characterID,
                        story.chapters.contains(where: { $0.id == moment.chapterID }) else { return false }
                  return moment.title.count <= 500 && moment.decision.count <= 500 && moment.recap.count <= 20_000
              }),
              archive.progresses.allSatisfy({ item in
                  guard let story = stories[item.storyID] else { return false }
                  guard (0...story.chapters.count).contains(item.chapterIndex),
                        (item.isComplete == (item.chapterIndex == story.chapters.count)
                         || (item.isComplete && [4, 8].contains(item.chapterIndex)
                             && item.chapterIndex < story.chapters.count)),
                        item.choicesJSON.utf8.count <= 100_000,
                        let data = item.choicesJSON.data(using: .utf8),
                        let history = try? JSONDecoder().decode([ChoiceHistoryEntry].self, from: data),
                        history.count == item.chapterIndex,
                        Set(history.map(\.id)).count == history.count else { return false }
                  return zip(history, story.chapters).allSatisfy { entry, chapter in
                      entry.chapterID == chapter.id && chapter.choices.contains(where: { $0.id == entry.choiceID })
                  }
              }) else { throw BackupError.invalidRecord }
        // IDs select canonical content. Imported prose and asset names never
        // get to replace authored outcomes or select unrelated bundled images.
        let histories = try Dictionary(uniqueKeysWithValues: archive.progresses.map { entry in
            (entry.storyID, try JSONDecoder().decode([ChoiceHistoryEntry].self, from: Data(entry.choicesJSON.utf8)))
        })
        let normalizedProgresses = try archive.progresses.map { entry -> ArchiveProgress in
            guard let story = stories[entry.storyID], let history = histories[entry.storyID] else { throw BackupError.invalidRecord }
            let normalized = try zip(history, story.chapters).map { old, chapter -> ChoiceHistoryEntry in
                guard let choice = chapter.choices.first(where: { $0.id == old.choiceID }) else { throw BackupError.invalidRecord }
                return ChoiceHistoryEntry(id: old.id, chapterID: chapter.id, chapterTitle: chapter.title,
                                          choiceID: choice.id, choiceLabel: choice.label, outcome: choice.outcome, selectedAt: old.selectedAt)
            }
            let json = String(decoding: try JSONEncoder().encode(normalized), as: UTF8.self)
            return ArchiveProgress(storyID: entry.storyID, chapterIndex: entry.chapterIndex,
                                   isComplete: entry.chapterIndex == story.chapters.count, choicesJSON: json, updatedAt: entry.updatedAt)
        }
        let normalizedMoments = try archive.moments.map { entry -> ArchiveMoment in
            guard let story = stories[entry.storyID],
                  let chapter = story.chapters.first(where: { $0.id == entry.chapterID }),
                  let selection = histories[entry.storyID]?.first(where: { $0.chapterID == chapter.id }),
                  let choice = chapter.choices.first(where: { $0.id == selection.choiceID }),
                  let character = ContentRepository.shared.character(id: entry.characterID) else { throw BackupError.invalidRecord }
            return ArchiveMoment(id: entry.id, storyID: story.id, characterID: character.id, chapterID: chapter.id,
                                 title: chapter.title, decision: choice.label, recap: choice.outcome,
                                 sceneAsset: character.sceneAsset, createdAt: entry.createdAt)
        }
        return TideverseArchive(formatVersion: archive.formatVersion, exportedAt: archive.exportedAt,
                                messages: archive.messages, memories: archive.memories,
                                moments: normalizedMoments, progresses: normalizedProgresses)
    }

    static func importArchive(_ data: Data, into context: ModelContext) throws -> String {
        let archive = try previewArchive(data)
        let normalizedMoments = archive.moments
        let normalizedProgresses = archive.progresses
        let existingMessages = Set(try context.fetch(FetchDescriptor<ChatRecord>()).map(\.id))
        let existingMemories = Set(try context.fetch(FetchDescriptor<MemoryRecord>()).map(\.id))
        let existingMoments = Set(try context.fetch(FetchDescriptor<StoryMoment>()).map(\.id))
        let existingProgress = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<JourneyProgress>()).map { ($0.storyID, $0) })
        var added = 0
        var updated = 0
        for entry in archive.messages where !existingMessages.contains(entry.id) {
            context.insert(ChatRecord(id: entry.id, characterID: entry.characterID, role: entry.role, text: entry.text, imageData: entry.imageData, createdAt: entry.createdAt)); added += 1
        }
        for entry in archive.memories where !existingMemories.contains(entry.id) {
            context.insert(MemoryRecord(id: entry.id, characterID: entry.characterID, note: entry.note, isPinned: entry.isPinned, createdAt: entry.createdAt)); added += 1
        }
        for entry in normalizedMoments where !existingMoments.contains(entry.id) {
            context.insert(StoryMoment(id: entry.id, storyID: entry.storyID, characterID: entry.characterID, chapterID: entry.chapterID, title: entry.title, decision: entry.decision, recap: entry.recap, sceneAsset: entry.sceneAsset, createdAt: entry.createdAt)); added += 1
        }
        for entry in normalizedProgresses {
            if let current = existingProgress[entry.storyID] {
                if entry.updatedAt > current.updatedAt {
                    current.chapterIndex = entry.chapterIndex
                    current.isComplete = entry.isComplete
                    current.choicesJSON = entry.choicesJSON
                    current.updatedAt = entry.updatedAt
                    updated += 1
                }
            } else {
                context.insert(JourneyProgress(storyID: entry.storyID, chapterIndex: entry.chapterIndex, isComplete: entry.isComplete, choicesJSON: entry.choicesJSON, updatedAt: entry.updatedAt)); added += 1
            }
        }
        do { try context.save() }
        catch { context.rollback(); throw error }
        return "Added \(added.formatted()) records and updated \(updated.formatted()) journeys from newer archive progress. Existing conversations and memories were kept."
    }

    static func deleteConversation(characterID: String, from context: ModelContext) throws {
        let descriptor = FetchDescriptor<ChatRecord>(predicate: #Predicate { $0.characterID == characterID })
        for record in try context.fetch(descriptor) { context.delete(record) }
        do { try context.save() }
        catch { context.rollback(); throw error }
        try ChatDraftStore.delete(characterID: characterID)
    }

    static func deleteChats(from context: ModelContext) throws {
        try ChatDraftStore.deleteAll()
        for item in try context.fetch(FetchDescriptor<ChatRecord>()) { context.delete(item) }
        do { try context.save() }
        catch { context.rollback(); throw error }
    }

    static func deleteMemories(from context: ModelContext) throws {
        for item in try context.fetch(FetchDescriptor<MemoryRecord>()) { context.delete(item) }
        do { try context.save() }
        catch { context.rollback(); throw error }
    }

    static func deleteAll(from context: ModelContext) throws {
        try ChatDraftStore.deleteAll()
        for item in try context.fetch(FetchDescriptor<ChatRecord>()) { context.delete(item) }
        for item in try context.fetch(FetchDescriptor<MemoryRecord>()) { context.delete(item) }
        for item in try context.fetch(FetchDescriptor<StoryMoment>()) { context.delete(item) }
        for item in try context.fetch(FetchDescriptor<JourneyProgress>()) { context.delete(item) }
        do { try context.save() }
        catch { context.rollback(); throw error }
    }
}
