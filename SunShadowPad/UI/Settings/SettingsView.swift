import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("measurementUnit") private var unit = "m"
    @AppStorage("use24HourClock") private var twentyFourHour = true
    @Query private var scenes: [StoredScene]

    var body: some View {
        Form {
            Section("Preferences") {
                Picker("Measurement Units", selection: $unit) {
                    Text("Metres").tag("m")
                    Text("Feet").tag("ft")
                }
                Toggle("24-Hour Clock", isOn: $twentyFourHour)
            }
            Section("Projects") {
                NavigationLink {
                    DataManagementView()
                } label: {
                    Label("Backup & Data", systemImage: "externaldrive")
                }
                LabeledContent("Local Scenes", value: "\(scenes.count)")
            }
            Section("Support") {
                NavigationLink { HelpView() } label: {
                    Label("Use Help", systemImage: "questionmark.circle")
                }
                NavigationLink { FeedbackView() } label: {
                    Label("Feedback & Suggestions", systemImage: "bubble.left.and.text.bubble.right")
                }
                NavigationLink { AboutUsView() } label: {
                    Label("About Us", systemImage: "info.circle")
                }
            }
            Section("Legal") {
                NavigationLink { PrivacyPolicyView() } label: {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                NavigationLink { UserAgreementView() } label: {
                    Label("User Agreement", systemImage: "doc.text")
                }
            }
            Section {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(AppTheme.grass)
                    Text("Offline by design. No accounts, notifications or purchases.")
                        .font(.caption).foregroundStyle(AppTheme.textMuted)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.navy.ignoresSafeArea())
        .navigationTitle("Settings")
    }
}
