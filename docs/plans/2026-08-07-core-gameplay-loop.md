# Core Gameplay Loop Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Close the first-round gameplay loop for Solitaire Journey by making undo and hint feedback reliable, keeping pause usable, removing the misleading coin economy, and detecting unwinnable/no-move states.

**Architecture:** Keep the current local `setState` screen state and controller-based solitaire rules. Put rule decisions such as the 50-step history limit and legal-move detection in `SolitaireGameController`; keep transient highlight/dialog state in `SolitaireGameScreen`. Remove coin/reward mutation from `PlayerProgress` while leaving the progress JSON reader tolerant of older saved data.

**Tech Stack:** Flutter, Dart 3.11, `flutter_test`, `shared_preferences`.

---

### Task 1: Lock down the controller and progress behavior with failing tests

**Files:**
- Modify: `test/features/solitaire/game_controller_test.dart`
- Modify: `test/features/home/home_controller_test.dart`

**Step 1: Write failing tests**

- Assert that only the most recent 50 successful actions can be undone.
- Assert that a foundation-to-tableau move is returned as a hint when it is the only legal move.
- Assert that a state with empty stock/waste and no legal tableau/foundation move reports no available move.
- Assert that recording a win changes stars/statistics but exposes no coin balance or reward mutation.

**Step 2: Run the focused tests**

Run: `flutter test test/features/solitaire/game_controller_test.dart test/features/home/home_controller_test.dart`

Expected: FAIL because the new controller API and coin-free progress behavior do not exist yet.

### Task 2: Implement the minimal controller and progress changes

**Files:**
- Modify: `lib/features/solitaire/game_controller.dart`
- Modify: `lib/features/home/home_controller.dart`
- Modify: `lib/features/solitaire/widgets/win_sheet.dart`

**Step 1: Implement the 50-step history cap**

Add a `canUndo` getter and trim the oldest history entry before adding the 51st state.

**Step 2: Implement legal-move detection**

Extend hint search to include foundation-to-tableau moves and expose `hasAvailableMove` as the single source of truth for dead-end detection.

**Step 3: Remove economy mutations**

Remove `coins`, `reward`, and reward display/mutation from progress and win presentation. Keep `fromJson` compatible with old saved data by ignoring legacy coin fields.

**Step 4: Re-run the focused tests**

Run: `flutter test test/features/solitaire/game_controller_test.dart test/features/home/home_controller_test.dart`

Expected: PASS.

### Task 3: Connect gameplay feedback in the game screen

**Files:**
- Modify: `lib/features/solitaire/game_screen.dart`

**Step 1: Add transient hint feedback**

Highlight both the source and destination for two seconds, clear the timer when the game changes/disposes, and show a concise snackbar when no hint exists.

**Step 2: Add undo state feedback**

Disable the Undo action when history is empty and avoid persisting when no undo occurred.

**Step 3: Add no-more-moves feedback**

After a successful action, show a modal dialog when the controller reports no available moves and the game is not complete. Offer Undo, Restart, or Close.

**Step 4: Preserve pause behavior**

Persist before opening the pause dialog and keep the existing Resume/Restart/Exit flow with explicit paused copy.

### Task 4: Remove misleading economy UI and inert global actions

**Files:**
- Modify: `lib/features/home/home_screen.dart`
- Modify: `lib/features/daily_challenge/daily_challenge_screen.dart`
- Modify: `lib/features/statistics/statistics_screen.dart`
- Modify: `lib/features/themes/theme_screen.dart`
- Modify: `lib/core/widgets/bottom_nav.dart`

Remove coin counters, add buttons, coin rewards, and the inert Hint/Undo home-navigation items. Keep game-only Hint/Undo in the actual game action bar and leave Levels/Themes/Settings as real navigation destinations.

### Task 5: Verify the complete change

**Files:**
- Check: all modified Dart files and tests

**Step 1: Format**

Run: `dart format lib test`

**Step 2: Analyze**

Run: `flutter analyze`

Expected: no errors or warnings introduced.

**Step 3: Run the full test suite**

Run: `flutter test`

Expected: all tests pass.

