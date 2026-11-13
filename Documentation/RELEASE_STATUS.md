Update — 2026-11-12: The iOS app now uses direct DeepSeek Chat Completions with `deepseek-flash`. A real synthetic vision request returned HTTP 200 and correctly identified a green image; all 30 unit tests passed. DeepSeek permission is versioned separately (`deepseek-data-v2`). An embedded three-fragment Base64 credential was requested explicitly by the owner; it remains recoverable and introduces client credential/usage exposure. The old Ark/gateway findings below describe the pre-DeepSeek architecture. No gateway deployment is required by this direct client build; real publisher/contact/policy details, operational moderation/report delivery, signing and device QA still remain open. See DEEPSEEK_INTEGRATION.md for current integration evidence.

# Tideverse release readiness — 2026-11-11

Current assessment: the app has a functional authored-story foundation, but it is not ready for App Store submission. Local tests do not establish Apple approval. App Store Connect state and deployed provider behavior have not been inspected.

## Verified implementation and evidence

- Native SwiftUI/SwiftData app, iOS 17 minimum target, four tabs, dark interface.
- Package validation passes: 40 fictional adult characters, 40 stories, 328 chapters, 656 authored choices and 120 character images.
- The latest unit run passed all 25 tests with zero failures: `/tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_19-23-13-+0800.xcresult`.
- The mocked gateway integration passes. It does not call or verify the real provider.
- Prior isolated UI runs passed the three-page introduction, EULA entry, persisted acceptance without AI permission, chapter progress/relaunch/PDF, and all six settings information pages including help search and feedback draft controls.
- Existing local controls include editable/pinned memories, selected-photo preparation/OCR, deletion, JSON backup/import and PDF Story Moments.
- Bluehour Storyworks is the newly adopted creative brand. It is not evidence of a registered publisher or operational contact service.

## Submission blockers and unverified areas

| Area | Current evidence | Next action |
|---|---|---|
| Publisher and support | Publisher name, mailbox, privacy/support URLs and legal date are empty; reviewed flag is false | Supply actual publisher/contact details, publish working pages, review legal and operational disclosures |
| Advertised online AI | Gateway origin is empty; the real account/model and deployed service have not been verified | Deploy and test online features, or deliberately scope and accurately configure/market a complete offline release |
| AI safety and reporting | Worker applies IP rate limiting and prompt constraints; no independent input/output moderation, install authentication/attestation, spending cap or report intake route was found | Implement and test risk-appropriate moderation, service protection, reachable report destination and operational response workflow |
| Privacy declarations | UserDefaults required-reason manifest is present; store privacy answers and actual provider retention are not verified | Map messages/photos/memories/identifiers/logs to actual practices, confirm processing region, retention/deletion and applicable privacy labels |
| EULA and age rating | In-app read-and-agree flow works; no evidence of App Store Connect license or questionnaire configuration | Decide standard Apple EULA versus legally reviewed custom EULA; complete age questionnaire based on content/features rather than character ages |
| Signing and final delivery | No DEVELOPMENT_TEAM configured in the project; no signed archive/upload/physical-device acceptance evidence | Configure team/signing, validate archive, run physical-device/TestFlight smoke tests and prepare complete store metadata |
| Accessibility | Normal-size functional UI tests passed; prior broad accessibility findings remain unresolved | Evaluate and fix relevant normal-use issues; only claim accessibility features actually verified. Maximum-size heading investigation remains outside the user's requested scope |

`python3 Tools/verify_release.py` currently fails. It reports missing publisher, support mailbox, policy/support/gateway URLs, legal date and reviewed flag. The Release guard remains intact. It is a project safeguard, not an Apple-provided certification test.

The Worker currently targets the Beijing Ark endpoint. If that architecture is deployed, privacy/consent wording must accurately describe the actual processing region and service-provider practices. `store:false` alone does not establish absence of all logging or retention.

The App Store description is already updated to 40 characters and 328 chapters. The reviewer-note draft and checklist counts have now been aligned, and the new introduction/EULA path is described. Reviewer notes still explicitly say the build is not ready; do not submit that limitation paragraph as proof of a functioning live service. Refresh screenshots against the final signed build before submission.

Entry update (2026-11-12): the compact welcome page now accepts an explicit Agree & Enter tap without requiring document-opening, a read-to-end checkpoint or a second switch. Online AI consent remains separate.

## Valuable next features, in priority order

1. **Journey recap / story yearbook:** assemble a completed journey's canonical choices, consequences, existing callbacks, ending and selected memories into one readable recap and whole-journey PDF. Single-moment PDF export and a choice history already exist; extend those rather than adding a duplicate library. Use authored/local text so this remains useful offline and does not introduce new AI transfers.
2. **Preserved replay saves:** allow a fresh run while retaining the original ending, moments and choice history; compare only authored alternatives. This requires explicit run identities and archive/schema migration because current progress is stored per story. Do not silently reset existing journeys or imply an exponential branching story tree.
3. **Reading preferences:** offer a few comfortable reading sizes and line-spacing choices, persist them locally, and apply consistently to story text and moments. Maintain the existing dark visual system.

These features improve reader value; they are not Apple-mandated additions or a guarantee against minimum-functionality/spam rejection. Service readiness and accurate release information take priority over more catalog expansion.

## Official references checked

- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/): completeness, reachable support, AI-content safety, accurate metadata and third-party data permission.
- [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/): store privacy answers depend on actual collection and provider practices; manifest presence alone is insufficient.
- [Provide a custom license agreement](https://developer.apple.com/help/app-store-connect/manage-app-information/provide-a-custom-license-agreement/): standard Apple EULA applies unless a custom agreement is configured.
- [Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/): complete the actual questionnaire and reconcile any EULA minimum age.
