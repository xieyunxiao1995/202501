# First launch and EULA entry

The app keeps the native system launch screen brief. After launch, new installations show three swipeable introduction pages: the fictional adult cast, authored choices and remembered consequences, and local moments/memory controls. Next advances manually; Skip introduction goes directly to the welcome agreement page.

The welcome page creates no account and collects no credentials. Its compact layout explains fictional AI characters, inaccurate generated replies, entertainment-only use and separate online AI permission. EULA and Privacy Policy links are available without requiring them to be opened. Tapping **Agree & Enter** explicitly accepts the agreement and immediately enters the app. There is no reading-completion state, required document scrolling or additional agreement switch. The entry button remains pinned at the bottom. Normal-size content is intended to fit on one screen; the content can scroll if the available display height is unusually small.

`UsageAgreementService` saves the current EULA version and acceptance date in local preferences. Users without a current agreement always see the three-page introduction before the welcome gate on each app launch, even if an earlier launch already saved introduction completion. After agreeing, subsequent launches open the app directly. A future EULA version change requires acceptance again. Content deletion retains the introduction and EULA preferences; AI consent is cleared separately. No account or password is created.

EULA acceptance never writes `ConsentService`. Online AI still requires its separate, versioned data-transfer notice and permission. Offline authored stories remain available after EULA acceptance without enabling online AI.

## Verification

- Debug simulator compilation succeeded.
- All 25 unit tests passed, including versioned EULA acceptance without granting AI consent.
- The updated clean-install UI walkthrough checks all three pages, immediately available entry, visible legal links and acknowledgement without scrolling, direct acceptance without opening a document, persistent acceptance after relaunch, and AI permission still pending.
- Normal-size journey regression passed through chapter choices, persisted progress, relaunch and PDF preview.
- Entry simplification requested on 2026-11-12 replaces the earlier read-to-end gate. The updated clean-install UI test passed in 26.9 seconds, confirming direct entry and visible legal links/acknowledgement without scrolling on the normal-size iPhone 18 Pro simulator; screenshots are saved in `Documentation/FirstLaunch/`.
- Screenshot review found oversized artwork widening the first page; artwork now renders within a fixed-height overlay so intrinsic image width cannot stretch the content. The first-page UI test checks that the title frame remains inside the screen margins.

Run `testFirstLaunchIntroductionAndEULA` alone on a clean disposable simulator installation. It deliberately uses real saved preferences rather than production reset hooks or defaults overrides. Run existing-state journey UI tests separately, because they write persistent onboarding and story state. Do not uninstall a user's installation to run this test.

This is implementation evidence, not a legal review or an App Store approval guarantee. The final publisher must supply verified identity/contact information, reviewed policy/terms, and operational AI processing/reporting details before release. The existing Release configuration guard remains in effect.

Introduction order regression (2026-11-12): both the clean first-launch test and the previously introduced / not-yet-agreed relaunch test passed (2 UI tests, 47.4 seconds total). They verify the three-page introduction precedes the compact agreement page, optional introduction skipping still reaches agreement, direct agreement enters the app, and an accepted relaunch opens the main tabs.
