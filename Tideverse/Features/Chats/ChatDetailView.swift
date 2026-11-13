import SwiftUI
import SwiftData
import UIKit

struct ChatDetailView: View {
    let character: CharacterDefinition
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatRecord.createdAt) private var allMessages: [ChatRecord]
    @Query(sort: \MemoryRecord.createdAt, order: .reverse) private var allMemories: [MemoryRecord]
    @Query private var allProgress: [JourneyProgress]
    @AppStorage("tideverse.cloudConsent") private var cloudConsent = false
    @AppStorage(ConsentService.versionKey) private var acceptedConsentVersion = ""
    @State private var viewModel = ChatViewModel()
    @State private var draft = ""
    @State private var consentAction: ChatConsentAction?
    @State private var showMemories = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var draftTask: Task<Void, Never>?
    @State private var reportedReply: ChatRecord?
    @State private var memoryCandidate: ChatRecord?
    @State private var messageToDelete: ChatRecord?
    @State private var confirmDeleteMessage = false
    @State private var confirmDeleteConversation = false
    @FocusState private var composerFocused: Bool
    @State private var showStoryThread = false
    @State private var storyError: String?
    @State private var dismissedSuggestionKey: String?

    private var hasCurrentConsent: Bool { cloudConsent && acceptedConsentVersion == ConsentService.currentVersion && ConsentService.isGranted() }
    private var messages: [ChatRecord] { allMessages.filter { $0.characterID == character.id } }
    private var story: StoryDefinition? { ContentRepository.shared.story(for: character) }
    private var progress: JourneyProgress? { story.flatMap { StoryEngine.progress(for: $0, in: allProgress) } }
    private var chapterIndex: Int { progress?.chapterIndex ?? 0 }
    private var currentChapter: ChapterDefinition? {
        guard let story, story.chapters.indices.contains(chapterIndex) else { return nil }
        return story.chapters[chapterIndex]
    }
    private var scene: StoryChatDirector.Scene? { StoryChatDirector.scene(story: story, progress: progress) }
    private var chapterTitle: String { currentChapter?.title ?? "Journey completed" }
    private var chapterPosition: String {
        guard let story else { return "Story" }
        if currentChapter == nil { return "Journey complete · \(story.chapters.count) chapters" }
        return "Chapter \(chapterIndex + 1) of \(story.chapters.count)"
    }
    private var isOnline: Bool { AppConfiguration.isAIConfigured }

    private var storyChoices: [StoryChoiceContext] {
        (progress?.history ?? []).prefix(12).map { StoryChoiceContext(chapterID: $0.chapterID, choiceID: $0.choiceID) }
    }

    /// A canonical direction worth offering, either nominated by the
    /// character's latest reply or inferred from the user's own words.
    private var activeSuggestion: ChatStorySuggestion? {
        guard let scene, !viewModel.isSending, let last = messages.last else { return nil }
        if last.role == "assistant", let id = last.suggestedChoiceID,
           let choice = scene.chapter.choices.first(where: { $0.id == id }) {
            return ChatStorySuggestion(id: "\(last.id)-\(choice.id)", choice: choice, source: .character)
        }
        guard last.role == "user" || last.role == "assistant",
              let userMessage = messages.last(where: { $0.role == "user" }),
              let match = StoryChatDirector.match(userMessage.text, in: scene.chapter) else { return nil }
        return ChatStorySuggestion(id: "\(userMessage.id)-\(match.choice.id)", choice: match.choice, source: .yourWords)
    }

    private var visibleSuggestion: ChatStorySuggestion? {
        guard let activeSuggestion, dismissedSuggestionKey != activeSuggestion.id else { return nil }
        return activeSuggestion
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(character.avatarAsset)
                    .resizable().scaledToFill()
                    .frame(width: 40, height: 40).clipShape(Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(character.name).font(.headline)
                    Text("Adult \(character.age) · Fictional AI · " + character.genre)
                        .font(.caption).foregroundStyle(TideColors.primary)
                }
                Spacer()
                Button { composerFocused = false; showMemories = true } label: {
                    Image(systemName: "brain.head.profile").frame(width: 44, height: 44)
                }
                .accessibilityLabel("Open approved memories")
            }
            .padding(.horizontal, 16).padding(.vertical, 9)
            .background(TideColors.card)
            .simultaneousGesture(TapGesture().onEnded { composerFocused = false })

            Button {
                composerFocused = false
                showStoryThread = true
            } label: {
                VStack(spacing: 7) {
                    HStack(spacing: 10) {
                        Image(systemName: currentChapter == nil ? "checkmark.seal.fill" : "book.closed.fill")
                            .foregroundStyle(TideColors.bright)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(chapterPosition) · \(chapterTitle)")
                                .lineLimit(2)
                            Text("View chapter & choices")
                                .font(.caption)
                                .foregroundStyle(TideColors.muted)
                        }
                        Spacer(minLength: 8)
                        Image(systemName: "chevron.right").font(.caption2)
                    }
                    if let story {
                        ProgressView(value: Double(min(chapterIndex, story.chapters.count)), total: Double(story.chapters.count))
                            .tint(TideColors.bright)
                            .animation(TideMotion.panel(reduced: reduceMotion), value: chapterIndex)
                    }
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(TideColors.deep)
                .padding(.horizontal, 16).padding(.vertical, 9)
                .background(TideColors.soft)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("storyChapterHeader")
            .accessibilityHint("Opens the story thread")
            .simultaneousGesture(TapGesture().onEnded { composerFocused = false })

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 13) {
                        if messages.isEmpty {
                            HStack(alignment: .top, spacing: 10) {
                                Image(character.avatarAsset)
                                    .resizable().scaledToFill()
                                    .frame(width: 34, height: 34).clipShape(Circle())
                                Text(character.openingLine)
                                    .padding(13)
                                    .foregroundStyle(TideColors.ink)
                                    .background(TideColors.card, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.top, 15)
                            Text(isOnline
                                 ? "An authored story invitation, not a live AI reply"
                                 : "Authored story invitation. Reply in your own words.")
                                .font(.caption2).foregroundStyle(.secondary)
                        }
                        ForEach(messages) { message in
                            ChatBubble(message: message, avatarAsset: character.avatarAsset)
                                .accessibilityIdentifier("chatMessage_\(message.role)_\(message.id)")
                                .contextMenu {
                                    if !message.text.isEmpty {
                                        Button("Save a memory", systemImage: "pin") { memoryCandidate = message }
                                    }
                                    if message.role == "assistant" {
                                        Button("Report reply", systemImage: "flag") { reportedReply = message }
                                    }
                                    Button("Delete message", systemImage: "trash", role: .destructive) {
                                        messageToDelete = message; confirmDeleteMessage = true
                                    }
                                }
                                .accessibilityActions {
                                    if !message.text.isEmpty {
                                        Button("Save a memory") { memoryCandidate = message }
                                    }
                                    Button("Delete message") { messageToDelete = message; confirmDeleteMessage = true }
                                    if message.role == "assistant" {
                                        Button("Report reply") { reportedReply = message }
                                    }
                                }
                                .transition(TideMotion.message(reduced: reduceMotion, isUser: message.role == "user"))
                                .id(message.id)
                        }
                        if let suggestion = visibleSuggestion {
                            StorySuggestionCard(suggestion: suggestion, apply: { choose(suggestion.choice) }, keepTalking: {
                                dismissedSuggestionKey = suggestion.id
                                composerFocused = true
                            })
                            .transition(TideMotion.row(reduced: reduceMotion))
                            .id("storySuggestion")
                        }
                        if !viewModel.isSending, isOnline,
                           let lastMessage = messages.last, lastMessage.role == "user" {
                            VStack(alignment: .leading, spacing: 6) {
                                Button("Request reply to last message", systemImage: "arrow.clockwise") { requestRetry(lastMessage) }
                                    .font(.subheadline).frame(minHeight: 44)
                                Text("Uses the saved message without adding another message. This starts a new AI request.")
                                    .font(.footnote).foregroundStyle(TideColors.muted)
                            }
                            .padding(14).background(TideColors.soft, in: RoundedRectangle(cornerRadius: 16))
                        }
                        if viewModel.isSending {
                            HStack(spacing: 9) {
                                ProgressView().tint(TideColors.primary)
                                Text("Writing a reply…").font(.subheadline)
                                Spacer(minLength: 0)
                            }
                            .foregroundStyle(.secondary)
                            .padding(12)
                            .background(TideColors.card, in: RoundedRectangle(cornerRadius: 14))
                        }
                        Color.clear.frame(height: 1).id("bottom")
                    }
                    .padding(15)
                    .contentShape(Rectangle())
                    .animation(TideMotion.arrival(reduced: reduceMotion), value: messages.count)
                    .animation(TideMotion.panel(reduced: reduceMotion), value: visibleSuggestion?.id)
                    .animation(TideMotion.feedback(reduced: reduceMotion), value: viewModel.isSending)
                }
                .scrollDismissesKeyboard(.interactively)
                .simultaneousGesture(TapGesture().onEnded { composerFocused = false })
                .accessibilityIdentifier("chatScroll")
                .onAppear {
                    if !messages.isEmpty { proxy.scrollTo("bottom", anchor: .bottom) }
                }
                .onChange(of: allMessages.count) { _, _ in
                    withAnimation(TideMotion.feedback(reduced: reduceMotion)) { proxy.scrollTo("bottom", anchor: .bottom) }
                }
                .onChange(of: visibleSuggestion?.id) { _, newValue in
                    guard newValue != nil else { return }
                    withAnimation(TideMotion.arrival(reduced: reduceMotion)) { proxy.scrollTo("storySuggestion", anchor: .bottom) }
                }
            }
            if let issue = viewModel.errorMessage {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(issue).font(.footnote)
                    Spacer()
                    Button("Dismiss error", systemImage: "xmark.circle.fill") { viewModel.errorMessage = nil }
                        .labelStyle(.iconOnly).frame(minWidth: 44, minHeight: 44)
                }
                .foregroundStyle(TideColors.error)
                .padding(12)
                .background(TideColors.soft)
                .simultaneousGesture(TapGesture().onEnded { composerFocused = false })
            }
            if !isOnline {
                HStack(spacing: 8) {
                    Image(systemName: "lock.shield")
                        .foregroundStyle(TideColors.bright)
                    Text("On-device authored replies · No AI request is sent")
                        .font(.caption2).foregroundStyle(TideColors.muted)
                    Spacer(minLength: 8)
                    if let story {
                        NavigationLink { StoryDetailView(story: story, character: character) } label: {
                            Image(systemName: "book.pages").frame(width: 44, height: 36)
                        }
                        .accessibilityLabel("Read the full journey")
                    }
                }
                .padding(.horizontal, 14).padding(.vertical, 2)
                .background(TideColors.soft)
            }
            if messages.allSatisfy({ $0.role == "story" }), draft.isEmpty, !viewModel.isSending {
                ConversationStartersView(firstName: character.name.components(separatedBy: " ").first ?? character.name) { text in
                    draft = text
                }
            }
            ChatComposerView(characterName: character.name.components(separatedBy: " ").first ?? character.name,
                             isSending: viewModel.isSending, draft: $draft, isFocused: $composerFocused, send: requestSend, cancel: { viewModel.cancel() })
        }
        .tideBackground()
        .toolbar(.hidden, for: .tabBar)
        .tideNavigationTitle("Chat")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Conversation options", systemImage: "ellipsis.circle") {
                    Button("Story thread", systemImage: "book.closed") { showStoryThread = true }
                    Button("Memory ledger", systemImage: "brain.head.profile") { showMemories = true }
                    NavigationLink { CharacterDetailView(character: character) } label: { Label("View character", systemImage: "person.crop.circle") }
                    Button("Delete conversation", systemImage: "trash", role: .destructive) { confirmDeleteConversation = true }
                        .disabled(messages.isEmpty && draft.isEmpty)
                }
            }
        }
        .confirmationDialog("Delete this message?", isPresented: $confirmDeleteMessage, titleVisibility: .visible) {
            Button("Delete message", role: .destructive, action: deleteSelectedMessage)
            Button("Cancel", role: .cancel) { messageToDelete = nil }
        } message: { Text("This removes the message and its attached photo from this device. Any memory you saved separately is kept.") }
        .confirmationDialog("Delete this conversation?", isPresented: $confirmDeleteConversation, titleVisibility: .visible) {
            Button("Delete conversation", role: .destructive, action: deleteConversation)
            Button("Cancel", role: .cancel) { }
        } message: { Text("Deletes this character’s messages, attached photos and unsent draft. Journey progress and memory notes are kept.") }
        .sheet(item: $memoryCandidate) { message in MemoryApprovalView(character: character, proposedText: message.text) }
        .sheet(item: $reportedReply) { message in ReplyReportView(character: character, message: message) }
        .sheet(isPresented: $showMemories) {
            NavigationStack {
                MemoryLedgerView(character: character)
                    .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showMemories = false } } }
            }
        }
        .sheet(isPresented: $showStoryThread) {
            if let story {
                StoryBeatSheet(story: story, character: character, scene: scene, progress: progress, onChoose: choose)
            }
        }
        .sheet(item: $consentAction) { action in
            AIConsentView(onAgree: {
                ConsentService.accept()
                consentAction = nil
                switch action {
                case .send: performSend()
                case .retry(let messageID): performRetry(id: messageID)
                }
            }, onDecline: {
                consentAction = nil
            }, sendsPendingMessage: true)
        }
        .alert("Unable to record that decision", isPresented: Binding(get: { storyError != nil }, set: { if !$0 { storyError = nil } })) {
            Button("OK") { storyError = nil }
        } message: {
            Text(storyError ?? "Please try again.")
        }
        .task {
            do { draft = try ChatDraftStore.load(characterID: character.id) }
            catch { viewModel.errorMessage = "Could not restore your draft: \(error.localizedDescription)" }
        }
        .onChange(of: draft) { _, text in
            draftTask?.cancel()
            draftTask = Task {
                do {
                    try await Task.sleep(for: .milliseconds(350))
                    try Task.checkCancellation()
                    try ChatDraftStore.save(text, characterID: character.id)
                } catch { if !Task.isCancelled { viewModel.errorMessage = "Could not save your draft: \(error.localizedDescription)" } }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active {
                draftTask?.cancel()
                do { try ChatDraftStore.save(draft, characterID: character.id) }
                catch { viewModel.errorMessage = error.localizedDescription }
            }
        }
        .onChange(of: cloudConsent) { _, allowed in if !allowed { viewModel.cancel() } }
        .onChange(of: acceptedConsentVersion) { _, version in
            if version != ConsentService.currentVersion { viewModel.cancel() }
        }
        .onDisappear {
            viewModel.cancel(); draftTask?.cancel()
            composerFocused = false
            do { try ChatDraftStore.save(draft, characterID: character.id) }
            catch { viewModel.errorMessage = error.localizedDescription }
        }
    }

    private func requestSend() {
        guard isOnline else {
            performAuthoredSend()
            return
        }
        guard AppConfiguration.isAIConfigured else {
            viewModel.errorMessage = ChatServiceError.unconfigured.localizedDescription
            return
        }
        if !hasCurrentConsent {
            composerFocused = false
            consentAction = .send
        } else {
            performSend()
        }
    }

    private func requestRetry(_ message: ChatRecord) {
        if hasCurrentConsent { performRetry(id: message.id) }
        else { consentAction = .retry(message.id) }
    }

    private func performRetry(id: UUID) {
        guard let message = messages.first(where: { $0.id == id }) else { return }
        viewModel.retry(message, character: character, allMessages: allMessages, memories: allMemories,
                        chapter: currentChapter, chapterIndex: chapterIndex, storyChoices: storyChoices, context: modelContext)
    }

    private func deleteSelectedMessage() {
        guard let messageToDelete else { return }
        viewModel.cancel()
        modelContext.delete(messageToDelete)
        do { try modelContext.save(); self.messageToDelete = nil }
        catch { modelContext.rollback(); viewModel.errorMessage = error.localizedDescription }
    }

    private func deleteConversation() {
        viewModel.cancel(); draftTask?.cancel()
        do {
            try BackupService.deleteConversation(characterID: character.id, from: modelContext)
            draft = ""; consentAction = nil
        } catch { viewModel.errorMessage = error.localizedDescription }
    }

    private func performSend() {
        if viewModel.send(character: character, text: draft, imageData: nil, allMessages: allMessages,
                          memories: allMemories, chapter: currentChapter, chapterIndex: chapterIndex,
                          storyChoices: storyChoices, context: modelContext) {
            clearComposer()
        }
    }

    private func performAuthoredSend() {
        if viewModel.sendAuthored(character: character, text: draft, imageData: nil, story: story,
                                  progress: progress, allMessages: messages, context: modelContext) {
            clearComposer()
        }
    }

    private func clearComposer() {
        draft = ""
        dismissedSuggestionKey = nil
        composerFocused = false
    }

    private func choose(_ choice: StoryChoice) {
        guard let scene else { return }
        composerFocused = false
        do {
            let moment = try StoryChatDirector.decide(choiceID: choice.id, scene: scene, character: character, context: modelContext)
            viewModel.recordDecision(choice: choice, scene: scene, moment: moment, character: character, context: modelContext)
            dismissedSuggestionKey = nil
            showStoryThread = false
        } catch {
            storyError = error.localizedDescription
        }
    }
}
