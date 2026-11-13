# Goal audit — 2026-10-28

Objective: verify that the current app works and feels friendly, then add more content and deeper stories.

## Current evidence

| Requirement | Evidence and result |
|---|---|
| The app builds and runs | `xcodebuild test` on the iPhone 18 Pro simulator (Xcode 27) succeeds: the app builds, installs, launches and completes the tested journeys. |
| Core offline journey works | XCUITest drives onboarding, character profile, four chapter choices, Story Moment save/dismiss, Act II chapter 5, Journeys statistics and relaunch persistence. 12 unit tests cover progression, canonical outcomes, archive export/import, import validation, consent and assets. |
| Friendly first-run and reading experience | A real bug that horizontally clipped ScrollView text (`scaledToFill` without width constraint) was found in runtime screenshots and fixed in Welcome, Story detail and Story Moment. The primary onboarding CTA is pinned and always visible. |
| Journey clarity | Character cards and profiles show chapter progress; the profile CTA is pinned above the tab bar and names the next chapter. The chapter screen shows act, chapter number, setting, a branch-aware callback, the progress bar, previous outcome, decision history and the ending card. Advancing a chapter scrolls the new chapter into view. |
| Statistics and moments | Journeys shows in-progress, completed and moment counts; the UI test confirms 1 in progress and 4 moments after Act I. Each choice saves a readable Story Moment with act/chapter context. |
| More authored content | The original twelve journeys grew from four to eight chapters, and a cast expansion added twenty characters with four-chapter journeys; a second Act II pass then extended all twenty to eight chapters. The catalog now holds 32 characters, 256 chapters and 512 choices, all canonical JSON with stable IDs. The backend canon was regenerated from the bundled content. |
| Deeper stories | Act II follows the consequences of Act I for all thirty-two characters. Every Act II chapter carries two `echoes` from the player's actual earlier decisions; the chapter screen renders the matching line as "The story remembers". The final chapter of each arc asks what the discovery becomes, not just what happens next. Intros stay compatible with either branch; branch-specific consequences live in the outcomes and callbacks. |
| Existing players are not stranded | `StoryEngine.reopenIfExtended` reopens a journey completed under the old four-chapter content and is applied at launch. A unit test simulates a legacy completion and continues into chapter 5. |

## Verification commands

- `python3 Tools/verify_package.py` — passes (32 characters, 256 chapters, 512 choices, 96 character images).
- `node Backend/self_test.mjs` — passes (mocked gateway, Act II canon present).
- `xcodebuild test … -destination 'platform=iOS Simulator,id=A2ECCCDB-F1D7-459E-B942-1037F9FB44F3'` — passes 12 unit tests and the UI test.

## Not claimed

App Store readiness is not claimed. Real publisher/support/policy metadata, a deployed and authenticated gateway, physical-device testing, VoiceOver/Dynamic Type runtime review, signing and submission evidence remain outstanding. `VALIDATION_REPORT.md` records the detailed evidence and gaps.
