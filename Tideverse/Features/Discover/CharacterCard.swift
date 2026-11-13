import SwiftUI

struct CharacterCard: View {
    let character: CharacterDefinition
    let isSaved: Bool
    var progress: JourneyProgress? = nil
    @Environment(\.dynamicTypeSize) private var typeSize

    private var journeyLine: String {
        guard let progress else { return "\(chapters) chapters · Begin" }
        if progress.isComplete { return "Journey complete" }
        return "Chapter \(min(progress.chapterIndex + 1, chapters)) of \(chapters)"
    }
    private var chapters: Int {
        ContentRepository.shared.story(for: character)?.chapters.count ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CharacterPortrait(character: character)
                .scaledToFit()
                .frame(height: 168)
                .frame(maxWidth: .infinity)
                .background {
                    LinearGradient(colors: [Color(hex: character.colorHex).opacity(0.28), TideColors.soft],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(alignment: .topTrailing) {
                    if isSaved {
                        Image(systemName: "bookmark.fill").foregroundStyle(TideColors.bright)
                            .padding(9).background(TideColors.canvas, in: Circle()).padding(8)
                    }
                }
            VStack(alignment: .leading, spacing: 6) {
                Text(character.genre.uppercased()).font(.caption.weight(.semibold)).foregroundStyle(TideColors.bright)
                Text(character.name).font(.headline).foregroundStyle(TideColors.ink)
                Text(character.title).font(.subheadline).foregroundStyle(TideColors.muted)
                Text(character.tagline).font(.footnote).foregroundStyle(TideColors.muted)
                    .lineLimit(typeSize.isAccessibilitySize ? nil : 2)
                Text("Fictional AI · Age \(character.age)").font(.caption).foregroundStyle(TideColors.muted)
                Label(journeyLine, systemImage: progress?.isComplete == true ? "checkmark.seal" : "book.closed")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(TideColors.bright)
            }
            .padding(.horizontal, 4).padding(.bottom, 6)
        }
        .padding(9)
        .background(TideColors.card, in: RoundedRectangle(cornerRadius: 18))
        .overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(TideColors.border.opacity(0.6), lineWidth: 1) }
        .accessibilityElement(children: .combine)
    }
}
