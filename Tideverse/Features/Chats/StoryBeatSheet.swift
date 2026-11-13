import SwiftUI
import SwiftData

struct StoryBeatSheet: View {
    let story: StoryDefinition
    let character: CharacterDefinition
    let scene: StoryChatDirector.Scene?
    let progress: JourneyProgress?
    let onChoose: (StoryChoice) -> Void
    @Environment(\.dismiss) private var dismiss

    private var history: [ChoiceHistoryEntry] { progress?.history ?? [] }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 17) {
                    if let scene {
                        Image(character.sceneAsset)
                            .resizable().scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 168).clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .accessibilityHidden(true)
                        Eyebrow(title: "\(scene.positionLabel) · Talk to decide")
                        Text(scene.chapter.title).font(.title.bold())
                        Text(scene.chapter.setting).font(.subheadline.italic()).foregroundStyle(TideColors.primary)
                        if let echo = scene.echo {
                            Label(echo, systemImage: "quote.opening")
                                .font(.subheadline.italic())
                                .foregroundStyle(TideColors.bright)
                                .padding(13)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(TideColors.highlight.opacity(0.55), in: RoundedRectangle(cornerRadius: 13))
                        }
                        Text(scene.chapter.intro).font(.body).lineSpacing(5)
                        Text(scene.chapter.objective).font(.headline)
                        Text("You do not have to pick from a menu. Describe what you want to do in chat and the character will follow your intent. These authored directions are always available as a fallback.")
                            .font(.footnote).foregroundStyle(TideColors.muted)
                        VStack(spacing: 10) {
                            ForEach(scene.chapter.choices) { choice in
                                Button {
                                    dismiss()
                                    onChoose(choice)
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "arrow.turn.down.right")
                                            .foregroundStyle(TideColors.bright)
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(choice.label).font(.subheadline.weight(.semibold))
                                            Text("Record this direction").font(.caption).foregroundStyle(TideColors.muted)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                    .padding(15)
                                    .foregroundStyle(TideColors.deep)
                                    .background(TideColors.canvas, in: RoundedRectangle(cornerRadius: 13))
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("chatStoryChoice_\(choice.id)")
                            }
                        }
                        NavigationLink {
                            StoryDetailView(story: story, character: character)
                        } label: {
                            Label("Read the full journey", systemImage: "book.pages")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Label("Journey complete", systemImage: "sparkles")
                            .font(.title2.bold()).foregroundStyle(TideColors.primary)
                        if let last = history.last {
                            Eyebrow(title: "Your ending")
                            Text(last.choiceLabel).font(.headline)
                            Text(last.outcome).foregroundStyle(TideColors.muted).lineSpacing(4)
                        }
                        Text("Every chapter is finished, but the conversation can keep going.")
                            .font(.subheadline).foregroundStyle(TideColors.muted)
                        NavigationLink {
                            StoryDetailView(story: story, character: character)
                        } label: {
                            Label("Review your path", systemImage: "book.pages")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(18)
            }
            .tideBackground()
            .tideNavigationTitle("Story thread")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
