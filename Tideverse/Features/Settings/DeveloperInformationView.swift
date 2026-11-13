import SwiftUI

struct DeveloperInformationView: View {
    var body: some View {
        Form {
            Section {
                Label("Made for stories worth remembering", systemImage: "book.closed")
                    .font(.headline)
                Text("Tideverse brings original illustrated characters, authored journeys and a personal story archive together in a native iPhone experience.")
                    .foregroundStyle(TideColors.muted)
            }
            .listRowBackground(TideColors.card)
            Section("Creative Studio") {
                LabeledContent("Studio", value: AppConfiguration.studioName)
                Text("Original characters. Meaningful choices. Stories you can keep.")
                    .font(.subheadline).foregroundStyle(TideColors.muted)
                Text("The creative brand behind Tideverse’s illustrated worlds and interactive story experience.")
                    .font(.footnote).foregroundStyle(TideColors.muted)
            }
            .listRowBackground(TideColors.card)
            Section("Application") {
                LabeledContent("Application", value: AppConfiguration.title)
                LabeledContent("Version", value: AppConfiguration.version)
                LabeledContent("Build", value: AppConfiguration.build)
                LabeledContent("Platform", value: "iOS 17 and later")
                LabeledContent("Language", value: "English")
            }
            .listRowBackground(TideColors.card)
            if let name = AppConfiguration.publisherName {
                Section("Publisher") {
                    LabeledContent("Publisher", value: name)
                    if let date = AppConfiguration.legalEffectiveDate {
                        LabeledContent("Policy effective date", value: date)
                    }
                }
                .listRowBackground(TideColors.card)
            }
            Section("Product principles") {
                Label("Original fictional adult characters", systemImage: "person.text.rectangle")
                Label("Authored stories available offline", systemImage: "book.pages")
                Label("Memories saved under your control", systemImage: "brain")
                Label("Separate permission for online AI", systemImage: "hand.raised")
            }
            .listRowBackground(TideColors.card)
            Section("Technology") {
                LabeledContent("Interface", value: "SwiftUI")
                LabeledContent("Local persistence", value: "SwiftData")
                LabeledContent("Optional AI provider", value: "DeepSeek")
                Text("Story choices are recorded by the app's story engine. AI conversations cannot silently change your chapter progress.")
                    .font(.footnote).foregroundStyle(TideColors.muted)
            }
            .listRowBackground(TideColors.card)
            Section("Contact & feedback") {
                if let url = AppConfiguration.supportMailURL(subject: "Tideverse Support", body: "") {
                    Link(destination: url) {
                        Label(AppConfiguration.supportEmail ?? "Email Support", systemImage: "envelope")
                    }
                }
                if let url = AppConfiguration.supportURL {
                    Link("Official Support", destination: url)
                }
                if let url = AppConfiguration.privacyPolicyURL {
                    Link("Published Privacy Policy", destination: url)
                }
                NavigationLink { FeedbackSuggestionsView() } label: {
                    Label("Feedback & Suggestions", systemImage: "bubble.left.and.text.bubble.right")
                }
                Text("Prepare a suggestion or issue report, review its contents, and share it using an app you choose. Reports are never sent automatically.")
                    .font(.footnote).foregroundStyle(TideColors.muted)
            }
            .listRowBackground(TideColors.card)
        }
        .scrollContentBackground(.hidden)
        .tideBackground()
        .tideNavigationTitle("Developer Information")
    }
}
