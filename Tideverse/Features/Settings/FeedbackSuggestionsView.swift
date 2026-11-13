import SwiftUI

struct FeedbackSuggestionsView: View {
    @State private var category = "Suggestion"
    @AppStorage("tideverse.feedbackDraft") private var draft = ""
    private let categories = ["Suggestion", "Bug Report", "Inappropriate Content", "Accessibility", "Other"]
    private var report: String {
        "Tideverse Feedback\nCategory: \(category)\nApp: \(AppConfiguration.version) (\(AppConfiguration.build))\n\n\(draft.trimmingCharacters(in: .whitespacesAndNewlines))"
    }

    var body: some View {
        Form {
            Section {
                Text("Share an idea or tell us what went wrong. Review your report before sending it with an app of your choice.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            .listRowBackground(TideColors.card)
            Section("Feedback Category") {
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0).tag($0) }
                }
            }
            .listRowBackground(TideColors.card)
            Section("Your Message") {
                TextEditor(text: $draft)
                    .frame(minHeight: 180)
                    .accessibilityLabel("Describe your feedback")
                Text("For an issue, include the screen name, what you expected and what happened. For an idea, describe how it would help your story experience.")
                    .font(.caption).foregroundStyle(.secondary)
                Text("Please avoid including private conversations, passwords or other sensitive details.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .listRowBackground(TideColors.card)
            Section {
                if let url = AppConfiguration.supportMailURL(subject: "Tideverse Feedback", body: report) {
                    Link(destination: url) { Label("Email Support", systemImage: "envelope") }
                        .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                ShareLink(item: report, subject: Text("Tideverse Feedback"), message: Text("Feedback prepared in Tideverse")) {
                    Label("Share Feedback", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Button("Clear Draft", role: .destructive) { draft = "" }
            } footer: {
                Text("Your draft stays on this device until you clear it. Choose a recipient in the sharing app and confirm sending there. Tideverse does not send reports in the background or confirm delivery.")
            }
            .listRowBackground(TideColors.card)
        }
        .scrollContentBackground(.hidden)
        .tideBackground()
        .tideNavigationTitle("Feedback & Suggestions")
    }
}
