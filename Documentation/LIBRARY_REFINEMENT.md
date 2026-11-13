# Library and chapter orientation — 2026-11-11

- Character chapter outlines now show act and reading status from persisted journey progress: Start here, Up next, Choice saved, Ahead in your journey.
- Journeys searches saved moments by their character name as well as title, decision and recap.
- Search trims surrounding whitespace and has distinct no-result messaging.
- Library filter recovery clears search and reading status together.
- Statistics and library controls stack vertically at accessibility Dynamic Type sizes.
- No canonical content IDs, persistence schema, offline behavior or deployment target changed.

Verification:
- Package validator and mocked backend integration passed.
- 16 unit tests passed.
- Full first-journey UI flow passed: four choices, moments, Act II and relaunch persistence.
- Accessibility XXXL library UI test passed; all three statistics are reachable.
- Reviewed the captured accessibility-size library screenshot.
- Physical-device and VoiceOver testing remain outstanding.
