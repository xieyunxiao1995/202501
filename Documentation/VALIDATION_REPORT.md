# Tideverse implementation validation — 2026-10-28

This report records the current source and build evidence. It is not a release or App Store acceptance claim.

## Verified

- `python3 Tools/verify_package.py`: 32 adult character definitions, 32 original stories, 256 authored chapters, 512 distinct choices; all 96 character images and Xcode source/resource references found.
- `node Backend/self_test.mjs`: mocked, non-billable gateway integration, canonical choice context (including Act II canon), invalid character IDs, duplicate/forged/out-of-order chapter IDs, invalid image encoding and rate limiting.
- `xcodebuild test` on the iPhone 18 Pro simulator with Xcode 27: 12 unit tests and the end-to-end UI test pass, including Act II act/echo metadata, branch-aware echo resolution, legacy-completion reopening, full-catalog completion and archive round trip.
- Act II was added to all twenty expansion characters: 80 authored chapters, 160 choices and 160 branch-aware callbacks, plus a unique memory hint on every choice (512 total). Chapter openings were audited against both preceding branches; eighteen statements that assumed one branch were rewritten to neutral phrasing, and every new choice now satisfies the required `memoryHint` decode field.
- XCUITest `testFirstJourneyPersistsAcrossRelaunch` passes end to end: onboarding, local-data reset, character profile, four choices, Story Moment, Act II chapter 5 ("The Lantern Below"), Journeys statistics (1 in progress, 4 moments), relaunch persistence. Screenshots are attached to the test result.
- Runtime screenshots were inspected for Discover, character profile, chapter, Story Moment, Act II and Journeys. Two real layout defects were found and fixed during this pass: a `scaledToFill` width inflation that clipped text, and a character-page CTA hidden under the tab bar (now pinned above it).
- Xcode 27.0 iOS Debug application and XCTest target compilation, `CODE_SIGNING_ALLOWED=NO`: successful. Deployment target remains iOS 17.
- New character sheets and resulting contact sheets inspected. All thirty-two fictional characters are adults, age 29–48. No explicit art or sexualized workwear is included.
- Original character, chapter and choice IDs preserved. Act II appended 48 chapters and 96 outcomes to the twelve launch journeys; the expansion added 20 characters, 80 chapters and 160 outcomes. SwiftData model definitions unchanged; Act II metadata is optional and backward compatible.
- Publisher metadata preflight correctly reports the empty real publisher/support/policy/gateway fields. Release configuration cannot be treated as ready while those fields are missing.

## Implemented, requires runtime verification

- Continue-journey discovery, search, genre and saved-character filtering, bookmarks, hide/restore controls, accessible grid adaptation.
- Chapter preview, saved-outcome sheet, previous-choice recap, journey status/search and moment export navigation.
- Protected local draft files, failed-send draft retention, consent cancellation, late-reply deletion protection and bounded JSON responses.
- Memory editing save-error handling, strict backup validation, expanded twelve-journey import limit and storage-open recovery without resetting the database.
- Selected-reply reporting with explicit email/share actions. A real receiving support address and operational moderation remain unconfigured.
- Deliberate requests for replies to the last unanswered message reuse the stored user turn. Message and conversation deletion preserve separately saved memories and story progress.
- Review-and-edit memory capture from chat messages or Story Moments; context-limit visibility in the memory ledger.
- Photo preparation clears the prior attachment, disables sending while preparing and cancels stale OCR results when selection changes.
- AI consent stores notice version, acceptance date and revocation date. A legacy Boolean or stale version does not authorize requests. Settings distinguishes enabling AI from sending a pending message.
- Optional photo-free JSON export, shared 35 MB export/import bound, canonical story prose and scene restoration on import, and independent saved-moment deletion.

## Not performed

Physical-device, VoiceOver, Dynamic Type runtime, light-mode runtime (app is forced dark) and large-accessibility-size screenshot review were not performed. The UI test runs at the default simulator text size. Generic compilation does not prove every interactive branch, but the golden-path journey, Act II transition and relaunch persistence are now exercised on the simulator.

No real provider request, gateway deployment, production authentication/attestation, moderation-service integration, signing/archive, public policy/support URL reachability check or App Store submission was performed. The previously shared API key must be revoked; it is not stored in the project. Account-specific model availability must be verified with a new server-only credential.

## Remaining release requirements

Provide a real publisher name, working support mailbox, publicly reachable reviewed privacy/support pages and effective date. Deploy and secure the AI gateway with authenticated clients, quotas, moderation/reporting operations and a currently enabled model. Configure the actual gateway origin. Review legal copy and privacy disclosures against real operations. Complete the required device/accessibility/storage/network QA before distribution.


## Twenty-character expansion validation

The expansion preserves the pre-existing twelve character records and 96 authored chapters as complete dictionaries. It adds twenty original adult characters and eighty chapters. A second Act II pass then added four chapters to each expansion journey, with two branch-aware callbacks per chapter, bringing the catalog to 32 characters, 256 chapters and 512 choices. All Act II openings were audited against both preceding branches; twenty statements that assumed one branch or invented a supporting character's history were rewritten (nineteen branch assumptions and one echo).

All sixty new image resources were generated with the built-in imagegen tool, split from source sheets, inspected in a contact sheet and validated for dimensions/alpha/file decoding. The full catalog has 96 distinct valid character image resources. Canonical backend content was regenerated and its mocked integration checks pass. Catalog-count assertions and archive round-trip expectations were updated. The full XCTest suite, including the end-to-end journey UI test, was run against the 32-character catalog on the iPhone 18 Pro simulator and passed. Physical-device execution was not performed for this expansion.

The overall release blockers described above are separate from this content expansion and remain unresolved.

## Normal text-size review — 2026-11-11

Per user direction, normal-size rendering and operation are the current priority; the experimental maximum-size heading-location test has been removed. Adaptive behavior already implemented remains.

Verified 19 unit tests and 2 normal-size UI tests: full story/Act II/relaunch flow, saved-moment search and opening/closing the PDF preview, plus matched character search/filter disclosure. Inspected the actual saved-moment row and PDF preview captures. The search capture exposed an unnecessarily large no-journeys state above matching moments; that state is now omitted when a moment matches, with a final flow rerun recorded separately.

The global accessibility audit is still not certified. Verified real publisher metadata, production services and device QA are still absent.

Final normal-size flow rerun passed after removing the redundant no-journeys panel; inspected the updated moment search capture. Result: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_11-39-54-+0800.xcresult.

## Photo privacy and local text recognition — 2026-11-11

Found and fixed a real attachment size bug: the 1024-pixel thumbnail was re-rendered at the display's default 2x/3x scale. The JPEG renderer now explicitly uses scale 1 and an opaque white surface. PhotosPicker selection delegates to the same data-preparation path tested below; no new automatic photo access or upload was introduced.

22 unit tests passed in the iPhone 18 Pro simulator (iOS 27.0), including:
- Generated a 2200×1100 JPEG with GPS coordinates and a private EXIF UserComment. Confirmed the fixture had GPS; the prepared JPEG is 1024×512, within the upload byte bound, and has neither GPS nor the original comment.
- Invalid image data is rejected with the existing readable error.
- Actual Vision recognition of a generated English text image returns TIDEVERSE and ARCHIVE using the on-device service.

Result bundle: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_11-51-16-+0800.xcresult. Package and mocked backend checks also passed. Real-device PhotosPicker interaction, different real camera formats/orientations and production upload remain unverified; these tests do not establish full provider privacy or App Store readiness.

## Privacy manifest and native archive picker — 2026-11-11

Added PrivacyInfo.xcprivacy to the app Resources phase, declaring NSPrivacyAccessedAPICategoryUserDefaults with CA92.1 for the app's own preference/consent storage. Verified the actual built Tideverse.app contains this declaration. Portable package validation now checks its presence and required API entry. This is an API-use declaration; data-collection/tracking disclosures for the real gateway/provider still require operational review.

The native export and import pickers both open successfully and can be cancelled/dismissed back to Data Management without an error alert. The save-destination sheet uses an interactive dismissal rather than always exposing a Cancel button. Final picker test passed: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_11-58-30-+0800.xcresult. The earlier combined run passed 22 unit tests, with its UI failure isolated to the corrected picker selector/dismissal expectation.

Actual file-provider save-and-reimport is not claimed by this cancellation test. Model-level archive round-trip coverage remains separate. Source: https://developer.apple.com/documentation/technotes/tn3183-adding-required-reason-api-entries-to-your-privacy-manifest

## Native file backup recovery — 2026-11-11

The system-file round trip now passes in the normal-size iPhone simulator UI:
1. Reset the test archive and make one authored Mira chapter choice.
2. Export JSON to the system file provider using a timestamped filename.
3. Search for that actual saved file in the importer and merge it; assert zero new records/zero journey updates.
4. Delete local data, select the same saved file again and merge; assert two records restored (one moment, one journey).
5. Relaunch and confirm the restored moment count is one.

Inspected the import counts/replacement explanation and successful restore alert screenshots. Result: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_12-04-32-+0800.xcresult. Package and mocked backend checks passed.

Backup filenames now include ISO 8601 export time with colons replaced by hyphens, so different exports are easier to identify. This test writes synthetic authored-story archives to the simulator's local Files provider; cloud file providers and physical-device restore remain unverified.

Final normal-scope regression on 2026-11-11: 22 unit tests and 8 UI tests passed, zero failures, including native backup cancellation/save/import/deletion recovery/relaunch. Bundle: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_12-09-38-+0800.xcresult. System accessibility audit and maximum-size tests were excluded explicitly. Remaining external release prerequisites are recorded in RELEASE_STATUS.md.

## Core character depth / Act III — 2026-11-11

Four core biographies/personality/voice definitions expanded; eight authored sequel chapters and sixteen outcomes appended without changing existing chapter/choice IDs. Current catalog: 32 characters, 264 chapters, 528 choices. Generated backend canon and character biographies synchronized; mocked provider-payload test confirms authored background is present.

23 unit tests passed, including full-catalog completion/archive round trip and restoring a legacy eight-chapter completion into Act III. Three UI tests passed across two runs: ten-chapter ending, original first-journey/Act II/relaunch/PDF flow, and offline chat progression. Inspected the new ending capture. Result bundles: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_13-48-08-+0800.xcresult and the bundle named in /tmp/tideverse-act3-regression.log.

The old store screenshot set is marked needsRecapture because profile text and chapter counts visibly changed. This content expansion does not resolve the external production release requirements.

## Eight new playable adults — 2026-11-11

Added Vera Calder, Daria Sen, Lucian Rook, Maeve Orin, Idris Keene, Rhea Sato, Bastien Morel and Anika Dove. Each has an authored background/personality/voice/goal/boundary, eight chapters, sixteen authored outcomes and three matched local image resources. New content contributes 64 chapters, 128 choices and about 9,100 English words across chapter openings and outcomes.

Current catalog: 40 characters, 40 stories, 328 chapters, 656 choices and 120 character images. Existing IDs and earlier chapters are preserved. Trusted backend biographies and story canon regenerated; mocked gateway test passed. Portable validator passed. Actual asset contact sheet inspected at Artwork/Expansion8/Preview.jpg; normal app profiles inspected from captured UI screenshots.

24 unit tests and one eight-character UI test passed (25 tests, 0 failures). The UI test searches each new character, opens the profile, makes a first-chapter choice, dismisses the saved moment and verifies chapter 2. Model tests complete all 40 stories and restore the full archive. Bundle: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_14-26-31-+0800.xcresult.

No production service or App Store approval is claimed. Pre-expansion store screenshot set remains historical until recaptured.
