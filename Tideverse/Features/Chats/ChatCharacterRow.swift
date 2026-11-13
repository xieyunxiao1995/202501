import SwiftUI

struct ChatCharacterRow: View {
    let character: CharacterDefinition
    let lastMessage: ChatRecord?
    @Environment(\.dynamicTypeSize) private var typeSize

    private var preview: String {
        guard let lastMessage else { return character.tagline }
        if lastMessage.role == "story" {
            return "Story beat · " + lastMessage.text.replacingOccurrences(of: "\n", with: " ")
        }
        return lastMessage.text.isEmpty ? "Shared a photo" : lastMessage.text
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(character.avatarAsset).resizable().scaledToFill()
                .frame(width: 54, height: 54)
                .background(Color(hex: character.colorHex).opacity(0.2), in: Circle())
                .clipShape(Circle()).accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(character.name).font(.headline).foregroundStyle(TideColors.ink)
                    Spacer(minLength: 4)
                    if let lastMessage {
                        Text(lastMessage.createdAt, format: .dateTime.month(.abbreviated).day())
                            .font(.caption).foregroundStyle(TideColors.muted)
                    }
                }
                Text(preview)
                    .font(.subheadline).foregroundStyle(TideColors.muted).lineLimit(typeSize.isAccessibilitySize ? nil : 2)
                Text("\(character.genre) · Fictional AI · \(character.age)")
                    .font(.caption).foregroundStyle(TideColors.bright)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(TideColors.muted)
                .padding(.top, 8)
        }
        .padding(16).frame(maxWidth: .infinity, alignment: .leading)
        .background(TideColors.card, in: RoundedRectangle(cornerRadius: 18))
        .overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(TideColors.border.opacity(0.5), lineWidth: 1) }
        .accessibilityElement(children: .combine)
    }
}
