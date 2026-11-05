import XCTest
import PDFKit
@testable import SunShadowPad

final class SolarAndShadowTests: XCTestCase {
    private func instant(_ iso: String) -> Date {
        ISO8601DateFormatter().date(from: iso)!
    }

    func testSummerNoonAtLondonIsAboveSixtyDegrees() {
        let sun = SolarPositionEngine.position(at: instant("2026-06-21T12:00:00Z"),
                                               latitude: 51.5074, longitude: -0.1278,
                                               timeZoneID: "Europe/London")
        XCTAssertTrue(sun.isAboveHorizon)
        XCTAssertGreaterThan(sun.elevation, 60)
        XCTAssertLessThan(sun.elevation, 64)
    }

    func testEquatorNoonOnEquinoxIsHigh() {
        let sun = SolarPositionEngine.position(at: instant("2026-03-20T12:00:00Z"),
                                               latitude: 0, longitude: 0, timeZoneID: "Etc/GMT")
        XCTAssertGreaterThan(sun.elevation, 87)
    }

    func testNightProducesNoDirectShadows() {
        let site = SceneSamples.courtyard
        let sun = SolarPositionEngine.position(at: instant("2026-12-21T02:00:00Z"),
                                               latitude: site.latitude, longitude: site.longitude,
                                               timeZoneID: site.timeZoneID)
        XCTAssertFalse(sun.isAboveHorizon)
        XCTAssertTrue(ShadowGeometryEngine.shadowPolygons(for: site, at: sun).isEmpty)
    }

    func testProjectContainsThreeEditableScenes() {
        XCTAssertEqual(SceneSamples.all.count, 3)
        XCTAssertTrue(SceneSamples.all.allSatisfy { $0.isValid && !$0.elements.isEmpty && !$0.targets.isEmpty })
        XCTAssertEqual(Set(SceneSamples.all.map(\.id)).count, 3)
    }

    func testSameSiteRulesDisallowDifferentLatitude() {
        let original = SceneSamples.courtyard
        var copy = original.copyAs("Revised layout")
        XCTAssertTrue(ScenarioComparisonService.sameSite(original, copy))
        copy.latitude += 0.5
        XCTAssertFalse(ScenarioComparisonService.sameSite(original, copy))
    }

    func testDaylightHasFiniteSampledHours() {
        let doc = SceneSamples.balcony
        let sample = ExposureAnalysisEngine.calculate(scene: doc,
                                                      day: instant("2026-06-21T12:00:00Z"),
                                                      stepMinutes: 15, columns: 12)
        XCTAssertEqual(sample.heat.count, sample.cols * sample.rows)
        XCTAssertFalse(sample.samples.isEmpty)
        XCTAssertGreaterThan(sample.maxSunHours, 10)
        XCTAssertTrue(sample.targets.allSatisfy { $0.sunnyHours >= 0 && $0.sunnyHours <= sample.maxSunHours + 0.01 })
    }

    func testPolarDayAndPolarNight() {
        let doc = SceneDocument(name: "Arctic Study", kind: .custom,
                                latitude: 78, longitude: 15, timeZoneID: "Europe/Oslo",
                                width: 5, height: 5)
        XCTAssertTrue(SolarPositionEngine.events(on: instant("2026-06-21T12:00:00Z"), in: doc).alwaysAbove)
        XCTAssertTrue(SolarPositionEngine.events(on: instant("2026-12-21T12:00:00Z"), in: doc).alwaysBelow)
    }

    func testDaylightSavingUsesActualDayLength() {
        XCTAssertEqual(TimeService.intervalOfDay(instant("2026-03-29T12:00:00Z"),
                                                    in: "Europe/London").duration, 23*3600)
        XCTAssertEqual(TimeService.intervalOfDay(instant("2026-10-25T12:00:00Z"),
                                                    in: "Europe/London").duration, 25*3600)
    }

    func testSeasonalMarkersCompareEquinoxesAndSolstices() {
        let doc = SceneDocument(name: "Season Study", kind: .custom,
                                latitude: 51.5074, longitude: -0.1278,
                                timeZoneID: "Europe/London", width: 10, height: 10)
        let samples = ExposureAnalysisEngine.seasonalHours(scene: doc, year: 2026,
                                                           target: nil, stepMinutes: 15)
        XCTAssertEqual(samples.map(\.name),
                       ["Spring Equinox", "Summer Solstice", "Autumn Equinox", "Winter Solstice"])
        let calendar = TimeService.calendar(doc.timeZoneID)
        XCTAssertEqual(samples.map { calendar.component(.month, from: $0.date) }, [3, 6, 9, 12])
        let summer = samples[1].hours
        let winter = samples[3].hours
        XCTAssertGreaterThan(summer, 15.5)
        XCTAssertLessThan(winter, 9)
        XCTAssertGreaterThan(summer - winter, 3)
        XCTAssertEqual(samples[0].hours, 12, accuracy: 0.5)
        XCTAssertEqual(samples[2].hours, 12, accuracy: 0.5)
    }

    func testAzimuthTravelsFromEastToWestAcrossTheDay() {
        let site = SceneSamples.courtyard
        let morning = SolarPositionEngine.position(at: instant("2026-06-21T07:00:00Z"),
                                                   latitude: site.latitude, longitude: site.longitude,
                                                   timeZoneID: site.timeZoneID)
        let noon = SolarPositionEngine.position(at: instant("2026-06-21T12:00:00Z"),
                                                latitude: site.latitude, longitude: site.longitude,
                                                timeZoneID: site.timeZoneID)
        let afternoon = SolarPositionEngine.position(at: instant("2026-06-21T17:00:00Z"),
                                                     latitude: site.latitude, longitude: site.longitude,
                                                     timeZoneID: site.timeZoneID)
        XCTAssertLessThan(morning.azimuth, noon.azimuth)
        XCTAssertLessThan(noon.azimuth, afternoon.azimuth)
        XCTAssertTrue((60...300).contains(noon.azimuth))
    }

    func testNorthernNoonShadowPointsNorth() {
        let sun = SunPosition(elevation: 45, azimuth: 180, equationOfTime: 0)
        let offset = ShadowGeometryEngine.shadowOffset(height: 2, sun: sun, northDegrees: 0)
        XCTAssertEqual(offset.y, -2, accuracy: 0.0001)
        XCTAssertEqual(offset.x, 0, accuracy: 0.0001)
    }

    func testShadowLengthMatchesHeightOverTangent() {
        let sun = SunPosition(elevation: 30, azimuth: 90, equationOfTime: 0)
        let offset = ShadowGeometryEngine.shadowOffset(height: 3, sun: sun, northDegrees: 0)
        let length = (offset.x * offset.x + offset.y * offset.y).squareRoot()
        XCTAssertEqual(length, 3 / tan(30 * .pi / 180), accuracy: 0.001)
    }

    func testZeroHeightObstacleCastsNoShadow() {
        var scene = SceneSamples.courtyard
        scene.elements = [SceneElement(name: "Flat marker", kind: .rectangle,
                                       x: scene.width / 2, y: scene.height / 2,
                                       width: 2, depth: 2, height: 0)]
        let noon = SolarPositionEngine.position(at: instant("2026-06-21T12:00:00Z"),
                                                latitude: scene.latitude, longitude: scene.longitude,
                                                timeZoneID: scene.timeZoneID)
        XCTAssertTrue(ShadowGeometryEngine.shadowPolygons(for: scene, at: noon).isEmpty)
    }

    func testSceneJSONRoundTripPreservesGeometry() throws {
        let original = SceneSamples.all[0]
        let data = try ProjectBackupService.json(for: original)
        let restored = try ProjectBackupService.importScenes(data)
        XCTAssertEqual(restored.count, 1)
        XCTAssertEqual(restored[0], original)
    }

    func testInvalidSceneValuesAreRejected() {
        var scene = SceneDocument.blank()
        scene.latitude = 120
        XCTAssertFalse(scene.isValid)
        scene = SceneDocument.blank()
        scene.width = 0
        XCTAssertFalse(scene.isValid)
        scene = SceneDocument.blank()
        scene.timeZoneID = "Not/AZone"
        XCTAssertFalse(scene.isValid)
        var element = SceneElement.make(.wall, in: scene)
        element.height = -1
        scene.elements = [element]
        XCTAssertFalse(scene.isValid)
    }

    func testSunrisePrecedesSolarNoonAndSunset() throws {
        let site = SceneSamples.courtyard
        let events = SolarPositionEngine.events(on: instant("2026-03-20T12:00:00Z"), in: site)
        let sunrise = try XCTUnwrap(events.sunrise)
        let noon = try XCTUnwrap(events.solarNoon)
        let sunset = try XCTUnwrap(events.sunset)
        XCTAssertLessThan(sunrise, noon)
        XCTAssertLessThan(noon, sunset)
        XCTAssertFalse(events.alwaysAbove)
        XCTAssertFalse(events.alwaysBelow)
    }

    @MainActor
    func testPDFReportRendersInventoryAndExposurePages() throws {
        let scene = SceneSamples.courtyard
        let result = ExposureAnalysisEngine.calculate(scene: scene,
                                                      day: instant("2026-06-21T12:00:00Z"),
                                                      stepMinutes: 15, columns: 12)
        let data = ReportExportService.pdf(scene: scene, result: result)
        let document = try XCTUnwrap(PDFDocument(data: data))
        XCTAssertEqual(document.pageCount, 3)
        let text = (0..<document.pageCount)
            .compactMap { document.page(at: $0)?.string }
            .joined(separator: "\n")
        XCTAssertTrue(text.contains("SUNSHADOWPAD"))
        XCTAssertTrue(text.contains("SCENE INVENTORY"))
        XCTAssertTrue(text.contains("West Boundary"))
        XCTAssertTrue(text.contains("EXPOSURE ANALYSIS"))
    }

    @MainActor
    func testComparisonPDFAddsLayoutComparisonPage() throws {
        let base = SceneSamples.courtyard
        var alternative = base.copyAs("Lower Boundary Wall")
        if let index = alternative.elements.firstIndex(where: { $0.kind == .wall }) {
            alternative.elements[index].height = 1.1
        }
        let day = instant("2026-06-21T12:00:00Z")
        let baseResult = ExposureAnalysisEngine.calculate(scene: base, day: day, stepMinutes: 15, columns: 12)
        let alternativeResult = ExposureAnalysisEngine.calculate(scene: alternative, day: day,
                                                                stepMinutes: 15, columns: 12)
        let data = ReportExportService.pdf(scene: base, result: baseResult,
                                           comparison: (scene: alternative, result: alternativeResult))
        let document = try XCTUnwrap(PDFDocument(data: data))
        XCTAssertEqual(document.pageCount, 4)
        let text = (0..<document.pageCount)
            .compactMap { document.page(at: $0)?.string }
            .joined(separator: "\n")
        XCTAssertTrue(text.contains("LAYOUT COMPARISON"))
        XCTAssertTrue(text.contains("Lower Boundary Wall"))
    }

    func testCanvasTapMapsToSceneCoordinates() throws {
        let scene = SceneSamples.courtyard
        let projection = CanvasProjection(scene: scene,
                                          viewport: CGSize(width: 360, height: 260),
                                          zoom: 1, pan: .zero)
        let centre = try XCTUnwrap(projection.scenePoint(fromViewPoint: CGPoint(x: 180, y: 130)))
        XCTAssertEqual(centre.x, scene.width / 2, accuracy: 0.01)
        XCTAssertEqual(centre.y, scene.height / 2, accuracy: 0.01)
        XCTAssertNil(projection.scenePoint(fromViewPoint: CGPoint(x: 2, y: 2)))
    }

    func testPrivacyManifestDeclaresNoTrackingAndUserDefaultsReason() throws {
        let url = try XCTUnwrap(Bundle.main.url(forResource: "PrivacyInfo", withExtension: "xcprivacy"))
        let data = try Data(contentsOf: url)
        let root = try XCTUnwrap(
            PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any])
        XCTAssertEqual(root["NSPrivacyTracking"] as? Bool, false)
        let accessed = try XCTUnwrap(root["NSPrivacyAccessedAPITypes"] as? [[String: Any]])
        let defaults = try XCTUnwrap(accessed.first {
            $0["NSPrivacyAccessedAPIType"] as? String == "NSPrivacyAccessedAPICategoryUserDefaults"
        })
        XCTAssertEqual(defaults["NSPrivacyAccessedAPITypeReasons"] as? [String], ["CA92.1"])
    }

    func testSubmissionConfigurationStaysPortraitAndOffline() throws {
        let info = try XCTUnwrap(Bundle.main.infoDictionary)
        XCTAssertEqual(info["UISupportedInterfaceOrientations"] as? [String],
                       ["UIInterfaceOrientationPortrait"])
        XCTAssertEqual(info["ITSAppUsesNonExemptEncryption"] as? Bool, false)
        XCTAssertNil(info["NSLocationWhenInUseUsageDescription"])
        XCTAssertNil(info["NSLocationAlwaysAndWhenInUseUsageDescription"])
    }

    func test3DWorldPointCentersSite() {
        let corner = Scene3DMath.worldPoint(x: 0, y: 0, sceneWidth: 18, sceneHeight: 14)
        XCTAssertEqual(Double(corner.x), -9, accuracy: 0.0001)
        XCTAssertEqual(Double(corner.y), 0, accuracy: 0.0001)
        XCTAssertEqual(Double(corner.z), -7, accuracy: 0.0001)
        let middle = Scene3DMath.worldPoint(x: 9, y: 7, sceneWidth: 18, sceneHeight: 14)
        XCTAssertEqual(Double(middle.x), 0, accuracy: 0.0001)
        XCTAssertEqual(Double(middle.z), 0, accuracy: 0.0001)
    }

    func test3DSunDirectionIsVerticalAtZenith() {
        let direction = Scene3DMath.sunDirection(elevation: 90, azimuth: 135, northDegrees: 20)
        XCTAssertEqual(Double(direction.x), 0, accuracy: 0.0001)
        XCTAssertEqual(Double(direction.y), 1, accuracy: 0.0001)
        XCTAssertEqual(Double(direction.z), 0, accuracy: 0.0001)
    }

    func test3DSunDirectionFollowsBearingAndSceneNorth() {
        let south = Scene3DMath.sunDirection(elevation: 45, azimuth: 180, northDegrees: 0)
        XCTAssertEqual(Double(south.x), 0, accuracy: 0.0001)
        XCTAssertEqual(Double(south.y), 0.7071, accuracy: 0.001)
        XCTAssertEqual(Double(south.z), 0.7071, accuracy: 0.001)
        let east = Scene3DMath.sunDirection(elevation: 45, azimuth: 90, northDegrees: 0)
        XCTAssertEqual(Double(east.x), 0.7071, accuracy: 0.001)
        XCTAssertEqual(Double(east.z), 0, accuracy: 0.001)
        let rotated = Scene3DMath.sunDirection(elevation: 0, azimuth: 180, northDegrees: 90)
        XCTAssertEqual(Double(rotated.x), -1, accuracy: 0.001)
        XCTAssertEqual(Double(rotated.z), 0, accuracy: 0.001)
    }

    func test3DRotationKeepsPlanViewClockwise() {
        XCTAssertEqual(Double(Scene3DMath.rotationY(degrees: 90)), -Double.pi / 2, accuracy: 0.0001)
        XCTAssertEqual(Double(Scene3DMath.rotationY(degrees: -45)), Double.pi / 4, accuracy: 0.0001)
    }

    func test3DCameraOrbitsAroundSiteCenter() {
        let center = SIMD3<Float>(0, 0.5, 0)
        let south = Scene3DMath.cameraPosition(azimuth: 0, elevation: 0, radius: 10, center: center)
        XCTAssertEqual(Double(south.x), 0, accuracy: 0.001)
        XCTAssertEqual(Double(south.z), 10, accuracy: 0.001)
        let east = Scene3DMath.cameraPosition(azimuth: 90, elevation: 0, radius: 10, center: center)
        XCTAssertEqual(Double(east.x), 10, accuracy: 0.001)
        XCTAssertEqual(Double(east.z), 0, accuracy: 0.001)
        let elevated = Scene3DMath.cameraPosition(azimuth: 0, elevation: 30, radius: 10, center: center)
        XCTAssertEqual(Double(elevated.y), 5.5, accuracy: 0.001)
    }

    func test3DPlacementClampsInsideSite() {
        let clamped = Scene3DMath.clampToSite(-4, 22, width: 18, height: 14)
        XCTAssertEqual(clamped.x, 0, accuracy: 0.0001)
        XCTAssertEqual(clamped.y, 14, accuracy: 0.0001)
        let inside = Scene3DMath.clampToSite(7.5, 6.2, width: 18, height: 14)
        XCTAssertEqual(inside.x, 7.5, accuracy: 0.0001)
        XCTAssertEqual(inside.y, 6.2, accuracy: 0.0001)
    }
}
