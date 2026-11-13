import SwiftUI

struct JourneyRow: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let story: StoryDefinition
    let character: CharacterDefinition
    let progress: JourneyProgress?
    @Environment(\.dynamicTypeSize) private var typeSize
    private var index: Int { min(max(progress?.chapterIndex ?? 0, 0), story.chapters.count) }

    var body: some View {
        let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 14)) : AnyLayout(HStackLayout(spacing: 14))
        layout {
            Image(character.sceneAsset).resizable().scaledToFill()
                .frame(width: typeSize.isAccessibilitySize ? 220 : 100, height: 116)
                .clipped().clipShape(RoundedRectangle(cornerRadius: 15)).accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 9) {
                Text(story.title).font(.headline).foregroundStyle(TideColors.ink)
                Text(character.name).font(.subheadline).foregroundStyle(TideColors.muted)
                Text(progress?.isComplete == true ? "Journey complete" : "Chapter \(min(index + 1, story.chapters.count)) of \(story.chapters.count)")
                    .font(.footnote).foregroundStyle(TideColors.bright)
                ProgressView(value: Double(index), total: Double(story.chapters.count)).tint(TideColors.primary)
                    .animation(TideMotion.panel(reduced: reduceMotion), value: index)
                Label(progress?.isComplete == true ? "Revisit moments" : (index == 0 ? "Begin journey" : "Continue journey"),
                      systemImage: progress?.isComplete == true ? "checkmark.circle" : "arrow.right.circle")
                    .font(.footnote.bold()).foregroundStyle(TideColors.bright)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14).background(TideColors.card, in: RoundedRectangle(cornerRadius: 24))
        .overlay { RoundedRectangle(cornerRadius: 24).strokeBorder(TideColors.border.opacity(0.5), lineWidth: 1) }
        .accessibilityElement(children: .combine)
    }
}
