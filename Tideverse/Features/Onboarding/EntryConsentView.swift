import SwiftUI

struct EntryConsentView: View {
    @State private var showEULA = false
    @State private var showPrivacy = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 14) {
                        Image(systemName: "sparkles")
                            .font(.title2).foregroundStyle(TideColors.bright)
                            .frame(width: 48, height: 48)
                            .background(TideColors.card, in: RoundedRectangle(cornerRadius: 14))
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Welcome to Tideverse").font(.title2.bold())
                            Text("No account. No password.")
                                .font(.subheadline).foregroundStyle(TideColors.muted)
                        }
                    }
                    Text("Original worlds. Choices that stay with you.")
                        .font(.headline).foregroundStyle(TideColors.bright)
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Fictional characters, AI replies", systemImage: "person.text.rectangle")
                            .font(.subheadline.bold())
                        Text("Characters are not real people. AI can be inaccurate. This is entertainment, not professional or emergency advice.")
                            .font(.subheadline).foregroundStyle(TideColors.muted)
                        Divider()
                        Label("Your data, your choice", systemImage: "hand.raised")
                            .font(.subheadline.bold())
                        Text("Stories work offline. Live AI needs separate permission before messages, selected photos or memories are shared directly with DeepSeek.")
                            .font(.subheadline).foregroundStyle(TideColors.muted)
                    }
                    .padding(16).frame(maxWidth: .infinity, alignment: .leading)
                    .background(TideColors.card, in: RoundedRectangle(cornerRadius: 18))
                    HStack(spacing: 24) {
                        Button("Read EULA") { showEULA = true }
                            .accessibilityIdentifier("reviewEULA")
                        Button("Privacy Policy") { showPrivacy = true }
                            .accessibilityIdentifier("reviewPrivacy")
                    }
                    .font(.subheadline.weight(.semibold))
                    .frame(minHeight: 44)
                    Text("By tapping Agree & Enter, you agree to the EULA and acknowledge the AI information above.")
                        .font(.footnote).foregroundStyle(TideColors.muted)
                }
                .padding(.horizontal, 24).padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
            .tideBackground()
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 8) {
                    TidePrimaryButton(title: "Agree & Enter", systemImage: "arrow.right") {
                        UsageAgreementService.accept()
                    }
                    .accessibilityIdentifier("acceptEULA")
                    Text("No account is created. Online AI stays optional.")
                        .font(.caption).foregroundStyle(TideColors.muted)
                }
                .padding(.horizontal, 24).padding(.vertical, 12).background(TideColors.canvas)
            }
            .tideNavigationTitle("Welcome")
            .sheet(isPresented: $showEULA) {
                NavigationStack {
                    TermsOfUseView()
                        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Close") { showEULA = false } } }
                }
            }
            .sheet(isPresented: $showPrivacy) {
                NavigationStack {
                    PrivacyPolicyView()
                        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showPrivacy = false } } }
                }
            }
        }
    }
}
