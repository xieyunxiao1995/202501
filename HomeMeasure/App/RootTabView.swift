import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { OverviewView() }
                .tabItem { Label("Overview", systemImage: "square.grid.2x2") }
            NavigationStack { ProjectsView() }
                .tabItem { Label("Projects", systemImage: "square.stack.3d.up") }
            NavigationStack { ShoppingView() }
                .tabItem { Label("Shopping", systemImage: "cart") }
            NavigationStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
