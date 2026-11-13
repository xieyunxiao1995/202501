## Current AI connection — 2026-11-12

The iOS app now connects directly to DeepSeek Chat Completions using `deepseek-flash`, enabled thinking, high reasoning effort and non-streaming final replies. It supports explicitly selected images and preserves canonical story-choice validation. DeepSeek-specific data consent (`deepseek-data-v2`) is required; earlier provider permission does not authorize requests.

At the owner's explicit request, `DeepSeekConfiguration.swift` contains a credential encoded as three Base64 fragments. This is obfuscation, not encryption or secure secret storage; the credential remains recoverable from the distributed app. Do not print the fragments, authorization header or reconstructed key in logs or test attachments. Public distribution should account for credential extraction, unauthorized usage and spend exposure.

The old Ark Worker under Backend is retained as a legacy scaffold and is no longer used by the iOS app. Earlier gateway configuration instructions below describe that legacy integration. `TIDEVERSE_GATEWAY_URL` is no longer required for the current direct DeepSeek build. The Release check still requires real publisher/support/policy details and legal review. See `Documentation/DEEPSEEK_INTEGRATION.md`.

# Tideverse - AI Character Journeys

A native **SwiftUI + SwiftData** iPhone application and extendable source package. 32 original characters with in-character greetings, 256 authored chapters, 512 decision outcomes, branch-aware callback lines, independently saved Story Moments, a user-controlled Memory Ledger, image attachment, optional Vision OCR, PDF preview/export and JSON backup/import are included. All app UI copy is in English, with an always-on **dark navy and electric-blue theme**, an entirely **adult cartoon cast** (ages 29–48), and exactly four tabs: Discover, Chats, Journeys, Settings.

**Open `Tideverse.xcodeproj` in Xcode 16+** and select the `Tideverse` scheme. The initial story experience runs offline without an API key or server. Online conversational replies require a configured HTTPS gateway (`Backend/`). The project has no CocoaPods, external Swift Package dependencies or embedded Ark credentials.

## First run

1. Unzip this archive on a Mac running current Xcode. Open `Tideverse.xcodeproj` (not just the source folder).
2. Choose the `Tideverse` scheme and an iOS 17+ iPhone simulator. Use Product > Run. Xcode will require an Apple development team for an actual iPhone.
3. Select **Begin Exploring**. Open any character from Discover or any journey from Journeys. Every chapter presents two authored choices; completed choices advance a chapter and save a Story Moment.
4. In Chats, talk to a character in your own words. A free-form message that clearly commits to an authored direction surfaces a suggestion card; recording it advances the journey through the same canonical story engine. Ambiguous messages simply continue the conversation, and the full choice list stays available in the story thread. Without a gateway, the app replies with bundled authored prose and clearly says no AI request is sent.
5. To enable live AI, deploy the optional Cloudflare Worker described in `Backend/README.md`, rotate the supplied/exposed Ark key, and set `TIDEVERSE_GATEWAY_URL` in `Tideverse/Resources/Info.plist` to your real HTTPS origin (no trailing `/v1/chat`). Rebuild.
6. Start a conversation, review the AI data-transfer notice and opt in. Photos are user-selected, resized and re-encoded without EXIF. Only pinned memories for the selected character enter the model request.

## Contents

- `Tideverse.xcodeproj` - actual native Xcode application and unit-test targets
- `Tideverse/App` - App entry and four-tab root navigation
- `Tideverse/Design` - color palette, portrait display, common components
- `Tideverse/Models` - bundled content models and local SwiftData records
- `Tideverse/Data` - authored story/character JSON loading
- `Tideverse/Features/Discover` - search, character cards and detailed profiles
- `Tideverse/Features/Chats` - story-driven conversation, chapter ribbon and beat sheet, decision suggestion card, text/photo composer, AI data consent, memory editor
- `Tideverse/Features/Journeys` - authored choices, chapter state, Story Moments
- `Tideverse/Features/Settings` - about, terms, privacy, help, feedback, developer information, data management
- `Tideverse/Services` - gateway client, image preparation, local OCR, PDF, backup, story progression
- `Tideverse/Resources/Assets.xcassets` - 32 adult anime portrait PNGs, 32 matching avatar PNGs, 32 story scene artworks, app icon
- `Tideverse/Resources/Stories` - characters.json and stories.json for extension
- `Documentation/STORY_BIBLE.md` - character and story bibles; the cast expansion is in `Documentation/CAST_EXPANSION_20.md` and its second acts in `Documentation/ACT_II_EXPANSION_20.md`
- `Documentation/DARK_CARTOON_DESIGN.md` - age policy, design tokens, and exact imageset inventory
- `Documentation/CHARACTER_PREVIEW.jpg` - overview of all 32 adult anime characters
- `Backend` - optional secure-key Volcengine Ark gateway scaffold with trusted story-choice canon and regeneration script
- `Tests` - content, progress and asset unit tests
- `Tools/verify_package.py` - portable JSON, asset and Xcode-reference checker
- `AGENTS.md` - rules for future Codex changes

## Fast source validation

On macOS or Linux, run `python3 Tools/verify_package.py` and `node Backend/self_test.mjs`. These validate the 32-character story content, references and a mocked, non-billable gateway exchange. On macOS, follow with Xcode **Product > Build** and **Product > Test**.

## Launch and safety realities

- This is an Xcode **source** project, not an `.ipa` or signed App Store release. It requires Xcode and a signing team to build on macOS.
- The app has compiled successfully for generic iOS with Xcode 27.0 on macOS, without signing. Unit tests and an end-to-end XCUITest journey run on the iPhone 18 Pro simulator; live-provider validation, physical-device testing and accessibility auditing remain required before distribution.
- The bundled 2D character art is derived from newly generated original visual concepts. It is presented as in-app character art, not as downloaded photographs of real people. Inspect individual assets and arrange any applicable commercial-use rights review before public release.
- Developer legal identity, company name, privacy policy URL and reachable support email have not been supplied. The in-app pages **truthfully disclose** that the final publisher must fill and verify these. Do not fabricate them.
- 4.3/App Store approval cannot be guaranteed. Actual differences are the authored chapter decisions, persistent user-controllable memory and exportable moments, rather than a reskinned generic chatbot.
- For production, the gateway requires server-side device attestation, abuse controls, expenditure caps, moderation/reporting escalation, policies and verified publisher identity. The included Worker is a functional integration scaffold, **not a production security certification**.

## Extend the product

To add a new character, create portrait/avatar/scene image sets, append a unique record to `characters.json`, add a matching `stories.json` journey with stable IDs, and mirror canonical role metadata to `Backend/characters.js`. Add choices and branches only as authored chapter outcomes, and migrate existing IDs with care. See `Documentation/EXTENSION_GUIDE.md`.

## Verified documentation

- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Volcengine Ark model list](https://docs.volcengine.com/docs/ark/model-list?lang=zh)
- [Volcengine Ark Responses API](https://docs.volcengine.com/docs/ark/create-model-responses-api?lang=zh)
- [Cloudflare Workers rate limit binding](https://developers.cloudflare.com/workers/runtime-apis/bindings/rate-limit/)

## Current experience and release configuration

Discover includes continue-journey recommendations, search, genre filters and saved-character filtering. Profiles include chapter previews, bookmarks, a memory ledger shortcut and hide/restore controls. Chats separates recent conversations from new characters. Journeys includes status filters, search and a saved-moment library. Saved chapter outcomes open as readable, exportable moments.

Chat is the story's main control surface. Each conversation shows a chapter ribbon and a story beat sheet with the authored setting, objective and full choice list. Typing a direction in ordinary language can surface a suggestion card; confirming it records that canonical choice, writes a Story Beat into the conversation and advances the journey. Ambiguous messages never force a choice, and the AI gateway may only nominate an ID from the current chapter — chapter progress is still written exclusively by the story engine. Tapping outside the composer, scrolling the thread or using the keyboard Done button dismisses the keyboard.

Each journey now runs eight chapters: the four-chapter Act I and an Act II that follows the consequences of the player's earlier decisions. Act II chapters open with a "The story remembers" line chosen from the player's own history, and a completed four-chapter journey is automatically reopened for the new chapters on next launch. Chapter rows show `Act 1`/`Act 2`, the journey screen lists every prior decision as a path, and the completed card names the ending.

Unsent text drafts are kept in protected local files and cleared when deleting conversations or all local data. Failed sends retain the composer. Revoking consent cancels the active request; a deleted conversation cannot be recreated by a late reply. Storage-open failure offers recovery without replacing the database.

Configure the real publisher name, support email, public privacy/support URLs, legal effective date and private gateway origin in `Tideverse/Resources/Info.plist`. Set `TIDEVERSE_PUBLISHER_REVIEWED` only after the real publisher reviews the legal copy and operational data practices. **Release builds run `Tools/verify_release.py` and fail while required metadata is absent.** Debug remains available for development. `python3 Tools/verify_release.py --check-urls` additionally checks the policy/support URLs. Configuration checks do not establish legal compliance or guarantee review acceptance.

AI reply reporting opens a reviewable report for the selected reply, with explicit email/share actions. It does not silently upload conversations or claim delivery. A real support inbox and moderation workflow are still required.

### Record controls and backup refinements

An unanswered user message can request a reply again without inserting a duplicate turn. Chat actions support individual message deletion, single-conversation deletion and explicit memory capture. Story Moments can be deleted independently of chapter progress, or used as a proposed memory that the user reviews before saving. Photo preparation blocks sending until complete and discards stale selection/OCR work. JSON export can omit photos and refuses to create an archive larger than the supported 35 MB restore limit. Imported chapter prose and scene names are reconstructed from canonical IDs.

AI processing consent is versioned. Older Boolean-only permission or an outdated notice version requires a fresh review before any new AI request. The most recent acceptance and revocation dates appear in Settings; Delete All Local Data clears the consent record.

## Twenty new characters, extended into two acts

The cast expansion added 20 adult characters and 20 complete four-chapter journeys. A second-act pass then extended all twenty to eight chapters, with time-skip complications, institutional pressure, personal cost and two branch-aware callbacks per chapter. The twelve original journeys keep their own Act II. Existing character records, story records and IDs were preserved unchanged. See `Documentation/CAST_EXPANSION_20.md`, `Documentation/ACT_II_EXPANSION_20.md` and `Artwork/Expansion20/Preview.jpg`. The full catalog contains 32 characters, 256 chapters and 512 choices.

## First launch and account-free entry

New installations now open with three illustrated introduction pages, followed by an account-free welcome page. Entry requires reviewing the EULA to its final button and explicitly agreeing; the app stores the accepted version and date. The page explains fictional AI characters, AI limitations and optional third-party processing. Agreeing never enables online AI data transfers; those retain separate consent. See `Documentation/FIRST_LAUNCH_AND_EULA.md` for behavior and isolated first-install verification.
