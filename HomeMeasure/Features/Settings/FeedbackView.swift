import SwiftUI
import UIKit

struct FeedbackView: View {
    @State private var category = "Suggestion"
    @State private var subject = ""
    @State private var message = ""
    @State private var showCopied = false
    private let categories = ["Suggestion", "Bug report", "Calculation question", "Accessibility", "Other"]

    private var feedbackText: String {
        "HomeMeasure Feedback\nCategory: \(category)\nSubject: \(subject)\n\n\(message)\n\nApp version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")"
    }
    private var valid: Bool {
        !subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Help shape a better planning experience.")
                        .font(.headline).foregroundStyle(AppTheme.deep)
                    Text("Write a suggestion, report an issue or ask about a calculation. You choose how to share the message—nothing is sent in the background.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }.padding(.vertical, 8)
            }
            Section("Your feedback") {
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0).tag($0) }
                }
                TextField("Subject", text: $subject)
                TextField("Describe the issue or idea", text: $message, axis: .vertical)
                    .lineLimit(6...12)
                    .accessibilityLabel("Feedback message")
            }
            Section {
                ShareLink(item: feedbackText, subject: Text("HomeMeasure Feedback"),
                          message: Text("Feedback drafted in HomeMeasure")) {
                    Label("Share Feedback", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!valid)
                Button(action: copyFeedback) {
                    Label("Copy Feedback", systemImage: "doc.on.doc")
                        .frame(maxWidth: .infinity)
                }.disabled(!valid)
            }
            Section {
                Text("This app has no developer-operated messaging server. Share Feedback opens the iOS share sheet; you select a destination and confirm sending it yourself.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Feedback & Suggestions")
        .scrollContentBackground(.hidden).background(AppTheme.paper)
        .alert("Copied to Clipboard", isPresented: $showCopied) {
            Button("OK", role: .cancel) {}
        } message: { Text("Your feedback is ready to paste into a message or document.") }
    }

    private func copyFeedback() {
        UIPasteboard.general.string = feedbackText
        showCopied = true
    }
}
