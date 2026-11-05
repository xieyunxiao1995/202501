import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                policy("Overview", "SunShadowPad's core functionality operates entirely on your iPhone. We do not require an account, operate a project server or include advertising, third-party analytics, tracking SDKs or remote AI services.")
                policy("What Is Stored", "Scenes, obstacle dimensions, manually entered coordinates, time zone choices and observation targets are stored in an on-device SwiftData database. Preferences are kept in local app settings.")
                policy("Precise Location", "SunShadowPad does not request GPS access. You enter the latitude and longitude for a scene yourself. The app does not upload those coordinates.")
                policy("Sharing and Exports", "You control exports of JSON project files, PDF reports and PNG images. When you choose an external save location or sharing destination, that destination's own data practices may apply.")
                policy("Feedback", "Feedback text is held on-screen until you choose to share it with another app. SunShadowPad has no feedback collection server and sends nothing automatically.")
                policy("Data Retention and Removal", "Your data remains on the device while the app and its data are installed. You can delete individual scenes or remove every scene in Settings → Backup & Data. Device backups may be governed by your device backup preferences.")
                policy("Children and Tracking", "No account registration, behavioral profiles, targeted advertising or push notifications are included.")
                policy("Contact", "\(AppInfo.supportContactSentence) This policy is provided by \(AppInfo.developer).")
                policy("Policy Scope", "This describes the functionality of version 1.0. If future releases add data collection or external services, their policies must be updated before those features are shipped.")
                Text("Policy version: 1.0  •  2 November 2026")
                    .font(.caption).foregroundStyle(AppTheme.textMuted)
            }.padding(18)
        }
        .background(AppTheme.navy.ignoresSafeArea())
        .navigationTitle("Privacy Policy")
    }
    private func policy(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title).font(.headline).foregroundStyle(AppTheme.yellow)
            Text(body).font(.subheadline).fixedSize(horizontal: false, vertical: true)
        }
    }
}
