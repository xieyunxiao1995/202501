import SwiftUI
import SwiftData

@main
struct SunShadowPadApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .preferredColorScheme(.dark)
                .tint(AppTheme.yellow)
        }
        .modelContainer(for: StoredScene.self)
    }
}
