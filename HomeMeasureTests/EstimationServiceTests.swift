import XCTest
@testable import HomeMeasure

final class EstimationServiceTests: XCTestCase {
    func testRoomMeasurementsSubtractOpenings() {
        let room = RoomPlan(name: "Living Room", length: 4, width: 3, height: 2.7,
                            openings: [RoomOpening(kind: .door, width: 0.9, height: 2.1),
                                       RoomOpening(kind: .window, width: 1.2, height: 1.5)])
        let result = EstimationService.room(room)
        XCTAssertEqual(result.floor, 12, accuracy: 0.0001)
        XCTAssertEqual(result.wallGross, 37.8, accuracy: 0.0001)
        XCTAssertEqual(result.wallNet, 34.11, accuracy: 0.0001)
        XCTAssertEqual(result.ceiling, 12, accuracy: 0.0001)
        XCTAssertEqual(result.baseboardLength, 13.1, accuracy: 0.0001)
    }

    func testTilePackagesRoundUp() {
        let room = RoomPlan(name: "Entry", length: 4, width: 3, height: 2.7)
        let tile = MaterialPlan(roomID: room.id, name: "Porcelain tile", category: .tile,
                                surface: .floor, coveragePerPack: 1.44, packUnit: "boxes",
                                unitPrice: 38, wastePercent: 10, coats: 1, manualQuantity: 0)
        let estimate = EstimationService.material(tile, rooms: [room])
        XCTAssertEqual(estimate.packs, 10)
        XCTAssertEqual(estimate.cost, Decimal(380))
    }

    func testExactDecimalPackageBoundaryDoesNotRoundUpExtraPackage() {
        let room = RoomPlan(name: "Room", length: 1, width: 1, height: 2)
        let material = MaterialPlan(roomID: room.id, name: "Material", category: .tile,
                                    surface: .floor, coveragePerPack: 0.15, packUnit: "boxes",
                                    unitPrice: 1, wastePercent: 5, coats: 1, manualQuantity: 0)
        XCTAssertEqual(EstimationService.material(material, rooms: [room]).packs, 7)
    }

    func testDecimalInputDoesNotAddAnExtraPackage() {
        let room = RoomPlan(name: "Room", length: 1, width: 1, height: 2)
        let material = MaterialPlan(roomID: room.id, name: "Material", category: .other,
                                    surface: .manual, coveragePerPack: 0.01, packUnit: "pieces",
                                    unitPrice: 1, wastePercent: 0, coats: 1, manualQuantity: 38.42)
        XCTAssertEqual(EstimationService.material(material, rooms: [room]).packs, 3842)
    }

    func testPaintCoatsAndCustomOverride() {
        let room = RoomPlan(name: "Studio", length: 5, width: 4, height: 2.5)
        var paint = MaterialPlan(roomID: room.id, name: "Interior matte", category: .paint,
                                  surface: .walls, coveragePerPack: 35, packUnit: "cans",
                                  unitPrice: 42.50, wastePercent: 5, coats: 2, manualQuantity: 0)
        XCTAssertEqual(EstimationService.material(paint, rooms: [room]).packs, 3)
        paint.overridePacks = 4
        XCTAssertEqual(EstimationService.material(paint, rooms: [room]).packs, 4)
    }

    func testSubtotalTaxDelivery() {
        let room = RoomPlan(name: "Kitchen", length: 4, width: 3, height: 2.7)
        let tile = MaterialPlan(roomID: room.id, name: "Floor tile", category: .tile,
                                surface: .floor, coveragePerPack: 1.44, packUnit: "boxes",
                                unitPrice: 38, wastePercent: 10, coats: 1, manualQuantity: 0)
        let content = ProjectContent(rooms: [room], materials: [tile], taxPercent: 7.5,
                                     shipping: 25, currencyCode: "USD")
        let result = EstimationService.budget(content)
        XCTAssertEqual(result.subtotal, Decimal(380))
        XCTAssertEqual(result.tax, Decimal(string: "28.50"))
        XCTAssertEqual(result.total, Decimal(string: "433.50"))
    }

    func testWasteAndCoatsAreClampedToSupportedRange() {
        let room = RoomPlan(name: "Hall", length: 2, width: 2, height: 2.4)
        let material = MaterialPlan(roomID: room.id, name: "Sealer", category: .paint,
                                    surface: .walls, coveragePerPack: 10, packUnit: "cans",
                                    unitPrice: 5, wastePercent: 250, coats: 0, manualQuantity: 0)
        let estimate = EstimationService.material(material, rooms: [room])
        // 19.2 m² of walls, waste clamped to 100%, coats clamped to 1 => 38.4 m² => 4 cans.
        XCTAssertEqual(estimate.packs, 4)
        XCTAssertEqual(estimate.requiredQuantity, 38.4, accuracy: 0.0001)
    }

    func testManualOverrideCanReducePackagesToZero() {
        let room = RoomPlan(name: "Closet", length: 1, width: 1, height: 2)
        let material = MaterialPlan(roomID: room.id, name: "Shelf liner", category: .other,
                                    surface: .manual, coveragePerPack: 1, packUnit: "rolls",
                                    unitPrice: 12, wastePercent: 0, coats: 1, manualQuantity: 3,
                                    overridePacks: 0)
        let estimate = EstimationService.material(material, rooms: [room])
        XCTAssertEqual(estimate.packs, 0)
        XCTAssertEqual(estimate.cost, Decimal.zero)
    }

    func testMissingRoomProducesNoQuantity() {
        let material = MaterialPlan(roomID: UUID(), name: "Orphan", category: .tile,
                                    surface: .floor, coveragePerPack: 1.44, packUnit: "boxes",
                                    unitPrice: 10, wastePercent: 10, coats: 1, manualQuantity: 0)
        let estimate = EstimationService.material(material, rooms: [])
        XCTAssertEqual(estimate.packs, 0)
        XCTAssertEqual(estimate.roomName, "Removed room")
    }

    func testCurrencyRoundingFollowsMinorUnits() {
        XCTAssertEqual(EstimationService.rounded(Decimal(string: "1234.56") ?? .zero, code: "JPY"), Decimal(1235))
        XCTAssertEqual(EstimationService.rounded(Decimal(string: "1234.564") ?? .zero, code: "USD"),
                       Decimal(string: "1234.56"))
    }

    func testMoneyFormattingUsesCurrencyMinorUnits() {
        let jpy = EstimationService.money(Decimal(1234), code: "JPY")
        XCTAssertFalse(jpy.contains("."), "JPY should not show decimal places")
        let usd = EstimationService.money(Decimal(string: "380") ?? .zero, code: "USD")
        XCTAssertTrue(usd.contains("380.00"), "USD should show two decimal places")
    }
}
