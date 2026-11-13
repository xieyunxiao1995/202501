# UI and character-conversation refinement — 2026-11-12

The existing English, Midnight Blue native iPhone interface and four root tabs remain. Character/story IDs, SwiftData records, artwork and saved progression were not reset or replaced.

## Changes

- Discover: smaller featured journey, more compact character artwork and a shared row for reading-status and saved filters. The character grid appears earlier without removing search, genre or progress filtering.
- Character detail: a shorter portrait, an expandable biography, and persistent Chat / Journey actions. Chat uses the selected character's exact definition rather than a generic assistant. The full biography and chapter previews remain accessible.
- Chat: compact identity/chapter header, an immersive view with the root tab bar hidden until returning, clearer reply spacing and errors, and a composer addressed to the character. While generating, the send control becomes Stop reply. Empty conversations offer editable starters; choosing one never sends automatically or forces the keyboard open.
- Consent: a compact provider notice with pinned agree/decline controls. A typed `ChatConsentAction` sheet item preserves the actual pending send or retry. This fixes the observed stale-Boolean case where a starter-triggered sheet could display Enable AI instead of Send Message. Declining keeps the draft and sends nothing.
- Journeys: a native Journeys / Moments selector makes saved moments accessible without scrolling through all forty journeys. A nonempty search continues to include both story and moment results.
- Reading: fixed-height scene overlays keep image intrinsic dimensions from widening story or moment prose.
- Shared controls: a 54-point minimum primary button with consistent rounding, disabled feedback and a Reduce Motion-aware pressed state. Settings, data, developer and feedback forms use the dark-blue row surfaces; Settings rows have a comfortable 52-point minimum height.

## AI coverage

All forty roles use the same DeepSeek Chat Completions adapter. The selected character supplies name, adult age, profession, biography, voice, goal and boundaries; per-character history and pinned notes are assembled separately. Canonical story choices and the active chapter are validated before transmission. Generated suggestions never change progression without the user's explicit story-engine action. Provider consent remains independent of the EULA.

The new unit coverage builds requests for every character at both the first chapter and completed journey (80 role/context combinations) and checks the actual DeepSeek endpoint/model and role-specific instructions. These are non-network tests, not forty paid provider calls.

## Verification

- Package validation: 40 characters, 328 chapters, 656 choices and 120 character assets.
- All 32 unit tests passed on the iPhone 18 Pro simulator, including the eighty role/context combinations and prior-provider consent rejection.
- New UI walkthrough passed (53.8 seconds): Discover, Chats, Journeys/Moments, Settings, visible profile actions, editable Vera starter, no automatic permission/send, and compact explicit consent with draft preservation after declining.
- Fresh-install three-page introduction, one-tap EULA entry, persistence and separate AI permission passed (24.6 seconds).
- Rendered screenshots were reviewed in normal text size and are saved in `Documentation/UIRefinement/`.

The final live-provider UI run passed for both Mira and Vera (58.6 seconds), including explicit consent, draft preservation on decline, a persisted Mira reply after relaunch, and a new Vera reply reached through her starter. An earlier Vera attempt encountered a transient TLS failure; the final rerun succeeded. Certificate validation was not weakened. Network errors now explain recovery in plain language, retain the saved message and expose the existing explicit retry action. The opt-in live test permits one explicit UI retry after a transport failure; ordinary unit/UI runs do not authorize paid AI calls.

The existing chapter-choice/progress/relaunch/PDF regression passed (72.7 seconds), and all six Settings information destinations with help search and feedback draft controls passed (38.2 seconds).

Final unit and live bundle: `/Volumes/MAC2/TideverseBuild/UIRefinement/Logs/Test/Test-Tideverse-2026.11.12_11-23-57-+0800.xcresult`. Interface walkthrough bundle: `Test-Tideverse-2026.11.12_11-13-18-+0800.xcresult` under the same directory. Maximum-font-size testing remains outside this pass as requested. These checks establish the exercised simulator paths, not App Store approval or a physical-device certification.
