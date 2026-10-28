import XCTest
import SwiftData
@testable import HomeMeasure

final class BackupServiceTests: XCTestCase {
    @MainActor
    func testRestoreCreatesSeparateCopyAndDropsPhotoReferences() throws {
        let container = try ModelContainer(for: ProjectRecord.self,
                                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext

        let room = RoomPlan(name: "Kitchen", length: 4, width: 3, height: 2.7,
                            openings: [RoomOpening(kind: .door, width: 0.9, height: 2.1),
                                       RoomOpening(kind: .window, width: 1.2, height: 1.5)],
                            photoFilename: "kitchen.jpg")
        let tile = MaterialPlan(roomID: room.id, name: "Porcelain tile", category: .tile,
                                surface: .floor, coveragePerPack: 1.44, packUnit: "boxes",
                                unitPrice: 38, wastePercent: 10, coats: 1, manualQuantity: 0)
        let content = ProjectContent(rooms: [room], materials: [tile], taxPercent: 7.5,
                                     shipping: 25, currencyCode: "USD", notes: "Check grout colour")

        let original = ProjectRecord(name: "Kitchen Refresh", location: "Ground floor")
        try original.update(content)
        context.insert(original)
        try context.save()

        let archive = try BackupService.makeBackup([original])
        let url = FileManager.default.temporaryDirectory
            .appending(path: "HomeMeasure-\(UUID().uuidString).json")
        try archive.data.write(to: url)
        defer { try? FileManager.default.removeItem(at: url) }

        let importedCount = try BackupService.restore(from: url, into: context)
        XCTAssertEqual(importedCount, 1)

        let projects = try context.fetch(FetchDescriptor<ProjectRecord>())
        XCTAssertEqual(projects.count, 2)
        let copy = try XCTUnwrap(projects.first { $0.id != original.id })
        XCTAssertEqual(copy.name, "Kitchen Refresh")
        XCTAssertEqual(copy.details.rooms.count, 1)
        XCTAssertEqual(copy.details.materials.count, 1)
        XCTAssertNil(copy.details.rooms.first?.photoFilename, "Backups never carry room photos")
        XCTAssertEqual(copy.details.materials.first?.roomID, copy.details.rooms.first?.id,
                       "Material/room links must survive import")
        XCTAssertEqual(copy.details.notes, "Check grout colour")
    }

    @MainActor
    func testRestoreRejectsUnreadableData() throws {
        let container = try ModelContainer(for: ProjectRecord.self,
                                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        let url = FileManager.default.temporaryDirectory
            .appending(path: "HomeMeasure-bad-\(UUID().uuidString).json")
        try Data("not a backup".utf8).write(to: url)
        defer { try? FileManager.default.removeItem(at: url) }

        XCTAssertThrowsError(try BackupService.restore(from: url, into: context))
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<ProjectRecord>()), 0)
    }
}
