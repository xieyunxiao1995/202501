import XCTest

final class TideverseUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Run on a clean simulator to verify real first-launch persistence without defaults overrides.
    func testFirstLaunchIntroductionAndEULA() throws {
        let app = XCUIApplication()
        app.launch()
        let next = app.buttons["introNext"]
        XCTAssertTrue(next.waitForExistence(timeout: 20))
        let title = app.staticTexts["Find a world worth entering."]
        XCTAssertTrue(title.exists)
        XCTAssertGreaterThanOrEqual(title.frame.minX, app.frame.minX + 20)
        XCTAssertLessThanOrEqual(title.frame.maxX, app.frame.maxX - 20)
        attach(app, "welcome-01-worlds")
        next.tap()
        waitForCenteredIntroductionTitle(app, "Your choices leave a trace.")
        attach(app, "welcome-02-choices")
        next.tap()
        waitForCenteredIntroductionTitle(app, "Keep the story. Keep control.")
        attach(app, "welcome-03-control")
        app.buttons["beginExploring"].tap()
        let enter = app.buttons["acceptEULA"]
        XCTAssertTrue(enter.waitForExistence(timeout: 10))
        XCTAssertTrue(enter.isEnabled, "Explicit agreement needs no document-reading gate")
        XCTAssertTrue(enter.isHittable)
        XCTAssertTrue(app.buttons["reviewEULA"].isHittable, "EULA link fits without scrolling")
        XCTAssertTrue(app.buttons["reviewPrivacy"].isHittable, "Privacy link fits without scrolling")
        let acknowledgement = app.staticTexts["By tapping Agree & Enter, you agree to the EULA and acknowledge the AI information above."]
        XCTAssertTrue(acknowledgement.isHittable, "Agreement information fits without scrolling")
        attach(app, "welcome-04-agreement")
        enter.tap()
        XCTAssertTrue(app.staticTexts["Find your next story."].waitForExistence(timeout: 10))
        app.terminate()
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 10))
        app.tabBars.buttons["Settings"].tap()
        let aiConsent = app.buttons["Review AI Data Consent"]
        for _ in 0..<5 where !aiConsent.isHittable { app.swipeUp() }
        XCTAssertTrue(aiConsent.exists, "EULA acceptance must not grant online AI permission")
    }

    func testPreviouslyIntroducedUserSeesIntroductionBeforeAgreement() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "earlier-agreement", "-tideverse.eulaAcceptedAt", "0"]
        app.launch()
        let next = app.buttons["introNext"]
        XCTAssertTrue(next.waitForExistence(timeout: 15))
        XCTAssertFalse(app.buttons["acceptEULA"].exists)
        next.tap()
        waitForCenteredIntroductionTitle(app, "Your choices leave a trace.")
        next.tap()
        waitForCenteredIntroductionTitle(app, "Keep the story. Keep control.")
        app.buttons["beginExploring"].tap()
        XCTAssertTrue(app.buttons["acceptEULA"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["acceptEULA"].isEnabled)
        app.terminate()
        app.launch()
        XCTAssertTrue(next.waitForExistence(timeout: 15), "Without acceptance, a new launch still introduces the app before agreement")
        app.buttons["skipIntroduction"].tap()
        XCTAssertTrue(app.buttons["acceptEULA"].waitForExistence(timeout: 5))
    }

    private func assertLeadingNavigationTitle(_ app: XCUIApplication) {
        let heading = app.descendants(matching: .any).matching(identifier: "leadingNavigationTitle").firstMatch
        XCTAssertTrue(heading.waitForExistence(timeout: 5))
        XCTAssertLessThan(heading.frame.minX, app.frame.minX + 32)
        XCTAssertLessThan(heading.frame.midX, app.frame.midX)
        XCTAssertGreaterThan(heading.frame.height, 20)
        XCTAssertGreaterThan(heading.frame.width, 120, "The leading title must include readable text, not a compressed icon")
    }

    private func waitForCenteredIntroductionTitle(_ app: XCUIApplication, _ text: String) {
        let title = app.staticTexts[text]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        let centered = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            abs(title.frame.minX - app.frame.minX - 24) < 0.5 &&
            title.frame.maxX <= app.frame.maxX - 20
        }, object: title)
        XCTAssertEqual(XCTWaiter.wait(for: [centered], timeout: 5), .completed)
    }

    /// Opt-in only: sends one synthetic, non-private story question to the paid API.
    func testDeepSeekConsentAndLiveReply() throws {
        guard ProcessInfo.processInfo.environment["TIDEVERSE_LIVE_AI"] == "1" else {
            throw XCTSkip("Set TEST_RUNNER_TIDEVERSE_LIVE_AI=1 to run the real-provider check")
        }
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 15))
        resetLocalData(app)
        app.tabBars.buttons["Chats"].tap()
        app.buttons["chatCharacter_mira"].firstMatch.tap()
        let composer = app.descendants(matching: .any).matching(identifier: "chatComposerField").firstMatch
        XCTAssertTrue(composer.waitForExistence(timeout: 10))
        composer.tap()
        composer.typeText("Describe the letter on your desk in two short sentences.")
        app.buttons["chatSend"].tap()
        XCTAssertTrue(app.navigationBars["AI Data Consent"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "directly to DeepSeek")).firstMatch.exists)
        app.buttons["Not Now"].tap()
        XCTAssertTrue((composer.value as? String)?.contains("Describe the letter") == true)
        let reply = app.descendants(matching: .any).matching(NSPredicate(format: "identifier BEGINSWITH %@", "chatMessage_assistant_")).firstMatch
        XCTAssertFalse(reply.exists, "Declining must not send the pending message")
        app.buttons["chatSend"].tap()
        let agree = app.buttons["I Agree · Send Message"]
        XCTAssertTrue(agree.waitForExistence(timeout: 5))
        for _ in 0..<5 where !agree.isHittable { app.swipeUp() }
        agree.tap()
        XCTAssertTrue(reply.waitForExistence(timeout: 120), "The real provider reply must be saved in the thread")
        if app.buttons["Continue"].exists { app.buttons["Continue"].tap() }
        attach(app, "deepseek-live-reply")
        XCTAssertFalse(app.buttons["Dismiss error"].exists)
        app.terminate()
        app.launch()
        app.tabBars.buttons["Chats"].tap()
        app.buttons["chatCharacter_mira"].firstMatch.tap()
        XCTAssertTrue(reply.waitForExistence(timeout: 10), "Live replies persist across relaunch")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
        search.tap()
        search.typeText("Vera")
        app.buttons["finishSearch"].tap()
        app.buttons["chatCharacter_vera"].firstMatch.tap()
        let meet = app.buttons["chatStarterMeet"]
        XCTAssertTrue(meet.waitForExistence(timeout: 5))
        meet.tap()
        app.buttons["chatSend"].tap()
        let responseOrFailure = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            reply.exists || app.buttons["Dismiss error"].exists
        }, object: app)
        XCTAssertEqual(XCTWaiter.wait(for: [responseOrFailure], timeout: 120), .completed)
        if app.buttons["Dismiss error"].exists {
            // One explicit UI retry exercises recovery from transient provider/transport failures.
            let retry = app.buttons["Request reply to last message"]
            XCTAssertTrue(retry.waitForExistence(timeout: 5))
            retry.tap()
        }
        XCTAssertTrue(reply.waitForExistence(timeout: 120), "The second character uses the same real API with its own persona")
        if app.buttons["Continue"].exists { app.buttons["Continue"].tap() }
        attach(app, "deepseek-vera-live-reply")
        XCTAssertTrue(app.staticTexts["Vera Calder"].firstMatch.exists)
        XCTAssertFalse(app.buttons["Dismiss error"].exists)

    }

    func testRefinedMainScreensAndCharacterConversationEntry() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 15))
        resetLocalData(app)
        assertLeadingNavigationTitle(app)
        attach(app, "refined-01-discover")
        app.tabBars.buttons["Chats"].tap()
        assertLeadingNavigationTitle(app)
        attach(app, "refined-02-chats")
        app.tabBars.buttons["Journeys"].tap()
        let moments = app.segmentedControls.buttons["Moments"]
        XCTAssertTrue(moments.waitForExistence(timeout: 5))
        moments.tap()
        XCTAssertTrue(app.staticTexts["A moment starts with a choice"].waitForExistence(timeout: 5))
        attach(app, "refined-03-moments")
        app.segmentedControls.buttons["Journeys"].tap()
        assertLeadingNavigationTitle(app)
        attach(app, "refined-04-journeys")
        app.tabBars.buttons["Settings"].tap()
        if app.navigationBars["Data Management"].exists {
            app.navigationBars.buttons["Settings"].tap()
        }
        assertLeadingNavigationTitle(app)
        attach(app, "refined-05-settings")
        app.tabBars.buttons["Discover"].tap()
        let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
        search.tap()
        search.typeText("Vera")
        app.buttons["finishSearch"].tap()
        app.buttons["character_vera"].tap()
        let chat = app.buttons["openConversation"]
        XCTAssertTrue(chat.waitForExistence(timeout: 5))
        XCTAssertTrue(chat.isHittable)
        XCTAssertTrue(app.buttons["openStory"].isHittable)
        attach(app, "refined-06-profile")
        chat.tap()
        let meet = app.buttons["chatStarterMeet"]
        XCTAssertTrue(meet.waitForExistence(timeout: 5))
        XCTAssertFalse(app.tabBars.buttons["Discover"].isHittable)
        attach(app, "refined-07-conversation")
        meet.tap()
        let composer = app.descendants(matching: .any).matching(identifier: "chatComposerField").firstMatch
        XCTAssertTrue((composer.value as? String)?.contains("Vera") == true)
        XCTAssertFalse(app.navigationBars["AI Data Consent"].exists, "Starters only prepare an editable draft")
        app.buttons["chatSend"].tap()
        XCTAssertTrue(app.navigationBars["AI Data Consent"].waitForExistence(timeout: 5))
        let agree = app.buttons["I Agree · Send Message"]
        let available = XCTNSPredicateExpectation(predicate: NSPredicate(format: "hittable == true"), object: agree)
        let ready = XCTWaiter.wait(for: [available], timeout: 5)
        attach(app, "refined-08-consent")
        XCTAssertEqual(ready, .completed)
        XCTAssertTrue(app.buttons["Not Now"].isHittable)
        app.buttons["Not Now"].tap()
        XCTAssertTrue((composer.value as? String)?.contains("Vera") == true)
    }

    func testMotionFeedbackKeepsControlsResponsive() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Discover"].waitForExistence(timeout: 15))
        assertLeadingNavigationTitle(app)
        let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
        search.tap()
        search.typeText("Mira")
        app.buttons["finishSearch"].tap()
        let card = app.buttons["character_mira"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.press(forDuration: 0.12)
        XCTAssertTrue(app.buttons["openStory"].waitForExistence(timeout: 5))
        let save = app.buttons["Save character"]
        if app.buttons["Unsave character"].exists { app.buttons["Unsave character"].tap() }
        save.press(forDuration: 0.12)
        XCTAssertTrue(app.buttons["Unsave character"].waitForExistence(timeout: 5))
        app.buttons["Unsave character"].tap()
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        app.buttons["Their story"].tap()
        let biography = app.staticTexts["characterBiographyText"]
        XCTAssertTrue(biography.waitForExistence(timeout: 5))
        app.buttons["Their story"].tap()
        let collapsed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: biography)
        XCTAssertEqual(XCTWaiter.wait(for: [collapsed], timeout: 5), .completed)
        attach(app, "motion-profile")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tabBars.buttons["Journeys"].tap()
        app.segmentedControls.buttons["Moments"].tap()
        app.segmentedControls.buttons["Journeys"].tap()
        app.segmentedControls.buttons["Moments"].tap()
        XCTAssertTrue(app.staticTexts["Story Moments"].waitForExistence(timeout: 5))
        assertLeadingNavigationTitle(app)
        attach(app, "motion-library")
    }

    func testSettingsInformationPagesAndFeedback() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 15))
        app.tabBars.buttons["Settings"].tap()
        for (identifier, title) in [
            ("settingsAbout", "About Us"),
            ("settingsTerms", "EULA & Terms of Use"),
            ("settingsPrivacy", "Privacy Policy"),
            ("settingsDeveloper", "Developer Information"),
            ("settingsHelp", "Help Center"),
            ("settingsFeedback", "Feedback & Suggestions")
        ] {
            let row = app.buttons[identifier]
            for _ in 0..<7 where !row.isHittable { app.swipeUp() }
            if !row.isHittable {
                for _ in 0..<7 where !row.isHittable { app.swipeDown() }
            }
            XCTAssertTrue(row.isHittable, identifier)
            row.tap()
            XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 5), title)
            attach(app, identifier)
            if identifier == "settingsHelp" {
                let search = app.textFields.firstMatch
                XCTAssertTrue(search.exists)
                search.tap()
                search.typeText("EULA")
                app.buttons["finishSearch"].tap()
                XCTAssertTrue(app.staticTexts["Does agreeing to the EULA enable online AI?"].exists)
            }
            if identifier == "settingsFeedback" {
                let editor = app.textViews.firstMatch
                XCTAssertTrue(editor.exists)
                editor.tap()
                editor.typeText("A chapter map would make it easier to revisit earlier story choices.")
                app.swipeUp()
                let share = app.buttons["Share Feedback"]
                for _ in 0..<4 where !share.isHittable { app.swipeUp() }
                XCTAssertTrue(share.isEnabled)
                let clear = app.buttons["Clear Draft"]
                for _ in 0..<4 where !clear.isHittable { app.swipeUp() }
                clear.tap()
                XCTAssertFalse(share.isEnabled)
            }
            app.navigationBars.buttons["Settings"].tap()
        }
    }

    func testMainTabsAccessibilityAudit() throws {
        continueAfterFailure = true
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        var findings: [String] = []
        for tab in ["Discover", "Chats", "Journeys", "Settings"] {
            XCTAssertTrue(app.tabBars.buttons[tab].waitForExistence(timeout: 15))
            app.tabBars.buttons[tab].tap()
            attach(app, "audit-\(tab)")
            do {
                try app.performAccessibilityAudit { issue in
                    let element = issue.element
                    let exists = element?.exists == true
                    let label = exists ? element?.label ?? "" : "Unavailable element"
                    let frame = exists ? String(describing: element?.frame) : "Unavailable frame"
                    let row = "\(tab) | \(issue.auditType.rawValue) | \(issue.compactDescription) | \(label) | \(frame)"
                    findings.append(row)
                    print("AUDIT_FINDING: " + row)
                    return false // Keep every issue as a test failure.
                }
            } catch { /* XCTest records each issue; inspect the remaining tabs. */ }
        }
        let report = XCTAttachment(string: findings.joined(separator: "\n"))
        report.name = "accessibility-findings"
        report.lifetime = .keepAlways
        add(report)
    }

    func testSearchAtAccessibilityTextSize() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "-tideverse.onboarded", "YES",
            "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"
        ]
        app.launch()
        let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 15))
        search.tap()
        search.typeText("A search for an undiscovered world")
        app.buttons["finishSearch"].tap()
        let empty = app.staticTexts["No characters found"]
        for _ in 0..<6 where !empty.exists { app.swipeUp() }
        XCTAssertTrue(empty.waitForExistence(timeout: 5))
        XCTAssertGreaterThan(search.frame.height, 44)
        let clear = app.buttons["clearContentSearch"]
        XCTAssertTrue(clear.isHittable)
        attach(app, "search-accessibility-text")
        clear.tap()
        XCTAssertEqual(search.value as? String, "")
    }

    func testEightNewCharactersArePlayable() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Discover"].waitForExistence(timeout: 15))
        resetLocalData(app)
        let ids = ["vera", "daria", "lucian", "maeve", "idris", "rhea", "bastien", "anika"]
        for id in ids {
            let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
            XCTAssertTrue(search.waitForExistence(timeout: 10))
            search.tap()
            search.typeText(id)
            app.buttons["finishSearch"].tap()
            let card = app.buttons["character_\(id)"]
            XCTAssertTrue(card.waitForExistence(timeout: 10))
            card.tap()
            XCTAssertTrue(app.buttons["openStory"].waitForExistence(timeout: 10))
            attach(app, "new-character-\(id)")
            app.buttons["openStory"].tap()
            let choice = app.buttons["choice_\(id)_c1_a"]
            XCTAssertTrue(choice.waitForExistence(timeout: 10))
            choice.tap()
            XCTAssertTrue(app.staticTexts["momentTitle"].waitForExistence(timeout: 10))
            app.buttons["dismissMoment"].tap()
            XCTAssertTrue(app.buttons["choice_\(id)_c2_a"].waitForExistence(timeout: 10))
            app.terminate()
            app.launch()
        }
    }

    func testNativeArchiveSaveAndImportMerge() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 15))
        resetLocalData(app)
        app.buttons["character_mira"].tap()
        app.buttons["openStory"].tap()
        let choice = app.buttons["choice_mira_c1_a"]
        XCTAssertTrue(choice.waitForExistence(timeout: 10))
        choice.tap()
        app.buttons["dismissMoment"].tap()
        app.tabBars.buttons["Settings"].tap()
        if !app.navigationBars["Data Management"].exists { app.buttons["Data Management"].tap() }
        let export = app.buttons["Export JSON Archive"]
        for _ in 0..<4 where !export.isHittable { app.swipeUp() }
        export.tap()
        let nameField = app.textFields.matching(NSPredicate(format: "value BEGINSWITH %@", "Tideverse_")).firstMatch
        XCTAssertTrue(nameField.waitForExistence(timeout: 10))
        let filename = try XCTUnwrap(nameField.value as? String)
        let save = app.buttons.matching(NSPredicate(format: "label IN %@", ["Save", "保存", "存储"])).firstMatch
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        save.tap()
        XCTAssertTrue(app.navigationBars["Data Management"].waitForExistence(timeout: 10))
        app.buttons["Import JSON Archive"].tap()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap()
        search.typeText(filename)
        let file = app.descendants(matching: .any).matching(NSPredicate(format: "label BEGINSWITH %@", filename)).firstMatch
        XCTAssertTrue(file.waitForExistence(timeout: 10))
        file.tap()
        let merge = app.buttons["Import & Merge"]
        XCTAssertTrue(merge.waitForExistence(timeout: 10))
        attach(app, "archive-import-summary")
        merge.tap()
        let result = app.alerts.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Added 0 records and updated 0 journeys")).firstMatch
        XCTAssertTrue(result.waitForExistence(timeout: 10), "Restoring this just-exported archive must be idempotent")
        attach(app, "archive-merge-result")
        app.alerts.buttons["OK"].tap()

        // Restore from the real saved file after deleting this test's authored records.
        resetLocalData(app)
        app.tabBars.buttons["Settings"].tap()
        if !app.navigationBars["Data Management"].exists { app.buttons["Data Management"].tap() }
        let importButton = app.buttons["Import JSON Archive"]
        for _ in 0..<4 where !importButton.isHittable { app.swipeUp() }
        importButton.tap()
        let restoreSearch = app.searchFields.firstMatch
        XCTAssertTrue(restoreSearch.waitForExistence(timeout: 10))
        restoreSearch.tap()
        restoreSearch.typeText(filename)
        let savedFile = app.descendants(matching: .any).matching(NSPredicate(format: "label BEGINSWITH %@", filename)).firstMatch
        XCTAssertTrue(savedFile.waitForExistence(timeout: 10))
        savedFile.tap()
        XCTAssertTrue(app.buttons["Import & Merge"].waitForExistence(timeout: 10))
        app.buttons["Import & Merge"].tap()
        let restored = app.alerts.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Added 2 records and updated 0 journeys")).firstMatch
        XCTAssertTrue(restored.waitForExistence(timeout: 10), "One moment and one journey must be restored")
        attach(app, "archive-restored-after-deletion")
        app.alerts.buttons["OK"].tap()
        app.terminate()
        app.launch()
        app.tabBars.buttons["Journeys"].tap()
        let moments = app.descendants(matching: .any).matching(identifier: "stat_moments").firstMatch
        XCTAssertTrue(moments.waitForExistence(timeout: 10))
        XCTAssertTrue(moments.label.contains("1"))
    }

    func testNativeArchivePickersCancelCleanly() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 15))
        app.tabBars.buttons["Settings"].tap()
        app.buttons["Data Management"].tap()
        for action in ["Export JSON Archive", "Import JSON Archive"] {
            let button = app.buttons[action]
            for _ in 0..<4 where !button.isHittable { app.swipeUp() }
            XCTAssertTrue(button.waitForExistence(timeout: 5))
            button.tap()
            let cancel = app.buttons.matching(NSPredicate(format: "label IN %@", ["Cancel", "取消"])).firstMatch
            attach(app, action)
            if cancel.waitForExistence(timeout: 2) {
                cancel.tap()
            } else {
                // The save destination sheet can use interactive dismissal instead of a Cancel button.
                let handle = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.08))
                let lower = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.75))
                handle.press(forDuration: 0.1, thenDragTo: lower)
            }
            XCTAssertTrue(app.navigationBars["Data Management"].waitForExistence(timeout: 5))
            XCTAssertFalse(app.alerts.firstMatch.exists, "Cancellation should return without an error")
        }
    }

    func testMatchedSearchAndFilterDisclosure() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 15))
        search.tap()
        search.typeText(" mira ")
        app.buttons["finishSearch"].tap()
        let mira = app.buttons["character_mira"]
        XCTAssertTrue(mira.waitForExistence(timeout: 5))
        XCTAssertTrue(mira.isHittable)
        XCTAssertFalse(app.staticTexts["Find your next story."].exists)
        app.buttons["Filter results"].tap()
        XCTAssertTrue(app.buttons["readingStatusFilter"].waitForExistence(timeout: 5))
        app.buttons["clearContentSearch"].tap()
        XCTAssertTrue(app.staticTexts["Find your next story."].waitForExistence(timeout: 5))
    }

    func testSearchRecovery() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 15))
        search.tap()
        search.typeText("zzznomatchingstory")
        XCTAssertTrue(app.staticTexts["No characters found"].waitForExistence(timeout: 5))
        app.buttons["clearContentSearch"].tap()
        XCTAssertTrue(app.buttons["character_mira"].waitForExistence(timeout: 5))
    }

    func testFirstJourneyPersistsAcrossRelaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "NO"]
        app.launch()

        let next = app.buttons["introNext"]
        XCTAssertTrue(next.waitForExistence(timeout: 15), "Welcome call to action")
        attach(app, "01-welcome")
        next.tap()
        next.tap()
        app.buttons["beginExploring"].tap()

        // The launch argument pins onboarding to NO for this process, so restart
        // to let the saved choice take effect.
        app.terminate()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Find your next story."].waitForExistence(timeout: 15))
        resetLocalData(app)
        let firstChapter = app.staticTexts["currentChapter"]
        attach(app, "02-discover")

        let mira = app.buttons["character_mira"]
        XCTAssertTrue(mira.waitForExistence(timeout: 15))
        mira.tap()

        let openStory = app.buttons["openStory"]
        XCTAssertTrue(openStory.waitForExistence(timeout: 15))
        XCTAssertTrue(openStory.label.contains("Begin the journey"), openStory.label)
        attach(app, "03-character")
        openStory.tap()

        XCTAssertTrue(firstChapter.waitForExistence(timeout: 15))
        XCTAssertEqual(firstChapter.label, "A Letter Without a Name")
        attach(app, "04-chapter-one")

        for chapterNumber in 1...4 {
            let choice = app.buttons["choice_mira_c\(chapterNumber)_a"]
            XCTAssertTrue(choice.waitForExistence(timeout: 15), "Choice in chapter \(chapterNumber)")
            choice.tap()

            let moment = app.staticTexts["momentTitle"]
            XCTAssertTrue(moment.waitForExistence(timeout: 15), "Moment after chapter \(chapterNumber)")
            if chapterNumber == 1 { attach(app, "05-story-moment") }
            app.buttons["dismissMoment"].tap()
        }

        XCTAssertEqual(firstChapter.label, "The Lantern Below")
        XCTAssertTrue(app.staticTexts["The story remembers"].exists || app.staticTexts["currentChapter"].exists)
        attach(app, "06-act-two")

        app.tabBars.buttons["Journeys"].tap()
        XCTAssertTrue(app.staticTexts["Stories stay with you."].waitForExistence(timeout: 15))
        let inProgress = app.descendants(matching: .any).matching(identifier: "stat_inprogress").firstMatch
        let moments = app.descendants(matching: .any).matching(identifier: "stat_moments").firstMatch
        XCTAssertTrue(inProgress.waitForExistence(timeout: 15))
        XCTAssertTrue(inProgress.label.contains("1"), inProgress.label)
        XCTAssertTrue(moments.label.contains("4"), moments.label)
        attach(app, "07-journeys")

        app.terminate()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        app.tabBars.buttons["Journeys"].tap()

        let reopened = app.descendants(matching: .any).matching(identifier: "stat_inprogress").firstMatch
        XCTAssertTrue(reopened.waitForExistence(timeout: 15))
        XCTAssertTrue(reopened.label.contains("1"), reopened.label)
        attach(app, "08-journeys-after-relaunch")

        let search = app.descendants(matching: .any).matching(identifier: "contentSearch").firstMatch
        search.tap()
        search.typeText("A Letter Without a Name")
        app.buttons["finishSearch"].tap()
        let savedMoment = app.buttons["moment_mira_c1"]
        for _ in 0..<5 where !savedMoment.isHittable { app.swipeUp() }
        XCTAssertTrue(savedMoment.waitForExistence(timeout: 5))
        attach(app, "09-moment-search")
        savedMoment.tap()
        XCTAssertTrue(app.staticTexts["momentTitle"].waitForExistence(timeout: 5))
        app.buttons["Preview PDF"].tap()
        XCTAssertTrue(app.navigationBars["PDF Preview"].waitForExistence(timeout: 5))
        attach(app, "10-pdf-preview")
        app.buttons["Done"].tap()
    }

    func testJourneyEndingIsReachableAfterFinalChoice() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Discover"].waitForExistence(timeout: 15))
        resetLocalData(app)
        app.buttons["character_mira"].tap()
        app.buttons["openStory"].tap()
        for number in 1...10 {
            let choice = app.buttons["choice_mira_c\(number)_b"]
            XCTAssertTrue(choice.waitForExistence(timeout: 10))
            choice.tap()
            let close = app.buttons["dismissMoment"]
            XCTAssertTrue(close.waitForExistence(timeout: 10))
            close.tap()
        }
        let ending = app.staticTexts["journeyComplete"]
        XCTAssertTrue(ending.waitForExistence(timeout: 5))
        XCTAssertTrue(ending.isHittable)
        attach(app, "completed-journey-ending")
        app.buttons["jumpToReading"].tap()
        XCTAssertTrue(ending.isHittable)
    }

    func testLibraryAtAccessibilityTextSize() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "-tideverse.onboarded", "YES",
            "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"
        ]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Journeys"].waitForExistence(timeout: 15))
        app.tabBars.buttons["Journeys"].tap()
        XCTAssertTrue(app.staticTexts["Stories stay with you."].waitForExistence(timeout: 5))
        for identifier in ["stat_inprogress", "stat_completed", "stat_moments"] {
            let statistic = app.descendants(matching: .any).matching(identifier: identifier).firstMatch
            for _ in 0..<4 where !statistic.isHittable { app.swipeUp() }
            XCTAssertTrue(statistic.isHittable, identifier)
        }
        attach(app, "library-accessibility-text")
    }

    func testDiscoverFilterRecovery() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()
        let filter = app.buttons["readingStatusFilter"]
        XCTAssertTrue(filter.waitForExistence(timeout: 15))
        filter.tap()
        app.buttons["Completed"].tap()
        let clear = app.buttons["clearDiscoverFilters"]
        // This scenario uses a fresh test archive with no completed journeys.
        if clear.waitForExistence(timeout: 3) {
            clear.tap()
            XCTAssertTrue(app.buttons["character_mira"].waitForExistence(timeout: 5))
        } else {
            XCTAssertTrue(app.buttons["Clear filters"].firstMatch.exists)
        }
    }

    func testChatConversationAdvancesStoryAndKeyboardDismisses() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-tideverse.onboarded", "YES", "-tideverse.eulaVersion", "eula-v1", "-tideverse.eulaAcceptedAt", "1"]
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Chats"].waitForExistence(timeout: 15))
        resetLocalData(app)

        app.tabBars.buttons["Chats"].tap()
        let mira = app.buttons["chatCharacter_mira"].firstMatch
        XCTAssertTrue(mira.waitForExistence(timeout: 15))
        mira.tap()

        let header = app.buttons["storyChapterHeader"].firstMatch
        XCTAssertTrue(header.waitForExistence(timeout: 10))
        XCTAssertTrue(header.label.contains("A Letter Without a Name"), header.label)
        attach(app, "09-chat-story-header")

        let composer = app.descendants(matching: .any).matching(identifier: "chatComposerField").firstMatch
        XCTAssertTrue(composer.waitForExistence(timeout: 10))
        composer.tap()
        composer.typeText("I want to study the wax seal")

        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 5), "Typing should open the keyboard")
        attach(app, "10-chat-keyboard")

        app.staticTexts["Mira Vale"].firstMatch.tap()
        let keyboardGone = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: keyboard)
        XCTAssertEqual(XCTWaiter().wait(for: [keyboardGone], timeout: 5), .completed,
                       "Tapping outside the text field should dismiss the keyboard")
        attach(app, "11-keyboard-dismissed")

        app.buttons["chatSend"].firstMatch.tap()
        if app.buttons["Not Now"].waitForExistence(timeout: 3) {
            app.buttons["Not Now"].tap()
            // With a real provider configured, declining keeps the unsent draft.
            // Canonical chapter directions remain playable offline through the ribbon.
            header.tap()
            let choice = app.buttons["chatStoryChoice_mira_c1_a"]
            XCTAssertTrue(choice.waitForExistence(timeout: 10))
            attach(app, "12-offline-story-direction")
            choice.tap()
        } else {
            let follow = app.buttons["storySuggestionFollow"].firstMatch
            XCTAssertTrue(follow.waitForExistence(timeout: 10))
            attach(app, "12-story-suggestion")
            follow.tap()
        }

        let advanced = NSPredicate(format: "label CONTAINS 'Chapter 2 of 10'")
        expectation(for: advanced, evaluatedWith: app.buttons["storyChapterHeader"].firstMatch)
        waitForExpectations(timeout: 10)
        XCTAssertTrue(app.descendants(matching: .any)
            .matching(NSPredicate(format: "label CONTAINS 'Decision · A Letter Without a Name'"))
            .firstMatch.waitForExistence(timeout: 5))
        attach(app, "13-story-advanced")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tabBars.buttons["Journeys"].tap()
        let moments = app.descendants(matching: .any).matching(identifier: "stat_moments").firstMatch
        XCTAssertTrue(moments.waitForExistence(timeout: 10))
        XCTAssertTrue(moments.label.contains("1"), moments.label)
        attach(app, "14-journeys-after-chat")
    }

    private func resetLocalData(_ app: XCUIApplication) {
        app.tabBars.buttons["Settings"].tap()
        let dataManagement = app.buttons["Data Management"]
        if !dataManagement.waitForExistence(timeout: 5) { app.swipeUp() }
        XCTAssertTrue(dataManagement.waitForExistence(timeout: 5))
        dataManagement.tap()

        let deleteAll = app.buttons["Delete All Local Data"]
        for _ in 0..<6 where !deleteAll.isHittable { app.swipeUp() }
        XCTAssertTrue(deleteAll.waitForExistence(timeout: 5))
        deleteAll.tap()

        let confirm = app.buttons["Delete All Data"]
        XCTAssertTrue(confirm.waitForExistence(timeout: 5))
        confirm.tap()

        let ok = app.alerts.buttons["OK"]
        XCTAssertTrue(ok.waitForExistence(timeout: 5))
        ok.tap()
        app.tabBars.buttons["Discover"].tap()
    }

    private func attach(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
