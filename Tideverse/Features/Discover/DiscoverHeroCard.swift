import SwiftUI

struct DiscoverHeroCard: View {
    let story: StoryDefinition
    let character: CharacterDefinition
    let progress: JourneyProgress?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(progress != nil && progress?.isComplete == false ? "Continue your journey" : "Featured journey",
                  systemImage: progress != nil ? "bookmark.fill" : "book.pages")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 12).padding(.vertical, 7)
                .background(TideColors.canvas.opacity(0.9), in: Capsule())
            Spacer(minLength: 24)
            VStack(alignment: .leading, spacing: 8) {
                Text(story.title).font(.title2.bold())
                Text("With \(character.name) · \(story.chapters.count) chapters")
                    .font(.subheadline).foregroundStyle(TideColors.ink)
                Label(progress?.isComplete == true ? "Revisit your moments" : (progress == nil ? "Begin the journey" : "Continue chapter \(min((progress?.chapterIndex ?? 0) + 1, story.chapters.count))"),
                      systemImage: "arrow.right.circle.fill")
                    .font(.headline).padding(.top, 4)
            }
        }
        .foregroundStyle(TideColors.ink)
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 240, alignment: .leading)
        .background {
            Image(character.sceneAsset).resizable().scaledToFill()
                .overlay {
                    LinearGradient(colors: [TideColors.canvas.opacity(0.1), TideColors.canvas.opacity(0.96)],
                                   startPoint: .top, endPoint: .bottom)
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens the authored journey. Stories are available offline.")
    }
}
