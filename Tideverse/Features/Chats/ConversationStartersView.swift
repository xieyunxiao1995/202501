import SwiftUI

struct ConversationStartersView: View {
    let firstName: String
    let onSelect: (String) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                Button("Meet \(firstName)") { onSelect("Tell me about yourself, \(firstName).") }
                    .accessibilityIdentifier("chatStarterMeet")
                Button("Explore this place") { onSelect("What do you notice about this place?") }
                    .accessibilityIdentifier("chatStarterPlace")
                Button("Find a starting point") { onSelect("What should I pay attention to before choosing?") }
                    .accessibilityIdentifier("chatStarterDirection")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .font(.subheadline)
            .tint(TideColors.bright)
            .frame(minHeight: 44)
            .padding(.horizontal, 14)
        }
        .scrollIndicators(.hidden)
        .padding(.vertical, 4)
        .accessibilityHint("Choose a conversation starter, then review and send your message")
    }
}
