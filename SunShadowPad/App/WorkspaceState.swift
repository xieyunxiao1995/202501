import Foundation
import SwiftUI

@MainActor
final class WorkspaceState: ObservableObject {
    enum Tab: String, Hashable {
        case scenes, simulator, timeline, settings
    }
    @Published var selectedTab: Tab = .scenes
    @Published var selectedSceneID: UUID?
    @Published var inspectionDate: Date = Date()
    @Published var minuteOfDay: Double = 12 * 60
    @Published var forceRefresh = UUID()
    @Published var comparisonSceneID: UUID?

    init() {
        #if DEBUG
        if let raw = UserDefaults.standard.string(forKey: "startTab"),
           let tab = Tab(rawValue: raw) {
            selectedTab = tab
        }
        #endif
    }

    func select(_ record: StoredScene, tab: Tab = .simulator) {
        selectedSceneID = record.id
        selectedTab = tab
        forceRefresh = UUID()
    }
}
