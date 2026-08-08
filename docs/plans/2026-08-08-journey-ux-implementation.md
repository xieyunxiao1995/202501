# Journey UX Improvements Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a recurring multi-page launch splash and finish the requested Solitaire Journey feedback, progression, Creative Mode, empty-state, and saved-game recovery surfaces.

**Architecture:** Keep the existing `HomeScreen`, `LevelScreen`, `CreativeDetailScreen`, `GameScreen`, `GameStorage`, and progress models as the sources of truth. Add one launch gate widget, expose the existing controller history length, upgrade the reusable win sheet, and add explicit saved-game load results so the game screen can distinguish “no save” from “corrupt save”.

**Tech Stack:** Flutter Material 3, Dart, `shared_preferences`, existing `FeltScaffold` / `GoldPanel`, Flutter widget tests.

---

### Task 1: Add the recurring three-page launch splash

**Files:**
- Create: `lib/features/launch/launch_splash_screen.dart`
- Modify: `lib/app/app.dart`
- Test: `test/features/launch/launch_splash_screen_test.dart`

**Steps:**

1. Write widget tests for the first splash page, page indicator/skip affordance, automatic page progression, and replacement with `HomeScreen` after the third page.
2. Run the focused test and confirm it fails because the launch widget and app home gate do not exist.
3. Implement a `SafeArea`-wrapped, mobile-first `PageView` with three static pages, a short gold shimmer/scale transition, `Skip`, and automatic progression on every app launch. Use `Navigator.pushReplacement` to the existing `HomeScreen` when complete.
4. Set `SolitaireApp.home` to `const LaunchSplashScreen()`; do not persist a “seen” flag because the splash must show every time.
5. Run the focused launch tests and confirm they pass.

### Task 2: Make victory feel like a settlement result

**Files:**
- Modify: `lib/features/solitaire/widgets/win_sheet.dart`
- Modify: `lib/features/solitaire/game_screen.dart`
- Modify: `lib/features/levels/level_catalog.dart` if next-level lookup needs a public helper
- Test: `test/features/solitaire/widgets/win_sheet_test.dart`
- Test: `test/features/solitaire/game_screen_test.dart`

**Steps:**

1. Add failing widget assertions for `Victory`, formatted `Time`, `Moves`, three-star display, `Replay`, `Next Level`, and `Home` actions.
2. Replace the single-result header with a reusable celebration header that animates a few card-shaped marks toward a foundation icon and pulses a gold shimmer; keep the content usable while the animation is running.
3. Keep the existing Creative-specific result details, but expose the same clear result metrics and action hierarchy. Add an `onReplay` callback and rename the home callback to represent the Home action.
4. Update `GameScreen` to close the sheet and start a new deal for Replay, return to the root for Home, and route to the next Journey level when there is a next level; fall back to the map/home behavior at the end of the catalog. Preserve Creative “Again” behavior through Replay semantics.
5. Run the focused win/game tests and adjust any changed action-label expectations.

### Task 3: Surface undo history

**Files:**
- Modify: `lib/features/solitaire/game_controller.dart`
- Modify: `lib/features/solitaire/game_screen.dart`
- Test: `test/features/solitaire/game_controller_test.dart`
- Test: `test/features/solitaire/game_screen_test.dart`

**Steps:**

1. Add a unit assertion that history count starts at zero and increments/decrements with successful move/undo operations.
2. Add a read-only `historyCount` getter backed by the existing `_history` list; do not change the 50-step cap.
3. Render `Undo` plus `Remaining: <count>` in the action tile and update it reactively after moves and undo.
4. Run the focused controller and game tests.

### Task 4: Finish Journey chapter and level detail presentation

**Files:**
- Modify: `lib/features/levels/level_screen.dart`
- Modify: `lib/features/levels/level_catalog.dart` only if target copy needs a helper
- Test: `test/features/levels/level_screen_test.dart`

**Steps:**

1. Extend the existing chapter header/path tests with chapter name, completed count, progress, lock state, and level detail target assertions.
2. Keep the existing chapter path and tabs, but add a stronger chapter identity/description block and make the level detail dialog show explicit goals: complete, move target, and time target, followed by Time/Moves/Stars records.
3. Preserve the existing level start callback and local `levelBestTimes` / `levelBestMoves` reads.
4. Run the focused level tests at both default and compact test sizes to catch dialog overflow.

### Task 5: Make Creative Mode briefing the single entry point

**Files:**
- Modify: `lib/features/creative/creative_screen.dart`
- Modify: `lib/features/creative/creative_detail_screen.dart` only for copy/layout polish
- Test: `test/features/creative/creative_screen_test.dart`

**Steps:**

1. Change every mode card Start action to open the existing `CreativeDetailScreen` first instead of bypassing its Rules/Goal/Difficulty content.
2. Keep the current five modes and local wins/time/moves/score/stars records; do not add economy or social systems.
3. Update the direct-start test to assert the briefing page appears before the game and that Start from the briefing records a play.
4. Run the focused Creative tests.

### Task 6: Add statistics empty state and saved-game recovery

**Files:**
- Modify: `lib/features/statistics/statistics_screen.dart`
- Modify: `lib/core/storage/game_storage.dart`
- Modify: `lib/features/home/home_screen.dart`
- Modify: `lib/features/solitaire/game_screen.dart`
- Test: `test/features/statistics/statistics_screen_test.dart`
- Test: `test/core/storage/game_storage_test.dart`
- Test: `test/features/home/home_screen_test.dart`
- Test: `test/features/solitaire/game_screen_test.dart`

**Steps:**

1. Add tests for `Your journey begins here.` when all classic and Creative counters are zero, and for a malformed active save producing `Saved game unavailable` / `Start a new adventure?` instead of silently starting over.
2. Add a `SavedGameLoadResult` to `GameStorage` with `state` and `failed` fields. Keep `loadGame()` nullable for existing callers, but stop hiding the failure from callers that need recovery UI; clear the bad save only after the player confirms starting over.
3. Let Home detect a failed active save and route into the unseeded game screen so the recovery dialog is reachable.
4. Add the statistics empty panel while keeping the existing classic and Creative records visible for non-empty profiles.
5. Run the focused storage/home/statistics/game tests.

### Task 7: Full verification

**Files:**
- No new files; inspect all changed Dart files and tests.

**Steps:**

1. Run `dart format lib test`.
2. Run `flutter analyze` and fix every analyzer error/warning introduced by this work.
3. Run `flutter test` and review the complete result.
4. Run `flutter build apk --debug` if the Android toolchain is available; otherwise report the exact platform limitation.
5. Re-check the user requirements against the rendered labels and callbacks before reporting the result.
