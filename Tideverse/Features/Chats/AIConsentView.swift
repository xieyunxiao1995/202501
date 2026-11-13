import SwiftUI

struct AIConsentView: View {
    let onAgree: () -> Void
    let onDecline: () -> Void
    var sendsPendingMessage = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Label("Before you chat with AI", systemImage: "hand.raised")
                        .font(.title2.bold()).foregroundStyle(TideColors.ink)
                    Text("Your selected context is sent directly to DeepSeek to generate a reply. You can decline and continue offline stories.")
                        .font(.subheadline).foregroundStyle(TideColors.muted)
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Your message and up to 12 recent chat turns", systemImage: "bubble.left")
                        Label("Your optional selected photo", systemImage: "photo")
                        Label("Your authored story choices, current chapter, and approved pinned memories", systemImage: "book")
                    }
                    .font(.subheadline)
                    .padding(16)
                    .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 18))
                    Text("DeepSeek may process requests in mainland China, outside your country. Its API terms govern retention and service logs; zero retention is not guaranteed. Turn permission off in Settings to stop new requests. Avoid sensitive information.")
                        .font(.footnote).foregroundStyle(.secondary)
                    NavigationLink("Read our Privacy Policy") { PrivacyPolicyView() }.frame(minHeight: 44)

                }
                .padding(20)
            }
            .tideBackground()
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 4) {
                    TidePrimaryButton(title: sendsPendingMessage ? "I Agree · Send Message" : "I Agree · Enable AI", systemImage: "checkmark.shield", action: onAgree)
                    Button("Not Now", action: onDecline)
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .padding(.horizontal, 20).padding(.vertical, 12)
                .background(TideColors.canvas)
            }
            .tideNavigationTitle("AI Data Consent")
        }
    }
}
