import SwiftUI

enum ChatSuggestionSource {
    case character
    case yourWords

    var label: String {
        switch self {
        case .character: return "Story direction"
        case .yourWords: return "This sounds like a decision"
        }
    }

    var detail: String {
        switch self {
        case .character: return "The latest reply points to this authored choice."
        case .yourWords: return "Your message points to one of this chapter’s authored directions."
        }
    }

    var icon: String {
        switch self {
        case .character: return "text.bubble"
        case .yourWords: return "quote.bubble"
        }
    }
}

struct ChatStorySuggestion: Identifiable {
    let id: String
    let choice: StoryChoice
    let source: ChatSuggestionSource
}

struct StorySuggestionCard: View {
    let suggestion: ChatStorySuggestion
    let apply: () -> Void
    let keepTalking: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Label(suggestion.source.label, systemImage: suggestion.source.icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(TideColors.bright)
            Text(suggestion.choice.label)
                .font(.headline)
                .foregroundStyle(TideColors.deep)
            Text(suggestion.source.detail)
                .font(.footnote)
                .foregroundStyle(TideColors.muted)
            HStack(spacing: 10) {
                Button(action: apply) {
                    Label("Record this decision", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .tint(TideColors.bright)
                .foregroundStyle(TideColors.canvas)
                .accessibilityIdentifier("storySuggestionFollow")

                Button("Keep talking", action: keepTalking)
                    .font(.subheadline)
                    .frame(minHeight: 44)
                    .accessibilityIdentifier("storySuggestionDismiss")
            }
            Text("Recording this saves your decision and advances the journey. You can keep talking afterward.")
                .font(.caption2)
                .foregroundStyle(TideColors.muted)
        }
        .padding(15)
        .background(TideColors.card, in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(TideColors.primary.opacity(0.65), lineWidth: 1))
        .accessibilityElement(children: .contain)
    }
}
