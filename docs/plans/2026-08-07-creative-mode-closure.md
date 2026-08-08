# Creative Mode Closure Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Close the Creative Mode loop with persistent local progress, configurable Time Trial countdowns, Creative-specific results, and Statistics/Achievement visibility.

**Architecture:** Add an immutable `CreativeProgress` model behind a new `GameStorage` SharedPreferences key. Keep the existing Solitaire board as the only game engine; pass `CreativeModeType` plus an optional Time Trial limit into it, and let the game screen record Creative starts/wins without touching classic progress. Make Creative list/detail/statistics/achievement screens load snapshots of the same progress model.

**Tech Stack:** Flutter/Dart, Material widgets, `SharedPreferences`, existing Solitaire controllers, and `flutter_test`.

---

### Task 1: Add the Creative progress model and persistence

**Files:**
- Create: `lib/features/creative/creative_progress.dart`
- Modify: `lib/core/storage/game_storage.dart`
- Create: `test/features/creative/creative_progress_test.dart`
- Modify: `test/core/storage/game_storage_test.dart`

**Step 1: Write the failing tests**

Test that a new progress object starts empty, `recordPlay` increments the selected mode and updates `lastPlayed`, and `recordWin` increments wins while retaining the lower best time, higher treasure total/best treasure count, and higher best stars. Test JSON round-tripping and malformed storage fallback.

**Step 2: Run the focused tests to verify they fail**

Run: `flutter test test/features/creative/creative_progress_test.dart test/core/storage/game_storage_test.dart`

Expected: FAIL because `CreativeProgress` and Creative storage methods do not exist.

**Step 3: Implement the model and storage boundary**

Create immutable maps for `played`, `wins`, `bestTimes`, `bestTreasures`, and `bestStars`, plus `treasuresFoundTotal` and nullable `lastPlayed`. Provide `initial`, `recordPlay`, `recordWin`, `playedFor`, `winsFor`, `bestTimeFor`, `bestTreasuresFor`, and `bestStarsFor`. Serialize map keys with `CreativeModeType.name`, tolerate missing/old fields, and remove malformed Creative JSON before returning `initial`.

Add `saveCreativeProgress` and `loadCreativeProgress` to `GameStorage` using `solitaire.creative`. Keep the classic `_gameKey` and `_progressKey` behavior unchanged.

**Step 4: Run the focused tests to verify they pass**

Run: `flutter test test/features/creative/creative_progress_test.dart test/core/storage/game_storage_test.dart`

Expected: PASS.

---

### Task 2: Update mode definitions and Treasure Hunt/Time Trial configuration

**Files:**
- Modify: `lib/features/creative/creative_mode.dart`
- Modify: `lib/features/creative/creative_controller.dart`
- Modify: `test/features/creative/creative_mode_test.dart`
- Modify: `test/features/creative/creative_controller_test.dart`

**Step 1: Write the failing tests**

Test that Treasure Hunt reports five targets, the catalog hides Joker Rescue but still contains its enum definition, Shadow/Chain are visible and labeled Future Mode, and Time Trial exposes 30-second, 60-second, and Unlimited choices with the right nullable limit values.

**Step 2: Run the focused tests to verify they fail**

Run: `flutter test test/features/creative/creative_mode_test.dart test/features/creative/creative_controller_test.dart`

Expected: FAIL because the catalog still has six treasures, Coming Later/Joker visibility, and no Time Trial duration model.

**Step 3: Implement the minimal mode updates**

Add `TimeTrialLimit` and its labels/seconds, add `isVisible` to `CreativeModeDefinition`, rename the future section label to `Future Mode`, set Joker invisible, and make the UI catalog expose only visible definitions. Change the Treasure Hunt target count to five and update its goal/rules copy. Keep deferred mode enum values for future use.

**Step 4: Run the focused tests to verify they pass**

Run: `flutter test test/features/creative/creative_mode_test.dart test/features/creative/creative_controller_test.dart`

Expected: PASS.

---

### Task 3: Add Creative progress to the list/detail experience

**Files:**
- Modify: `lib/features/creative/creative_screen.dart`
- Modify: `lib/features/creative/creative_detail_screen.dart`
- Modify: `test/features/creative/creative_screen_test.dart`

**Step 1: Write the failing widget tests**

Test that Joker is not rendered, Shadow/Chain show Future Mode, a card renders its best time/wins when stored progress exists, and the Time Trial detail page presents all three duration choices. Test that starting a playable mode records a play before navigating to `SolitaireGameScreen`.

**Step 2: Run the focused widget tests to verify they fail**

Run: `flutter test test/features/creative/creative_screen_test.dart`

Expected: FAIL because the screens are currently stateless, show Joker/Coming Later, and do not load or save Creative progress.

**Step 3: Implement the screen state and start flow**

Convert the screens to small StatefulWidgets that load `CreativeProgress` through `GameStorage`, pass snapshots into cards, and refresh after returning from detail. Render best time, wins, and a play-again/first-play affordance. Add a Time Trial selector with 30 seconds, 1 minute, and Unlimited. On Start, call `recordPlay`, save, then push the seeded game with `timeTrialLimitSeconds`.

**Step 4: Run the focused widget tests to verify they pass**

Run: `flutter test test/features/creative/creative_screen_test.dart`

Expected: PASS.

---

### Task 4: Integrate Time Trial countdowns and Creative result recording

**Files:**
- Modify: `lib/features/solitaire/game_screen.dart`
- Modify: `lib/features/solitaire/widgets/win_sheet.dart`
- Create: `test/features/solitaire/widgets/win_sheet_test.dart`
- Modify: `test/features/solitaire/game_screen_test.dart`

**Step 1: Write the failing tests**

Test that a 30-second Creative game renders `00:30`, reaches a Time Up state after the countdown, blocks board actions, and offers retry/back. Test that a Creative win sheet shows the mode title, Treasure progress, New Best feedback, and Again/Back actions while classic copy remains unchanged.

**Step 2: Run the focused tests to verify they fail**

Run: `flutter test test/features/solitaire/game_screen_test.dart test/features/solitaire/widgets/win_sheet_test.dart`

Expected: FAIL because `SolitaireGameScreen` has no time-limit parameter and `WinSheet` has no Creative result fields.

**Step 3: Implement the board and result integration**

Add optional `timeTrialLimitSeconds` and a local expired flag. Display remaining time for countdown modes, stop ticking/moves at zero, and show a text-only Time Up retry/back dialog. Keep Unlimited pace messages. On Creative win, load/update/save `CreativeProgress`, compute New Best, and pass mode-specific result data to `WinSheet`. Record a new Creative play when choosing Again. Preserve classic save/statistics behavior and the no-vibration constraint.

**Step 4: Run the focused tests to verify they pass**

Run: `flutter test test/features/solitaire/game_screen_test.dart test/features/solitaire/widgets/win_sheet_test.dart`

Expected: PASS.

---

### Task 5: Surface Creative progress in Statistics and Achievements

**Files:**
- Modify: `lib/features/statistics/statistics_screen.dart`
- Modify: `lib/features/achievement/achievement_screen.dart`
- Create: `test/features/statistics/statistics_screen_test.dart`
- Create: `test/features/achievement/achievement_screen_test.dart`

**Step 1: Write the failing widget tests**

Test that Statistics renders a Creative Journey section with per-mode wins/best times and that Achievements renders Treasure Hunter and Speed Runner based on stored CreativeProgress. Keep existing classic statistic and achievement rows present.

**Step 2: Run the focused widget tests to verify they fail**

Run: `flutter test test/features/statistics/statistics_screen_test.dart test/features/achievement/achievement_screen_test.dart`

Expected: FAIL because these screens only load classic `PlayerProgress`.

**Step 3: Implement shared progress loading and presentation**

Load CreativeProgress alongside PlayerProgress. Add a compact Creative Journey panel to Statistics. Add Creative achievements: Treasure Hunter at 50 cumulative treasures, Speed Runner for a Time Trial best at or under 120 seconds, and a locked Memory Master placeholder until Shadow Solitaire is playable. Do not show Joker as a current achievement target.

**Step 4: Run the focused widget tests to verify they pass**

Run: `flutter test test/features/statistics/statistics_screen_test.dart test/features/achievement/achievement_screen_test.dart`

Expected: PASS.

---

### Task 6: Run complete verification

**Files:**
- Modify only files required by formatter, analyzer, or regression output.

**Step 1: Format the Dart sources**

Run: `dart format lib test`

Expected: Formatting completes without errors.

**Step 2: Run static analysis**

Run: `flutter analyze`

Expected: `No issues found!`.

**Step 3: Run the complete test suite**

Run: `flutter test`

Expected: All existing and new tests pass.

**Step 4: Review the workspace**

Run: `git diff --check` only if a Git worktree exists. This workspace has no `.git` directory, so do not commit, merge, push, or delete files.
