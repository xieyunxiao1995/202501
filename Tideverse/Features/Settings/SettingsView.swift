import SwiftUI

struct SettingsView: View {
    @AppStorage("tideverse.cloudConsent") private var cloudConsent = false
    @State private var showConsent = false
    @AppStorage(ConsentService.versionKey) private var acceptedConsentVersion = ""
    @AppStorage(ConsentService.acceptedAtKey) private var acceptedAt = 0.0
    @AppStorage(ConsentService.revokedAtKey) private var revokedAt = 0.0

    private var hasCurrentConsent: Bool { cloudConsent && acceptedConsentVersion == ConsentService.currentVersion && acceptedAt > 0 }
    @AppStorage("tideverse.hiddenCharacters") private var hiddenCharacters = ""

    private var hidden: [CharacterDefinition] {
        let ids = Set(hiddenCharacters.split(separator: ",").map(String.init))
        return ContentRepository.shared.characters.filter { ids.contains($0.id) }
    }

    var body: some View {
        Form {
            Section {
                HStack(spacing: 13) {
                    Image(systemName: "book.pages.fill")
                        .font(.title2).foregroundStyle(TideColors.bright)
                        .frame(width: 52, height: 52)
                        .background(TideColors.soft, in: RoundedRectangle(cornerRadius: 14))
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tideverse").font(.title2.bold())
                        Text(AppConfiguration.subtitle)
                            .font(.subheadline).foregroundStyle(TideColors.muted)
                        Text("Version \(AppConfiguration.version) (\(AppConfiguration.build))")
                            .font(.caption2).foregroundStyle(TideColors.muted)
                    }
                }
                .padding(.vertical, 7)
            }
            .listRowBackground(TideColors.card)
            Section("Your Experience") {
                HStack {
                    Label("Appearance", systemImage: "moon.stars.fill")
                    Spacer()
                    Text("Midnight Blue")
                        .foregroundStyle(TideColors.bright)
                }
                Text("A consistent dark-blue appearance across the entire app.")
                    .font(.caption)
                    .foregroundStyle(TideColors.muted)
                Label("English language", systemImage: "globe")
                    .foregroundStyle(TideColors.muted)
            }
            .listRowBackground(TideColors.card)
            if !hidden.isEmpty {
                Section("Hidden Characters") {
                    ForEach(hidden) { character in
                        Button("Restore \(character.name)") {
                            hiddenCharacters = hiddenCharacters.split(separator: ",")
                                .filter { $0 != character.id }.joined(separator: ",")
                        }
                    }
                }
                .listRowBackground(TideColors.card)
            }
            Section("Privacy & Data") {
                if hasCurrentConsent {
                    Toggle(isOn: $cloudConsent) {
                        Label("Allow Third-Party AI Processing", systemImage: "hand.raised")
                    }
                } else {
                    Button { showConsent = true } label: {
                        Label("Review AI Data Consent", systemImage: "hand.raised")
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                    }
                }
                Text("DeepSeek receives your sent messages, selected photos, pinned memories and story context. Turn permission off to stop new AI requests.")
                    .font(.caption).foregroundStyle(TideColors.muted)
                if acceptedAt > 0 {
                    LabeledContent("Permission last enabled") {
                        Text(Date(timeIntervalSince1970: acceptedAt), format: .dateTime.month(.abbreviated).day().year())
                    }
                    .font(.footnote)
                }
                if revokedAt > 0, !hasCurrentConsent {
                    LabeledContent("Permission last revoked") {
                        Text(Date(timeIntervalSince1970: revokedAt), format: .dateTime.month(.abbreviated).day().year())
                    }
                    .font(.footnote)
                }
                NavigationLink { DataManagementView() } label: {
                    Label("Data Management", systemImage: "externaldrive")
                }
            }
            .listRowBackground(TideColors.card)
            Section("Help & Support") {
                NavigationLink { HelpView() } label: { Label("Help Center", systemImage: "questionmark.circle") }
                    .accessibilityIdentifier("settingsHelp")
                NavigationLink { FeedbackSuggestionsView() } label: { Label("Feedback & Suggestions", systemImage: "bubble.left.and.text.bubble.right") }
                    .accessibilityIdentifier("settingsFeedback")
            }
            .listRowBackground(TideColors.card)
            Section("App Information") {
                NavigationLink { AboutUsView() } label: { Label("About Us", systemImage: "info.circle") }
                    .accessibilityIdentifier("settingsAbout")
                NavigationLink { TermsOfUseView() } label: { Label("Terms of Use", systemImage: "doc.text") }
                    .accessibilityIdentifier("settingsTerms")
                NavigationLink { PrivacyPolicyView() } label: { Label("Privacy Policy", systemImage: "lock.shield") }
                    .accessibilityIdentifier("settingsPrivacy")
                NavigationLink { DeveloperInformationView() } label: { Label("Developer Information", systemImage: "person.crop.square") }
                    .accessibilityIdentifier("settingsDeveloper")
            }
            .listRowBackground(TideColors.card)
            Section {
                Text("All characters are fictional adults aged 25 or older. No minors or explicit character art are included. Your authored story choices remain playable offline.")
                    .font(.footnote).foregroundStyle(TideColors.muted)
            }
            .listRowBackground(TideColors.card)
        }
        .environment(\.defaultMinListRowHeight, 52)
        .scrollContentBackground(.hidden)
        .tideBackground()
        .tideNavigationTitle("Settings", subtitle: "Privacy, help & app information", symbol: "gearshape")
        .onChange(of: cloudConsent) { _, allowed in
            if !allowed { ConsentService.revoke() }
        }
        .sheet(isPresented: $showConsent) {
            AIConsentView(onAgree: { ConsentService.accept(); showConsent = false },
                          onDecline: { showConsent = false })
        }
    }
}
