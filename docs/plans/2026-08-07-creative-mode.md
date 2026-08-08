# Creative Mode Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a data-driven Creative Mode experience with detail pages and three playable Solitaire variants: Treasure Hunt, Time Trial, and One-Draw Sprint.

**Architecture:** Keep `SolitaireGameScreen` as the only board UI and inject an optional `CreativeModeType`. A small `CreativeGameController` owns mode-specific state such as Treasure Hunt targets and checks whether the selected variant permits stock recycling. Classic games keep their current save, statistics, hint, undo, pause, and win paths; Creative sessions use seeded deals but do not overwrite classic active-game storage or classic progress in Phase 1.

**Tech Stack:** Flutter/Dart, Material widgets, existing `SolitaireGameController`, `SharedPreferences` storage boundary, and `flutter_test`.

---

### Task 1: Add the Creative mode catalog

**Files:**
- Create: `lib/features/creative/creative_mode.dart`
- Create: `test/features/creative/creative_mode_test.dart`

**Step 1: Write the failing tests**

Cover these behaviors:

- The catalog contains all six existing mode IDs.
- Treasure Hunt, Time Trial, and One-Draw Sprint are playable.
- Shadow Solitaire, Chain Deck, and Joker Rescue are marked deferred.
- Every definition has a non-empty title, goal, rules, difficulty, and section.

**Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/creative/creative_mode_test.dart`

Expected: FAIL because the mode enum/catalog does not exist.

**Step 3: Implement the catalog**

Create `CreativeModeType` with `treasureHunt`, `timeTrial`, `jokerRescue`, `shadowSolitaire`, `chainDeck`, and `oneDrawSprint`. Create `CreativeModeDefinition` with stable ID, display metadata, `isPlayable`, and `section`. Expose a top-level immutable catalog and a lookup helper. Use the existing color and icon style from `creative_screen.dart`; do not add coin, reward, push, social, or vibration fields.

**Step 4: Run the focused test to verify it passes**

Run: `flutter test test/features/creative/creative_mode_test.dart`

Expected: PASS.

---

### Task 2: Add mode-specific game rules and Treasure Hunt tracking

**Files:**
- Create: `lib/features/creative/creative_controller.dart`
- Create: `test/features/creative/creative_controller_test.dart`

**Step 1: Write the failing tests**

Cover these behaviors:

- A seeded Treasure Hunt session chooses six distinct cards from the initially hidden stock.
- The same initial state produces the same target set.
- A target is counted only after it is face up in waste, tableau, or foundation.
- A non-Treasure mode reports no treasure progress.
- One-Draw Sprint reports that recycling is unavailable.

Use small hand-built `SolitaireGameState` values in tests so the tests do not depend on a particular random deal.

**Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/creative/creative_controller_test.dart`

Expected: FAIL because `CreativeGameController` does not exist.

**Step 3: Implement the controller**

Add a `CreativeGameController` constructed from a mode and the initial Solitaire state. For Treasure Hunt, choose the first six cards from the initial stock as stable suit/rank target keys. Expose `treasuresFound`, `totalTreasures`, `treasureKeys`, and `isStockRecycleAllowed`. Count targets by scanning only face-up cards in the current waste, tableau, and foundation. Keep this controller pure Dart and do not persist it in Phase 1.

**Step 4: Run the focused test to verify it passes**

Run: `flutter test test/features/creative/creative_controller_test.dart`

Expected: PASS.

---

### Task 3: Make the stock rule injectable into Solitaire

**Files:**
- Modify: `lib/features/solitaire/models/game_state.dart`
- Modify: `lib/features/solitaire/game_controller.dart`
- Modify: `test/features/solitaire/game_controller_test.dart`

**Step 1: Write the failing tests**

Add tests for:

- Normal Solitaire still recycles the waste indefinitely.
- One-Draw Sprint can draw each stock card once.
- One-Draw Sprint rejects a recycle attempt after stock is exhausted.
- A rejected recycle attempt does not create an undo entry.
- `findHint()` does not suggest drawing from an exhausted, non-recyclable stock.

**Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/solitaire/game_controller_test.dart`

Expected: FAIL because the game controller has no stock-recycle policy.

**Step 3: Implement the minimal rule hook**

Add an optional stock recycle limit to `SolitaireGameController`; `null` means the existing unlimited behavior and `0` means no recycle. Track the number of completed stock recycles in `SolitaireGameState`, include it in `copyWith`, JSON serialization, deserialization with a backward-compatible default of zero, equality, and undo snapshots. Add a `canDrawFromStock` getter. Make `drawFromStock()` reject recycling when the limit is reached, and make `findHint()` use `canDrawFromStock` before returning the stock hint. Preserve existing normal-game behavior and old saved-state compatibility.

**Step 4: Run the focused tests to verify they pass**

Run: `flutter test test/features/solitaire/game_controller_test.dart test/core/storage/game_storage_test.dart`

Expected: PASS.

---

### Task 4: Redesign the Creative landing page and add the detail page

**Files:**
- Create: `lib/features/creative/creative_detail_screen.dart`
- Modify: `lib/features/creative/creative_screen.dart`
- Create: `test/features/creative/creative_screen_test.dart`

**Step 1: Write the failing widget tests**

Cover these behaviors:

- The page shows `Creative Modes` and no `Latest` or `Popular` tabs.
- Playable cards show their difficulty and a `Play` action.
- Deferred cards show `Coming Later`.
- Tapping Treasure Hunt opens a detail page containing its goal and rules.
- Tapping a deferred mode opens its detail page without launching a game.

**Step 2: Run the focused widget test to verify it fails**

Run: `flutter test test/features/creative/creative_screen_test.dart`

Expected: FAIL because the existing page uses static tuples, placeholder tabs, and direct/snackbar actions.

**Step 3: Implement the catalog-driven UI**

Replace the static tuple list and tabs with grouped catalog definitions. Build reusable mode cards showing icon, title, description, difficulty stars, and an action affordance. Add `CreativeDetailScreen` with a mode header, goal, rules, difficulty, and a primary button. The primary button launches a seeded `SolitaireGameScreen` for playable modes using the mode type; deferred modes show a disabled Coming Later control. Keep navigation local with `MaterialPageRoute` and match the existing felt/gold visual language.

**Step 4: Run the focused widget test to verify it passes**

Run: `flutter test test/features/creative/creative_screen_test.dart`

Expected: PASS.

---

### Task 5: Integrate Creative sessions into the Solitaire board

**Files:**
- Modify: `lib/features/solitaire/game_screen.dart`
- Create or extend: `test/features/solitaire/game_screen_test.dart`

**Step 1: Write the failing widget tests**

Cover these behaviors:

- A Creative game renders its mode title/tag.
- Treasure Hunt renders a found/total counter.
- A One-Draw Sprint game does not write an active classic save when paused or drawing.
- Trying to recycle in One-Draw Sprint shows the no-recycle feedback.
- A classic game still renders and retains its existing actions.

**Step 2: Run the focused widget tests to verify they fail**

Run: `flutter test test/features/solitaire/game_screen_test.dart`

Expected: FAIL because `SolitaireGameScreen` has no Creative mode parameter or mode-specific presentation.

**Step 3: Implement the integration**

Add an optional `creativeMode` to `SolitaireGameScreen`. Construct a Creative controller after the seeded game is created and recreate it on New Deal. Configure the underlying Solitaire controller with zero stock recycles for One-Draw Sprint. After successful draws or moves, update the Creative presentation and show a short text SnackBar when Treasure Hunt progress increases. Add Time Trial text-only pace feedback at 30 and 60 seconds without vibration. Guard classic persistence and classic `PlayerProgress.recordWin()` so Creative sessions do not mix with classic progress. Keep existing pause, undo, hint, no-more-moves, and win-sheet behavior.

**Step 4: Run the focused widget tests to verify they pass**

Run: `flutter test test/features/solitaire/game_screen_test.dart`

Expected: PASS.

---

### Task 6: Run the complete verification suite

**Files:**
- Modify only files required by failing verification or formatter output.

**Step 1: Format the changed Dart files**

Run: `dart format lib test`

Expected: Dart files are formatted with no errors.

**Step 2: Run static analysis**

Run: `flutter analyze`

Expected: `No issues found!`.

**Step 3: Run the complete test suite**

Run: `flutter test`

Expected: All tests pass, including existing Solitaire, storage, home, level, daily, settings, and new Creative tests.

**Step 4: Review the final diff**

Run: `git diff --check` if a Git worktree is available; otherwise inspect the changed files and test output directly. This workspace currently has no `.git` directory, so no commit is planned.
