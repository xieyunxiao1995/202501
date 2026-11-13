# Tideverse Codex Agent Instructions

Build one original native Swift iOS app. Do not replace it with a WebView, Flutter, React Native, or a collection of design mockups. Keep the actual project in `Tideverse.xcodeproj`. The source project includes eight real original characters, 32 playable authored chapters, images, and a functional offline persistence path.

## Permanent product invariants

1. English iPhone portrait interface; blue design system and usable dark mode.
2. Exactly four tabs: Discover, Chats, Journeys, Settings.
3. Native Swift/SwiftUI/SwiftData, small MVVM + Service, URLSession only when needed.
4. Story choices and memory are written to SwiftData; AI chat cannot alter canonical chapter state outside the StoryEngine.
5. Every character is labeled fictional AI; do not impersonate humans or claim consciousness.
6. AI requests require clear third-party data-transfer consent. An optional photo must be explicitly selected by the user. No automatic photo library upload.
7. Never place an Ark API key in source, config, git or app binary. Use the server gateway, rotate compromised credentials, apply rate limits and authentication before production.
8. User controls pinned memories, deletes records, imports/exports JSON, previews/exports Story Moments to PDF.
9. All Settings legal/help/support pages live in separate Swift files. Use verified publisher details; do not invent a company, support address, domain or fake review rating.
10. Treat `Resources/Stories/characters.json` and `stories.json` as canonical authored content; regenerate `Backend/characters.js` and `Backend/storyCanon.js` with `python3 Backend/sync_content.py` after content edits. Do not replace it with model-generated random lore or empty placeholders.
11. No ads, manipulative retention loops, real-person mimicry, public UGC directory, or misleading in-character 'online' status in the first release.
12. Do not overclaim Apple 4.3 compliance. Show meaningfully distinct and fully functioning story mechanics.

## Development sequencing

- First run `python3 Tools/verify_package.py` and `node Backend/self_test.mjs`; validate Xcode target membership, Info.plist, asset catalog, iOS 17 deployment and SwiftData schema.
- Build and run the offline story loop: Discover > Character > Chapter > Choice > Moment > Journeys > app relaunch.
- Test chat offline state, network/consent gating, photo preparation, OCR, memory pinning, JSON import/export, PDF preview and export.
- For online chat, deploy and secure the Worker. Test the active Ark model from the actual account, 2xx/4xx/5xx behavior, cancellation, network outage, and image understanding.
- Preserve original story identities and chapter IDs across updates; add migrations instead of resetting user data.
- Before publishing, replace development-only legal identity wording with the real publisher's reviewed terms, policy, support address, and working reporting channel.

## Acceptance criteria

- Eight distinct portrait/scene/avatar assets and eight original personalities are visible in app.
- 32 chapters have authored intros and two meaningful options each; 64 outcomes are locally persisted.
- The last choice in a journey completes it; relaunch does not reset progress.
- No chat data crosses the network without permission; denied consent leaves stories accessible.
- Setting a gateway URL does not require placing Volcengine provider secrets in the app.
- All four tabs and all separate Settings pages navigate without dead-end links.
- JSON backup round-trips through FileImporter/FileExporter; PDF preview and export use PDFKit/CoreGraphics.
- Archive deleting clears photo attachments, chats, moments, progress and memories.
- macOS Xcode Build/Tests + Accessibility/VoiceOver + Dark Mode + iPhone QA are required before any release claim.

## Midnight Blue adult cartoon release constraints (2026-10-28)

- Keep the UI **dark** on all screens, even when the device is in light mode. Do not reintroduce white cards or light themes. `UIUserInterfaceStyle` must remain `Dark`.
- The 8 bundled illustrated characters are **all adults age >= 25**. Story JSON and gateway persona metadata must keep this explicit. No minors, sexual content, nudity or sexualized costumes.
- Every character must keep a distinct `{id}_portrait`, `{id}_avatar`, `{id}_scene` imageset inside the actual Xcode asset catalog. New characters require new imagesets and Xcode image resolution tests. Do not replace these with remote URLs or screenshots of marketing boards.
- All artwork should remain recognizable and match between Discover cards, character detail, chat and story pages.
- If changing character ages or story IDs, synchronize trusted server content with `python3 Backend/sync_content.py`.
- Re-run `python3 Tools/verify_package.py`, Swift syntax parse, and Xcode Product > Build/Product > Test. No Mac build was available at packaging time.
- See `Documentation/DARK_CARTOON_DESIGN.md` for the new UI and art guidance.

## DeepSeek integration override (2026-11-12)

The user explicitly requested direct DeepSeek Chat Completions with deepseek-flash and an embedded credential encoded as three Base64 fragments. This authorized exception is implemented in DeepSeekConfiguration.swift; do not output, log or reproduce the credential in reports. Base64 is obfuscation, not secure storage. The app now connects directly to DeepSeek, while Backend/ remains a legacy optional Ark scaffold. Provider-specific consent is deepseek-data-v2; earlier Ark permission must not authorize DeepSeek. Keep canonical story validation and explicit AI data consent. No actual support or legal identity details have been supplied.
