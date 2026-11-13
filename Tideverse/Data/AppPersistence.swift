import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class AppPersistence {
    private(set) var container: ModelContainer?
    private(set) var failure: String?

    init() { open() }

    func open() {
        let schema = Schema([ChatRecord.self, JourneyProgress.self, StoryMoment.self, MemoryRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
            failure = nil
        } catch {
            // Never replace a failed store with an empty database: that would
            // conceal a migration/storage failure and appear to erase progress.
            container = nil
            failure = "\((error as NSError).domain) (\((error as NSError).code))"
        }
    }
}
