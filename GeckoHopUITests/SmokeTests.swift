import XCTest

final class SmokeTests: XCTestCase {
    @MainActor
    func testSupportComposerKeepsActionsVisible() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-language", "en", "-privacyAccepted", "YES", "-theme", "system"]
        app.launchEnvironment["GeckConnent_UITEST_RUN"] = UUID().uuidString
        app.launch()

        let email = app.textFields["Email address"]
        XCTAssertTrue(email.waitForExistence(timeout: 12))
        if !email.isHittable { app.swipeUp() }
        email.tap()
        email.typeText("test@example.com")
        let password = app.secureTextFields["Password"]
        if !password.isHittable { app.swipeUp() }
        password.tap()
        password.typeText("test-pass")
        let submit = app.buttons["auth.submit"]
        if !submit.isHittable { app.swipeUp() }
        submit.tap()
        dismissPasswordPrompt(in: app)

        let support = app.buttons["Support"]
        XCTAssertTrue(support.waitForExistence(timeout: 12))
        dismissPasswordPrompt(in: app)
        let draft = app.descendants(matching: .any)["support.draft"]
        support.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        if !draft.waitForExistence(timeout: 3) {
            dismissPasswordPrompt(in: app)
            support.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
        XCTAssertTrue(draft.waitForExistence(timeout: 5))
        let reply = app.staticTexts["Please attach a connection report so we can check which route was active when the network changed."]
        XCTAssertTrue(reply.waitForExistence(timeout: 8))
        XCTAssertTrue(app.buttons["Choose a photo"].isHittable)
        XCTAssertTrue(app.buttons["Attach a connection report"].isHittable)
        let send = app.buttons["Send"]
        XCTAssertTrue(send.isHittable)
        XCTAssertFalse(send.isEnabled)
        save("support", app)
        draft.tap()
        draft.typeText("I can reproduce this on mobile data.")
        XCTAssertTrue(send.isEnabled)
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.exists)
        reply.tap()
        XCTAssertTrue(keyboard.waitForNonExistence(timeout: 5))
        XCTAssertEqual(draft.value as? String, "I can reproduce this on mobile data.")
        draft.tap()
        XCTAssertTrue(keyboard.waitForExistence(timeout: 5))
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45)).tap()
        XCTAssertTrue(keyboard.waitForNonExistence(timeout: 5))
        send.tap()
        let thanks = app.alerts["Thank you for your feedback"]
        XCTAssertTrue(thanks.waitForExistence(timeout: 5))
        thanks.buttons["OK"].tap()
        XCTAssertTrue(app.buttons["Retry send"].waitForExistence(timeout: 5))
        app.buttons["Discard retry"].tap()
        XCTAssertEqual(draft.value as? String, "I can reproduce this on mobile data.")
        XCTAssertTrue(app.buttons["Choose a photo"].isHittable)
        app.buttons["Attach a connection report"].tap()
        XCTAssertTrue(app.buttons["Send to support"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testSwitchingToEnglishUpdatesTheOpenLoginPage() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(zh-Hans)", "-privacyAccepted", "YES"]
        app.launchEnvironment["GeckConnent_UITEST_RUN"] = UUID().uuidString
        app.launch()

        let language = app.buttons["app.language"]
        XCTAssertTrue(language.waitForExistence(timeout: 12))
        if language.value as? String != "简体中文" {
            selectLanguage("简体中文", in: app)
        }
        let chineseEmail = app.textFields["邮箱"]
        XCTAssertTrue(chineseEmail.waitForExistence(timeout: 5))
        chineseEmail.tap()
        chineseEmail.typeText("test@example.com")

        selectLanguage("English", in: app)
        let email = app.textFields["Email address"]
        XCTAssertTrue(email.waitForExistence(timeout: 5))
        XCTAssertEqual(email.value as? String, "test@example.com")
        XCTAssertEqual(app.buttons["auth.mode.register"].label, "Create account")
        XCTAssertFalse(chineseEmail.exists)

        app.terminate()
        app.launch()
        XCTAssertTrue(email.waitForExistence(timeout: 12))
    }

    @MainActor
    func testOnboardingAndAccountEntryPoints() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)", "-language", "en", "-theme", "light"]
        app.launchEnvironment["GeckConnent_UITEST_RUN"] = UUID().uuidString
        app.launch()
        if app.staticTexts["How your data is used"].exists {
            save("disclosure", app)
            app.buttons["Continue"].tap()
        }

        XCTAssertTrue(app.textFields["Email address"].waitForExistence(timeout: 12))
        XCTAssertFalse(app.staticTexts["Routes"].exists)
        app.buttons["Show password"].tap()
        XCTAssertTrue(app.textFields["Password"].exists)
        app.buttons["Hide password"].tap()
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        save("login", app)

        app.buttons["auth.mode.register"].tap()
        XCTAssertTrue(app.secureTextFields["Repeat password"].exists)
        save("register", app, settling: true)
        app.buttons["auth.mode.login"].tap()
        app.buttons["Forgot password?"].tap()
        XCTAssertTrue(app.secureTextFields["New password"].exists)
        if !app.buttons["Back to sign in"].isHittable { app.swipeUp() }
        app.buttons["Back to sign in"].tap()

        XCTAssertFalse(app.buttons["Guest support"].exists)

        let email = app.textFields["Email address"]
        if !email.isHittable { app.swipeDown() }
        email.tap()
        email.typeText("test@example.com")
        let password = app.secureTextFields["Password"]
        password.tap()
        password.typeText("test-pass")
        let submit = app.buttons["auth.submit"]
        if !submit.isHittable { app.swipeUp() }
        submit.tap()
        dismissPasswordPrompt(in: app)

        let routes = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "route."))
        let route = routes.firstMatch
        XCTAssertTrue(route.waitForExistence(timeout: 15))
        XCTAssertTrue(app.buttons["Support"].exists)
        dismissPasswordPrompt(in: app)
        save("home", app, settling: true)

        app.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["Appearance"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Traffic routing"].exists)
        XCTAssertFalse(app.buttons["Custom domain rules"].exists)
        XCTAssertFalse(app.buttons["Update routing rules"].exists)
        XCTAssertTrue(app.staticTexts["BABIC PEKARA d.o.o."].exists)
        dismissPasswordPrompt(in: app)
        save("settings", app)
        let privacy = app.buttons["Privacy notice"]
        if !privacy.isHittable { app.swipeUp() }
        privacy.tap()
        XCTAssertTrue(app.navigationBars["Privacy notice"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["BABIC PEKARA d.o.o."].exists)
        app.buttons["Done"].tap()
        app.navigationBars.buttons.firstMatch.tap()

        let alternate = routes.element(boundBy: route.isSelected ? 1 : 0)
        XCTAssertTrue(alternate.waitForExistence(timeout: 5))
        dismissPasswordPrompt(in: app)
        alternate.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        save("alternate-route", app, settling: true)
        XCTAssertTrue(alternate.isSelected)

        let account = app.buttons["Account"]
        if !account.isHittable {
            dismissPasswordPrompt(in: app)
            let back = app.navigationBars.buttons.firstMatch
            if back.isHittable { back.tap() }
        }
        XCTAssertTrue(account.waitForExistence(timeout: 5))
        account.tap()
        let delete = app.buttons["Delete account"]
        if !delete.isHittable { app.swipeUp() }
        delete.tap()
        XCTAssertTrue(app.alerts["Request account deletion?"].waitForExistence(timeout: 5))
        save("deletion-confirmation", app)
        app.alerts.buttons["Cancel"].tap()
        XCTAssertTrue(delete.exists)
        delete.tap()
        app.alerts.buttons["Confirm deletion"].tap()
        let alert = app.alerts["Account deleted"]
        let receipt = alert.staticTexts["The service confirmed that your account was deleted."]
        XCTAssertTrue(receipt.waitForExistence(timeout: 5))
        save("deletion-receipt", app)
        alert.buttons["OK"].tap()
        XCTAssertTrue(app.textFields["Email address"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["auth.mode.register"].exists)
        XCTAssertFalse(app.buttons["Guest support"].exists)
        XCTAssertFalse(route.exists)

        app.terminate()
        app.launchArguments = ["-AppleLanguages", "(zh-Hans)", "-language", "zh", "-theme", "light"]
        app.launch()
        XCTAssertTrue(app.textFields["邮箱"].waitForExistence(timeout: 12))
        XCTAssertFalse(app.buttons["访客客服"].exists)
        save("login-zh", app)
    }

    @MainActor
    private func selectLanguage(_ name: String, in app: XCUIApplication) {
        app.buttons["app.language"].tap()
        let option = app.buttons[name]
        if !option.waitForExistence(timeout: 1) {
            let submenu = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@ OR label BEGINSWITH %@", "App language", "界面语言")).firstMatch
            if submenu.isHittable { submenu.tap() }
        }
        XCTAssertTrue(option.waitForExistence(timeout: 3))
        option.tap()
    }

    @MainActor
    private func dismissPasswordPrompt(in app: XCUIApplication) {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let labels = ["Not Now", "Later", "Don't Save", "Don’t Save", "以后", "稍后", "不保存"]
        for target in [app, springboard] {
            let prompt = target.buttons.matching(NSPredicate(format: "label IN[c] %@", labels)).firstMatch
            if prompt.isHittable {
                prompt.tap()
                return
            }
        }
    }

    @MainActor
    private func save(_ name: String, _ app: XCUIApplication, settling: Bool = false) {
        if settling {
            let settled = expectation(description: "Wait for the account form transition")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { settled.fulfill() }
            wait(for: [settled], timeout: 1)
        }
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
