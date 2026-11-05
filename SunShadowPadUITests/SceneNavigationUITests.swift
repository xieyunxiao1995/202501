import XCTest

final class SceneNavigationUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func launchAtScenes() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-hasCompletedOnboarding", "YES", "-startTab", "scenes"]
        app.launch()
        return app
    }

    func testTappingSceneCardOpensSimulator() {
        let app = launchAtScenes()

        let card = app.buttons.matching(identifier: "sceneOpen").firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 20),
                      "Each scene card should expose one tappable control.")

        card.tap()

        XCTAssertTrue(app.navigationBars["Shadow Simulator"].waitForExistence(timeout: 10),
                      "Tapping anywhere on a scene card should open Shadow Simulator.")
        XCTAssertFalse(app.buttons["Close"].exists,
                       "Tapping a scene card should not open the scene editor.")
    }

    func testTappingSceneRowOpensSimulator() {
        let app = launchAtScenes()

        let toggle = app.buttons["Switch to list"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 20))
        toggle.tap()

        let row = app.buttons.matching(identifier: "sceneOpen").firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 10))
        row.tap()

        XCTAssertTrue(app.navigationBars["Shadow Simulator"].waitForExistence(timeout: 10),
                      "Tapping a scene row should open Shadow Simulator too.")
    }

    func testEditorShadowsShortcutOpensSimulator() {
        let app = launchAtScenes()

        let edit = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Edit ")).firstMatch
        XCTAssertTrue(edit.waitForExistence(timeout: 20))

        edit.tap()

        let shortcut = app.buttons["View shadows in simulator"]
        XCTAssertTrue(shortcut.waitForExistence(timeout: 10),
                      "The editor should offer a shortcut back to the simulator.")

        shortcut.tap()

        XCTAssertTrue(app.navigationBars["Shadow Simulator"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["Close"].exists,
                       "The editor should close after jumping to the simulator.")
    }

    func testSimulatorOffersSceneEditing() {
        let app = launchAtScenes()

        let card = app.buttons.matching(identifier: "sceneOpen").firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 20))
        card.tap()

        XCTAssertTrue(app.navigationBars["Shadow Simulator"].waitForExistence(timeout: 10))

        let edit = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Edit ")).firstMatch
        XCTAssertTrue(edit.waitForExistence(timeout: 10),
                      "The simulator should offer a shortcut to edit the open scene.")
        edit.tap()

        XCTAssertTrue(app.buttons["Close"].waitForExistence(timeout: 10),
                      "The scene editor should open from the simulator.")
    }
}