import SwiftUI
import SwiftData

struct StoryDetailView: View {
    let story: StoryDefinition
    let character: CharacterDefinition
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JourneyProgress.updatedAt, order: .reverse) private var allProgress: [JourneyProgress]
    @Query(sort: \StoryMoment.createdAt, order: .reverse) private var allMoments: [StoryMoment]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AccessibilityFocusState private var readingFocused: Bool
    @State private var savedMoment: StoryMoment?
    @State private var errorMessage: String?

    private var progress: JourneyProgress? { StoryEngine.progress(for: story, in: allProgress) }
    private var currentChapter: ChapterDefinition? {
        let index = progress?.chapterIndex ?? 0
        return story.chapters.indices.contains(index) ? story.chapters[index] : nil
    }
    private var completedMoments: [StoryMoment] { allMoments.filter { $0.storyID == story.id } }
    private var history: [ChoiceHistoryEntry] { progress?.history ?? [] }
    private var currentEcho: String? {
        guard let currentChapter else { return nil }
        return StoryEngine.echo(for: currentChapter, history: history)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
            VStack(alignment: .leading, spacing: 19) {
                Color.clear
                    .frame(height: 210)
                    .overlay { Image(character.sceneAsset).resizable().scaledToFill() }
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .accessibilityHidden(true)
                Eyebrow(title: character.name + " · " + character.genre)
                Text(story.title).font(.largeTitle.bold()).foregroundStyle(TideColors.deep)
                Text(story.premise).foregroundStyle(.secondary)
                HStack {
                    Label("\(progress?.chapterIndex ?? 0) of \(story.chapters.count) chapters", systemImage: "book.closed")
                    Spacer()
                    if progress?.isComplete == true { Label("Completed", systemImage: "checkmark.seal.fill") }
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(TideColors.primary)
                ProgressView(value: Double(min(progress?.chapterIndex ?? 0, story.chapters.count)), total: Double(story.chapters.count))
                    .tint(TideColors.primary)
                    .animation(TideMotion.panel(reduced: reduceMotion), value: progress?.chapterIndex)
                if let previous = progress?.history.last {
                    DisclosureGroup("Previously: \(previous.choiceLabel)") {
                        Text(previous.outcome).font(.subheadline).foregroundStyle(TideColors.muted)
                            .padding(.top, 8)
                    }
                    .padding(18).background(TideColors.soft, in: RoundedRectangle(cornerRadius: 20))
                }
                if let chapter = currentChapter {
                    VStack(alignment: .leading, spacing: 14) {
                        Eyebrow(title: "\(chapter.actLabel) · Chapter \(chapter.number)")
                        Text(chapter.title).font(.title2.bold())
                            .accessibilityIdentifier("currentChapter")
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityFocused($readingFocused)
                        Text(chapter.setting).font(.subheadline.italic()).foregroundStyle(TideColors.primary)
                        if let currentEcho {
                            Label(currentEcho, systemImage: "quote.opening")
                                .font(.subheadline.italic())
                                .foregroundStyle(TideColors.bright)
                                .padding(13)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(TideColors.highlight.opacity(0.55), in: RoundedRectangle(cornerRadius: 13))
                                .accessibilityLabel("The story remembers: \(currentEcho)")
                        }
                        Text(chapter.intro).font(.body).lineSpacing(5)
                        Divider()
                        Text(chapter.objective).font(.headline)
                        ForEach(chapter.choices) { choice in
                            Button {
                                do {
                                    savedMoment = try StoryEngine.choose(choice, in: chapter, story: story, character: character, context: modelContext)
                                } catch {
                                    errorMessage = error.localizedDescription
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.turn.down.right")
                                    Text(choice.label).multilineTextAlignment(.leading)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .font(.subheadline.weight(.semibold))
                                .padding(16)
                                .foregroundStyle(TideColors.deep)
                                .background(TideColors.canvas, in: RoundedRectangle(cornerRadius: 13))
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("choice_\(choice.id)")
                        }
                    }
                    .padding(18)
                    .background(TideColors.card, in: RoundedRectangle(cornerRadius: 22))
                    .id(chapter.id)
                } else {
                    VStack(alignment: .leading, spacing: 11) {
                        Label("Journey complete", systemImage: "sparkles")
                            .font(.title2.bold()).foregroundStyle(TideColors.primary)
                            .accessibilityIdentifier("journeyComplete")
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityFocused($readingFocused)
                        if let last = history.last {
                            Eyebrow(title: "Your ending")
                            Text(last.choiceLabel).font(.headline)
                            Text(last.outcome).foregroundStyle(TideColors.muted).lineSpacing(4)
                        }
                        Text("The world remembers every choice you made. Revisit your path below, or continue the conversation in Chats.")
                            .font(.subheadline).foregroundStyle(TideColors.muted)
                    }
                    .padding(20)
                    .background(TideColors.card, in: RoundedRectangle(cornerRadius: 20))
                    .id("journeyComplete")
                }
                if !history.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your path").font(.title2.bold())
                        ForEach(Array(history.enumerated()), id: \.element.id) { index, entry in
                            DisclosureGroup {
                                Text(entry.outcome)
                                    .font(.subheadline).foregroundStyle(TideColors.muted)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 6)
                            } label: {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("\(index + 1). \(entry.chapterTitle)")
                                        .font(.subheadline.weight(.semibold))
                                    Text(entry.choiceLabel)
                                        .font(.caption).foregroundStyle(TideColors.bright)
                                }
                            }
                            if entry.id != history.last?.id { Divider() }
                        }
                    }
                    .padding(18)
                    .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 20))
                }
                NavigationLink {
                    ChatDetailView(character: character)
                } label: {
                    Label("Talk about this story", systemImage: "bubble.left.and.bubble.right")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 46)
                }
                .buttonStyle(.bordered)
                if !completedMoments.isEmpty {
                    Text("Your Story Moments").font(.title2.bold())
                    ForEach(completedMoments) { moment in
                        NavigationLink {
                            StoryMomentDetailView(moment: moment)
                        } label: {
                            MomentRow(moment: moment)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(18)
            }
            .tideBackground()
            .onChange(of: savedMoment?.id) { old, new in
                if old != nil, new == nil { moveToReadingPosition(using: proxy) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(currentChapter == nil ? "View ending" : "Continue reading",
                           systemImage: "text.book.closed") {
                        moveToReadingPosition(using: proxy)
                    }
                    .accessibilityIdentifier("jumpToReading")
                }
            }
        }
        .tideNavigationTitle("Story Journey")
        .sheet(item: $savedMoment) { moment in
            NavigationStack {
                StoryMomentDetailView(moment: moment)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(progress?.isComplete == true ? "Done" : "Continue") { savedMoment = nil }
                                .accessibilityIdentifier("dismissMoment")
                        }
                    }
            }
        }
        .alert("Unable to save your choice", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "Please try again.")
        }
    }
    private func moveToReadingPosition(using proxy: ScrollViewProxy) {
        withAnimation(TideMotion.arrival(reduced: reduceMotion)) {
            proxy.scrollTo(currentChapter?.id ?? "journeyComplete", anchor: .top)
        }
        readingFocused = true
    }

}
