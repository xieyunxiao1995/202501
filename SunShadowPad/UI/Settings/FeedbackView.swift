import SwiftUI

struct FeedbackView: View {
    @State private var category = "Feature Suggestion"
    @State private var message = ""
    private let categories = ["Feature Suggestion", "Bug Report", "Calculation Question", "Other Feedback"]
    private var shareText: String {
        "\(AppInfo.name) · \(category)\nApp version: \(AppInfo.version) (\(AppInfo.build))\n\n\(message.trimmingCharacters(in: .whitespacesAndNewlines))"
    }

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Feedback Type", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0).tag($0) }
                }
            }
            Section("Your Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 175)
                    .accessibilityLabel("Feedback details")
            }
            Section {
                ShareLink(item: shareText, subject: Text("SunShadowPad Feedback"),
                          message: Text("Feedback prepared on your device.")) {
                    Label("Share Feedback", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Text("Choose Mail or another installed sharing destination. No message is sent automatically.")
                    .font(.caption).foregroundStyle(AppTheme.textMuted)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.navy.ignoresSafeArea())
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Feedback & Suggestions")
    }
}
