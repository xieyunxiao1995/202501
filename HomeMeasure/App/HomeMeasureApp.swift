import SwiftUI
import SwiftData

@main
struct HomeMeasureApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .tint(AppTheme.slate)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: ProjectRecord.self)
    }
}
