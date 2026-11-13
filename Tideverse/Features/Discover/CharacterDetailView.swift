import SwiftUI
import SwiftData

struct CharacterDetailView: View {
    let character: CharacterDefinition
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \JourneyProgress.updatedAt, order: .reverse) private var progresses: [JourneyProgress]
    @AppStorage("tideverse.savedCharacters") private var savedCharacters = ""
    @AppStorage("tideverse.hiddenCharacters") private var hiddenCharacters = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showBiography = false
    @State private var confirmHide = false
    private var story: StoryDefinition? { ContentRepository.shared.story(for: character) }
    private var saved: Set<String> { Set(savedCharacters.split(separator: ",").map(String.init)) }
    private var progress: JourneyProgress? {
        guard let story else { return nil }
        return StoryEngine.progress(for: story, in: progresses)
    }
    private var journeyAction: String {
        guard let story else { return "Explore journey" }
        guard let progress else { return "Begin the journey" }
        if progress.isComplete { return "Journey complete · revisit moments" }
        return "Continue chapter \(min(progress.chapterIndex + 1, story.chapters.count)) of \(story.chapters.count)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CharacterPortrait(character: character)
                    .scaledToFit().frame(height: 250).frame(maxWidth: .infinity)
                    .background {
                        LinearGradient(colors: [Color(hex: character.colorHex).opacity(0.3), TideColors.card],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                VStack(alignment: .leading, spacing: 9) {
                    Eyebrow(title: "\(character.genre) · Age \(character.age)")
                    Text(character.name).font(.largeTitle.bold())
                    Text(character.profession).font(.title3).foregroundStyle(TideColors.bright)
                    Label("Fictional AI character", systemImage: "sparkles").font(.footnote).foregroundStyle(TideColors.muted)
                    Text(character.tagline).foregroundStyle(TideColors.muted)
                    DisclosureGroup("Their story", isExpanded: $showBiography) {
                        Text(character.biography).font(.body).foregroundStyle(TideColors.muted)
                            .lineSpacing(5).padding(.top, 8)
                            .accessibilityIdentifier("characterBiographyText")
                    }
                    .padding(.top, 4)
                    .animation(TideMotion.panel(reduced: reduceMotion), value: showBiography)
                }
                if let story {
                    VStack(alignment: .leading, spacing: 14) {
                        Eyebrow(title: "Inside this journey")
                        Text(story.tagline).font(.title2.bold())
                        Text(story.premise).foregroundStyle(TideColors.muted)
                        ForEach(story.chapters) { chapter in
                            DisclosureGroup {
                                Text(chapter.objective).font(.subheadline).foregroundStyle(TideColors.muted)
                                    .frame(maxWidth: .infinity, alignment: .leading).padding(.top, 6)
                            } label: {
                                VStack(alignment: .leading, spacing: 5) {
                                    Label("\(chapter.number). \(chapter.title)", systemImage: chapterSymbol(chapter))
                                        .font(.subheadline.weight(.semibold))
                                    Text("\(chapter.actLabel) · \(chapterStatus(chapter))")
                                        .font(.caption).foregroundStyle(TideColors.muted)
                                }
                                .accessibilityElement(children: .combine)
                            }
                            if chapter.id != story.chapters.last?.id { Divider() }
                        }
                    }
                    .padding(20).background(TideColors.card, in: RoundedRectangle(cornerRadius: 24))
                }
                VStack(alignment: .leading, spacing: 14) {
                    Label("Get to know \(character.name)", systemImage: "person.crop.circle").font(.headline)
                    Text(character.personality).foregroundStyle(TideColors.muted)
                    Text("What matters to them").font(.subheadline.bold())
                    Text(character.goal).foregroundStyle(TideColors.muted)
                    NavigationLink { MemoryLedgerView(character: character) } label: {
                        Label("Your memory ledger", systemImage: "brain.head.profile").frame(minHeight: 44)
                    }
                }
                .padding(20).background(TideColors.card, in: RoundedRectangle(cornerRadius: 24))
                Text("Journeys work offline. AI replies need an internet connection and your permission. Conversations cannot rewrite your saved chapter choices.")
                    .font(.footnote).foregroundStyle(TideColors.muted)
            }
            .padding(20)
        }
        .tideBackground()
        .safeAreaInset(edge: .bottom) {
            if let story {
                HStack(spacing: 10) {
                    NavigationLink { ChatDetailView(character: character) } label: {
                        Label("Chat", systemImage: "bubble.left.and.bubble.right")
                    }
                    .buttonStyle(TidePrimaryButtonStyle())
                    .accessibilityIdentifier("openConversation")
                    .accessibilityLabel("Chat with \(character.name)")
                    NavigationLink { StoryDetailView(story: story, character: character) } label: {
                        Label(journeyAction, systemImage: "book.pages")
                            .font(.subheadline.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 54)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(TideColors.bright)
                    .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 16))
                    .accessibilityIdentifier("openStory")
                    .accessibilityLabel("\(journeyAction), \(story.chapters.count) chapters")
                }
                .padding(.horizontal, 20).padding(.vertical, 10)
                .background(TideColors.canvas)

            }
        }
        .tideNavigationTitle(character.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: toggleSaved) {
                    Image(systemName: saved.contains(character.id) ? "bookmark.fill" : "bookmark")
                        .contentTransition(reduceMotion ? .identity : .symbolEffect(.replace))
                        .symbolEffect(.bounce, value: reduceMotion ? false : saved.contains(character.id))
                }
                .accessibilityLabel(saved.contains(character.id) ? "Unsave character" : "Save character")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Character options", systemImage: "ellipsis.circle") {
                    Button("Hide character", systemImage: "eye.slash") { confirmHide = true }
                }
            }
        }
        .confirmationDialog("Hide \(character.name)?", isPresented: $confirmHide, titleVisibility: .visible) {
            Button("Hide character", role: .destructive, action: hideCharacter)
            Button("Cancel", role: .cancel) { }
        } message: { Text("This hides the character from Discover and Chats. Your journeys and memories stay saved. Restore hidden characters in Settings.") }
    }

    private func chapterStatus(_ chapter: ChapterDefinition) -> String {
        guard let story, let index = story.chapters.firstIndex(where: { $0.id == chapter.id }) else {
            return "Not started"
        }
        if let progress {
            if progress.isComplete || index < progress.chapterIndex { return "Choice saved" }
            if index == progress.chapterIndex { return "Up next" }
        } else if index == 0 {
            return "Start here"
        }
        return "Ahead in your journey"
    }

    private func chapterSymbol(_ chapter: ChapterDefinition) -> String {
        switch chapterStatus(chapter) {
        case "Choice saved": return "checkmark.circle.fill"
        case "Up next", "Start here": return "book.pages"
        default: return "book.closed"
        }
    }

    private func toggleSaved() {
        var ids = saved
        if ids.contains(character.id) { ids.remove(character.id) } else { ids.insert(character.id) }
        savedCharacters = ids.sorted().joined(separator: ",")
    }

    private func hideCharacter() {
        var ids = Set(hiddenCharacters.split(separator: ",").map(String.init))
        ids.insert(character.id)
        hiddenCharacters = ids.sorted().joined(separator: ",")
        dismiss()
    }
}
