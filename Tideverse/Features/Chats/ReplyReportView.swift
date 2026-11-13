import SwiftUI

struct ReplyReportView: View {
    let character: CharacterDefinition
    let message: ChatRecord
    @Environment(\.dismiss) private var dismiss
    @State private var reason = "Inappropriate content"
    @State private var note = ""
    private let reasons = ["Inappropriate content", "Safety concern", "Misleading response", "Other"]
    private var report: String {
        "Tideverse Reply Report\nCharacter: \(character.name) (\(character.id))\nReply ID: \(message.id)\nDate: \(message.createdAt.formatted(.iso8601))\nReason: \(reason)\nApp: \(AppConfiguration.version) (\(AppConfiguration.build))\n\nSelected AI reply:\n\(message.text)\n\nYour note:\n\(note)"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Review the selected reply before sharing. This report includes this reply and your note; it excludes your other messages, photos and memories.")
                        .font(.subheadline).foregroundStyle(TideColors.muted)
                }
                Section("What went wrong?") {
                    Picker("Reason", selection: $reason) {
                        ForEach(reasons, id: \.self) { Text($0).tag($0) }
                    }
                    TextField("Add details (optional)", text: $note, axis: .vertical).lineLimit(3...8)
                }
                Section("Selected reply") {
                    Text(message.text).textSelection(.enabled)
                }
                Section("Send your report") {
                    if let url = AppConfiguration.supportMailURL(subject: "Tideverse Reply Report", body: report) {
                        Link(destination: url) { Label("Email Support", systemImage: "envelope") }
                    }
                    ShareLink(item: report, subject: Text("Tideverse Reply Report")) {
                        Label("Share Report", systemImage: "square.and.arrow.up")
                    }
                    Text("Choose a recipient and complete sending in your email or sharing app. Preparing a report does not submit it automatically.")
                        .font(.footnote).foregroundStyle(TideColors.muted)
                }
            }
            .scrollContentBackground(.hidden).tideBackground()
            .tideNavigationTitle("Report a Reply")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
}
