import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class ChatViewModel {
    private(set) var isSending = false
    private(set) var sendingMessageID: UUID?
    var errorMessage: String?
    @ObservationIgnored private var currentTask: Task<Void, Never>?

    /// Returns true only when the local message was saved and a request started.
    @discardableResult
    func send(character: CharacterDefinition, text: String, imageData: Data?, allMessages: [ChatRecord], memories: [MemoryRecord], chapter: ChapterDefinition?, chapterIndex: Int, storyChoices: [StoryChoiceContext], context: ModelContext) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canRequest(text: trimmed, imageData: imageData) else { return false }
        let message = ChatRecord(characterID: character.id, role: "user", text: trimmed, imageData: imageData)
        context.insert(message)
        do { try context.save() }
        catch {
            context.delete(message)
            errorMessage = "Could not save your message: \(error.localizedDescription)"
            return false
        }
        startReply(to: message, character: character, allMessages: allMessages, memories: memories,
                   chapter: chapter, chapterIndex: chapterIndex, storyChoices: storyChoices, context: context)
        return true
    }

    /// A deliberate retry reuses the original saved message. It never inserts a
    /// duplicate turn, and only the latest unanswered user turn can be retried.
    @discardableResult
    func retry(_ message: ChatRecord, character: CharacterDefinition, allMessages: [ChatRecord], memories: [MemoryRecord], chapter: ChapterDefinition?, chapterIndex: Int, storyChoices: [StoryChoiceContext], context: ModelContext) -> Bool {
        guard message.characterID == character.id, message.role == "user",
              allMessages.filter({ $0.characterID == character.id && $0.role != "story" }).max(by: { $0.createdAt < $1.createdAt })?.id == message.id else {
            errorMessage = "Only the most recent unanswered message can request a reply."
            return false
        }
        guard canRequest(text: message.text, imageData: message.imageData) else { return false }
        startReply(to: message, character: character, allMessages: allMessages, memories: memories,
                   chapter: chapter, chapterIndex: chapterIndex, storyChoices: storyChoices, context: context)
        return true
    }

    /// Local authored reply used when no AI service is configured. It never
    /// leaves the device and only nominates a canonical choice for the user to apply.
    @discardableResult
    func sendAuthored(character: CharacterDefinition, text: String, imageData: Data? = nil, story: StoryDefinition?, progress: JourneyProgress?, allMessages: [ChatRecord], context: ModelContext) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !isSending, !trimmed.isEmpty || imageData != nil else { return false }
        guard trimmed.utf16.count <= ChatTextBudget.message else {
            errorMessage = "This message is too long. Shorten it before sending; your draft is still here."
            return false
        }
        let message = ChatRecord(characterID: character.id, role: "user", text: trimmed, imageData: imageData)
        context.insert(message)
        do { try context.save() }
        catch {
            context.delete(message)
            errorMessage = "Could not save your message: \(error.localizedDescription)"
            return false
        }

        let scene = StoryChatDirector.scene(story: story, progress: progress)
        let turnCount = allMessages.filter { $0.characterID == character.id && $0.role == "user" }.count + 1
        let replyText: String
        let suggestion: String?
        if let scene {
            replyText = trimmed.isEmpty
                ? "I have the photo. \(StoryChatDirector.authoredReply(to: "", scene: scene, character: character, userTurnCount: turnCount))"
                : StoryChatDirector.authoredReply(to: trimmed, scene: scene, character: character, userTurnCount: turnCount)
            suggestion = StoryChatDirector.match(trimmed, in: scene.chapter)?.choice.id
        } else {
            replyText = character.openingLine
            suggestion = nil
        }
        let answer = ChatRecord(characterID: character.id, role: "assistant", text: replyText,
                                createdAt: Date().addingTimeInterval(0.001), suggestedChoiceID: suggestion)
        context.insert(answer)
        do { try context.save() }
        catch {
            context.delete(answer)
            errorMessage = "Could not save this reply: \(error.localizedDescription)"
        }
        return true
    }

    /// Appends the authored story beats after a decision has already been
    /// committed by StoryEngine. Chat never writes progress itself.
    func recordDecision(choice: StoryChoice, scene: StoryChatDirector.Scene, moment: StoryMoment, character: CharacterDefinition, context: ModelContext) {
        let decision = ChatRecord(characterID: character.id, role: "story",
                                  text: StoryChatDirector.decisionText(moment: moment, choice: choice, scene: scene),
                                  createdAt: Date().addingTimeInterval(0.001))
        context.insert(decision)
        var leadIn: ChatRecord?
        if let next = scene.nextChapter {
            let record = ChatRecord(characterID: character.id, role: "story",
                                    text: StoryChatDirector.leadInText(for: next),
                                    createdAt: Date().addingTimeInterval(0.003))
            context.insert(record)
            leadIn = record
        }
        do { try context.save() }
        catch {
            context.delete(decision)
            if let leadIn { context.delete(leadIn) }
            errorMessage = "The chapter was saved, but its chat recap could not be: \(error.localizedDescription)"
        }
    }

    private func canRequest(text: String, imageData: Data?) -> Bool {
        guard !isSending, !text.isEmpty || imageData != nil else { return false }
        guard ConsentService.isGranted() else {
            errorMessage = "Review AI data consent before sending a message."
            return false
        }
        guard AppConfiguration.isAIConfigured else {
            errorMessage = ChatServiceError.unconfigured.localizedDescription
            return false
        }
        guard text.utf16.count <= ChatTextBudget.message else {
            errorMessage = "This message is too long. Shorten it before sending; your draft is still here."
            return false
        }
        return true
    }

    private func startReply(to message: ChatRecord, character: CharacterDefinition, allMessages: [ChatRecord], memories: [MemoryRecord], chapter: ChapterDefinition?, chapterIndex: Int, storyChoices: [StoryChoiceContext], context: ModelContext) {
        let previous = allMessages.filter {
            $0.characterID == character.id && $0.id != message.id && $0.createdAt <= message.createdAt &&
            ($0.role == "user" || $0.role == "assistant")
        }
        .sorted { $0.createdAt < $1.createdAt }.suffix(12)
        .map { ChatTurn(role: $0.role, text: ChatTextBudget.prefix($0.text, limit: ChatTextBudget.history)) }
        let approved = memories.filter { $0.characterID == character.id && $0.isPinned }
            .prefix(12).map { ChatTextBudget.prefix($0.note, limit: ChatTextBudget.memory) }
        let payload = GatewayChatRequest(characterID: character.id,
                                         chapterIndex: chapterIndex,
                                         chapterID: chapter?.id,
                                         chapterTitle: ChatTextBudget.prefix(chapter?.title ?? "Journey completed", limit: 160),
                                         storyChoices: Array(storyChoices.suffix(12)), recentMessages: previous,
                                         approvedMemories: approved, message: message.text,
                                         imageBase64: message.imageData?.base64EncodedString())
        let allowedChoices = Set(chapter?.choices.map(\.id) ?? [])
        let messageID = message.id
        isSending = true
        sendingMessageID = messageID
        errorMessage = nil
        currentTask = Task {
            defer { isSending = false; sendingMessageID = nil; currentTask = nil }
            do {
                try Task.checkCancellation()
                guard ConsentService.isGranted() else { throw CancellationError() }
                let reply = try await AIChatService.send(payload)
                try Task.checkCancellation()
                guard ConsentService.isGranted() else { throw CancellationError() }
                let descriptor = FetchDescriptor<ChatRecord>(predicate: #Predicate { $0.id == messageID })
                guard try context.fetchCount(descriptor) > 0 else { throw CancellationError() }
                let suggestion = reply.suggestedChoiceID.flatMap { allowedChoices.contains($0) ? $0 : nil }
                let answer = ChatRecord(characterID: character.id, role: "assistant", text: reply.reply,
                                        createdAt: Date().addingTimeInterval(0.001), suggestedChoiceID: suggestion)
                context.insert(answer)
                do { try context.save() }
                catch { context.delete(answer); throw error }
            } catch {
                errorMessage = Task.isCancelled || error is CancellationError
                    ? "Reply cancelled. Any saved messages remain in your history."
                    : error.localizedDescription
            }
        }
    }

    func cancel() { currentTask?.cancel() }
}
