# Tideverse App Store preparation

Status: local draft package. Nothing has been uploaded or submitted.

## Included

- Six unmodified 1206 × 2622 RGB PNG captures from the actual simulator build: Discover, character profile, story reading, saved moment, Journeys and PDF preview.
- screenshots-manifest.json records source test/attachment, dimensions, color type and SHA-256 for each capture. Sources use synthetic authored story decisions, not private conversations.
- Metadata/en-US contains draft name, subtitle, promotional text, keywords and description. metadata-validation.json records checked field lengths.
- REVIEW_NOTES_DRAFT.md explains the real offline review route and explicitly records the unavailable production service.

Captures show version 1.0.0 (1), Debug simulator build, iPhone 18 Pro / iOS 27.0, normal text size. They have not been cropped, composited, resized or given promotional overlays. Recapture after visible UI or production configuration changes. The story-reading screenshot shows the chapter opening; it is not labeled as a screenshot of the choice controls.

## Current release evidence

The unsigned device Release build was attempted on 2026-11-11 and failed in Verify Release Metadata because verified publisher/support/privacy/legal/gateway values remain absent. The guard has not been bypassed. No distribution archive or signing verification exists. The project has no configured DEVELOPMENT_TEAM.

The offline normal-size journey, Act II transition, relaunch persistence, saved-moment search and PDF preview are covered by simulator UI tests. Real service/authentication/reporting, physical-device QA and final publisher information remain prerequisites.

## Official references checked 2026-11-11

- Screenshot specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
- App Review Guidelines (completeness and accurate metadata): https://developer.apple.com/app-store/review/guidelines/

The checked screenshot specification accepts 1206 × 2622 portrait captures for the medium Dynamic Island iPhone category and disallows alpha/transparency. Actual product screens should be used. Dimensions and file format are checked; App Store acceptance is not guaranteed.

Do not publish draft live-service wording until the deployed behavior matches it. Do not fabricate publisher identity, contact channels, URLs, privacy answers, age-rating responses or compliance declarations.

The app now bundles a required-reason privacy manifest for own-app UserDefaults (CA92.1). This does not finalize data-collection declarations or App Store privacy questionnaire answers for the eventual online service.

Act III expansion: listing chapter count is now 264. Existing screenshot set is marked historical/needs recapture because core biographies and chapter totals changed. Do not upload the old set as current screenshots.

Eight-character expansion: current totals are 40 characters and 328 chapters. Existing screenshots remain marked historical until recaptured.
