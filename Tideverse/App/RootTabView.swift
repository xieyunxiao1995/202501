import SwiftUI
import SwiftData

struct AppRootView: View {
    @AppStorage("tideverse.onboarded") private var onboarded = false
    @State private var introductionCompletedThisLaunch = false

    @AppStorage(UsageAgreementService.versionKey) private var agreementVersion = ""
    @AppStorage(UsageAgreementService.acceptedAtKey) private var agreementAcceptedAt = 0.0

    private var needsAgreement: Bool {
        agreementVersion != UsageAgreementService.currentVersion || agreementAcceptedAt <= 0
    }

    var body: some View {
        Group {
            if !introductionCompletedThisLaunch && (!onboarded || needsAgreement) {
                WelcomeView(onContinue: {
                    introductionCompletedThisLaunch = true
                    onboarded = true
                })
            } else if needsAgreement {
                EntryConsentView()
            } else {
                RootTabView()
            }
        }
        .tint(TideColors.primary)
        .preferredColorScheme(.dark)
    }
}

struct RootTabView: View {
    enum Tab: Hashable { case discover, chats, journeys, settings }
    @State private var selectedTab: Tab = .discover
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DiscoverView()
            }
            .tabItem { Label("Discover", systemImage: "safari") }
            .tag(Tab.discover)

            NavigationStack {
                ChatsView()
            }
            .tabItem { Label("Chats", systemImage: "bubble.left.and.bubble.right") }
            .tag(Tab.chats)

            NavigationStack {
                JourneysView()
            }
            .tabItem { Label("Journeys", systemImage: "book.closed") }
            .tag(Tab.journeys)

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
            .tag(Tab.settings)
        }
        .toolbarBackground(TideColors.card, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .task {
            guard let progresses = try? modelContext.fetch(FetchDescriptor<JourneyProgress>()) else { return }
            for progress in progresses {
                guard let story = ContentRepository.shared.story(id: progress.storyID) else { continue }
                _ = try? StoryEngine.reopenIfExtended(progress, story: story, context: modelContext)
            }
        }
    }
}
