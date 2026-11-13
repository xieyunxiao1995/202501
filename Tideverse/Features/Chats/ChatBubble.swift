import SwiftUI

struct ChatBubble: View {
    let message: ChatRecord
    let avatarAsset: String
    private var isUser: Bool { message.role == "user" }
    private var isStory: Bool { message.role == "story" }

    var body: some View {
        if isStory {
            storyCard
        } else {
            conversationRow
        }
    }

    private var storyCard: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 7) {
                Image(systemName: "sparkles")
                Eyebrow(title: "Story beat")
                Spacer()
                Text(message.createdAt, style: .time)
                    .font(.caption)
                    .foregroundStyle(TideColors.muted)
            }
            .foregroundStyle(TideColors.bright)
            Text(message.text)
                .font(.subheadline)
                .lineSpacing(4)
                .foregroundStyle(TideColors.ink)
                .textSelection(.enabled)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(TideColors.highlight.opacity(0.42), in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(TideColors.border, lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Story beat. \(message.text)")
    }

    private var conversationRow: some View {
        HStack(alignment: .bottom, spacing: 9) {
            if isUser { Spacer(minLength: 44) }
            else {
                Image(avatarAsset).resizable().scaledToFill().frame(width: 30, height: 30).clipShape(Circle()).accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 5) {
                if let data = message.imageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable().scaledToFit()
                        .frame(maxWidth: 230, maxHeight: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                        .accessibilityLabel("Photo attached to this message")
                }
                if !message.text.isEmpty {
                    Text(message.text).font(.body).lineSpacing(4).textSelection(.enabled)
                }
                Text(message.createdAt, style: .time)
                    .font(.caption)
                    .foregroundStyle(isUser ? Color.white.opacity(0.77) : Color.secondary)
            }
            .padding(.horizontal, 15).padding(.vertical, 12)
            .foregroundStyle(isUser ? Color.white : TideColors.ink)
            .background(isUser ? TideColors.highlight : TideColors.card, in: RoundedRectangle(cornerRadius: 16))
            if !isUser { Spacer(minLength: 44) }
        }
    }
}
