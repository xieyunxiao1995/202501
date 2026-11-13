import SwiftUI

@main
struct TideverseApp: App {
    @State private var persistence = AppPersistence()

    var body: some Scene {
        WindowGroup {
            if let container = persistence.container {
                AppRootView().modelContainer(container)
            } else {
                PersistenceRecoveryView(diagnostic: persistence.failure, retry: persistence.open)
            }
        }
    }
}
