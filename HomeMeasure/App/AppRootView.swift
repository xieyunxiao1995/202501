import SwiftUI

struct AppRootView: View {
    @AppStorage("hasCompletedWelcomeTour") private var hasCompletedWelcomeTour = false

    var body: some View {
        if hasCompletedWelcomeTour {
            RootTabView()
        } else {
            WelcomeTourView { hasCompletedWelcomeTour = true }
        }
    }
}
