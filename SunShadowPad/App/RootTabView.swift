import SwiftUI
import SwiftData

struct RootTabView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \StoredScene.updatedAt, order: .reverse) private var scenes: [StoredScene]
    @AppStorage("hasCompletedOnboarding") private var completedOnboarding = false
    @AppStorage("hasSeededSamples") private var seededSamples = false
    @StateObject private var workspace = WorkspaceState()

    var body: some View {
        TabView(selection: $workspace.selectedTab) {
            NavigationStack { ScenesView() }
                .tabItem { Label("Scenes", systemImage: "square.grid.2x2") }
                .tag(WorkspaceState.Tab.scenes)
            NavigationStack { SimulatorView() }
                .tabItem { Label("Simulator", systemImage: "sun.horizon") }
                .tag(WorkspaceState.Tab.simulator)
            NavigationStack { TimelineView() }
                .tabItem { Label("Timeline", systemImage: "chart.bar.xaxis") }
                .tag(WorkspaceState.Tab.timeline)
            NavigationStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(WorkspaceState.Tab.settings)
        }
        .environmentObject(workspace)
        .dismissKeyboardOnTap()
        .background(AppTheme.navy)
        .fullScreenCover(isPresented: Binding(get: { !completedOnboarding },
                                             set: { if !$0 { completedOnboarding = true } })) {
            OnboardingView(onDone: { completedOnboarding = true })
        }
        .task {
            guard !seededSamples else { return }
            // Only seed once; after user deletes every project, do not silently recreate it.
            if scenes.isEmpty {
                for scene in SceneSamples.all { context.insert(StoredScene(document: scene)) }
                try? context.save()
            }
            seededSamples = true
        }
        .onChange(of: scenes.map(\.id)) { _, ids in
            if workspace.selectedSceneID == nil || !ids.contains(workspace.selectedSceneID!) {
                workspace.selectedSceneID = scenes.first(where: { !$0.isArchived })?.id
            }
        }
        .onAppear { workspace.selectedSceneID = scenes.first(where: { !$0.isArchived })?.id }
    }
}
