import SwiftUI

struct HelpView: View {
    private let questions: [(String, String)] = [
        ("Do I need an account?", "No. Tideverse does not ask for a username, email address or password to enter. On first use, review the AI information and use the EULA and Privacy Policy links whenever you wish. Tap Agree & Enter to accept the agreement and begin. Your acceptance is saved on this device."),
        ("Does agreeing to the EULA enable online AI?", "No. The EULA and AI data permission are separate. You can use the offline stories after accepting the EULA. Online AI requires another notice explaining the messages, selected photos, pinned memories and story context that would be sent directly to DeepSeek."),
        ("How do I begin a story?", "Open Discover, choose a character and tap Begin the journey. If you have already started, the button names your next chapter. Each chapter has two authored choices. Selecting one saves a Story Moment and unlocks the next chapter."),
        ("Do stories need internet access?", "No. All bundled journeys and their authored chapters run offline. The choice you make is stored locally."),
        ("How do I enable AI chat?", "When AI conversation is available, open a character, enter a message and review the third-party processing notice before sending. If the service is unavailable, continue the offline journey instead."),
        ("Can I change or delete memories?", "Open any chat, then tap the brain icon. Add, edit, pin, unpin and delete notes. Only pinned notes for that character are used in AI chat context."),
        ("What can I send in Chat?", "Chat supports text messages. Describe what you want to discuss, or choose a conversation starter and edit it before sending."),
        ("How do I save my stories?", "Open Journeys, choose a Story Moment, tap Preview PDF or Export this moment. Settings > Data Management can export your local records as JSON. Turn off Include Attached Photos for a smaller backup; photos stay on the device."),
        ("How do I remove my data?", "Press and hold a chat message to delete it, or use Conversation options to delete that conversation. Settings > Data Management also includes Delete Conversations, Delete Memories and Delete All Local Data. Deleting a saved Story Moment keeps its chapter choice and journey progress."),
        ("Is the person on screen real?", "No. Every Tideverse character is an original fictional AI persona. The characters do not have human memories, feelings or independent lives outside the app."),
        ("How do I restore a backup?", "Open Settings > Data Management > Import JSON Archive, select a Tideverse archive, and review the summary before choosing Import & Merge. Imports merge with local records. Export a current backup first if you want to keep a separate copy of your current archive."),
        ("Can I move my progress to another device?", "Export a JSON archive in Data Management, save it to a location you control, then import it on the other device. There is no account-based sync. Keep the archive private, especially if you include attached photos."),
        ("How can I report a reply?", "Press and hold an AI reply, choose Report reply, review the selected text and share the report. VoiceOver users can choose the Report reply action. Choose a recipient and review the destination in your chosen app before sending. Preparing or sharing a report does not confirm that support has received it.")
    ]

    @State private var search = ""
    private var query: String { search.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var matching: [Int] {
        questions.indices.filter { query.isEmpty || "\(questions[$0].0) \(questions[$0].1)".localizedStandardContains(query) }
    }

    var body: some View {
        VStack(spacing: 0) {
            TideSearchField(prompt: "Search help", text: $search)
            List {
                Section {
                    Text("Helpful answers for exploring Tideverse and keeping control of your information.")
                        .foregroundStyle(.secondary)
                }
                Section("Frequently Asked Questions") {
                    if matching.isEmpty {
                        ContentUnavailableView {
                            Label("No matching answers", systemImage: "magnifyingglass")
                        } description: {
                            Text("Try words such as stories, photos, memories, or backup.")
                        } actions: {
                            Button("Clear search") { search = "" }
                        }
                    }
                    ForEach(matching, id: \.self) { index in
                        DisclosureGroup(questions[index].0) {
                            Text(questions[index].1).font(.subheadline).foregroundStyle(.secondary).padding(.vertical, 7)
                        }
                    }
                }
                Section("Need more help?") {
                    NavigationLink { FeedbackSuggestionsView() } label: {
                        Label("Feedback & Suggestions", systemImage: "bubble.left.and.text.bubble.right")
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .scrollContentBackground(.hidden)
        .tideBackground()
        .tideNavigationTitle("Help Center")
    }
}
