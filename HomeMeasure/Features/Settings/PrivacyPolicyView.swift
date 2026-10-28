import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Privacy Policy").font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(AppTheme.deep)
                Text("Last updated: October 27, 2026").font(.caption).foregroundStyle(.secondary)
                InfoBlock(title: "Privacy at a glance", text: "HomeMeasure does not require an account. The current app does not transmit project measurements, shopping lists or room photographs to a developer-operated server and has no analytics or advertising SDKs.")
                LegalSection(title: "Data you create", text: "Project names, locations you type, room dimensions, doors and windows, materials, prices, purchase status, notes and optional selected room photos are stored locally on your device. We do not collect this information remotely.")
                LegalSection(title: "Photos and documents", text: "The system photo picker provides access only to photos you select. A selected image is converted to a smaller local JPEG copy. A PDF report or JSON backup is created only when you request it. You decide where exported files are saved or shared.")
                LegalSection(title: "Feedback", text: "Feedback is not sent automatically. The feedback screen uses the system share sheet, so you choose whether and where to send your message. The selected recipient or app may process the information under its own privacy policy.")
                LegalSection(title: "Storage and deletion", text: "Project data is stored with SwiftData inside the app sandbox, and images are stored in application support storage. You can delete projects individually or choose Settings > Delete All Projects. Deleting the app also removes its app sandbox from the device. Copies previously exported to Files or third-party services must be deleted separately. Device backups may be managed by your operating system or device backup settings.")
                LegalSection(title: "Connectivity and tracking", text: "The current version does not require a network connection, use tracking identifiers, serve ads or integrate an external analytics platform. It does not request location, contacts, camera or microphone access.")
                LegalSection(title: "Policy updates", text: "If the app's data practices change, this policy and the App Store privacy disclosures should be updated before the changes are released.")
            }.padding(20)
        }.background(AppTheme.paper).navigationTitle("Privacy Policy")
    }
}
