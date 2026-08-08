# Journey Levels and Daily Challenge Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Turn the existing ten-level entry page and plain daily screen into a 40-level chapter journey and a visually distinctive, deterministic daily challenge experience.

**Architecture:** Keep local `setState` and `shared_preferences`. Add a static `LevelCatalog` for chapter/level presentation data, extend `PlayerProgress`'s sequential unlock limit to 40, and add presentation-only daily metadata to `DailyChallenge`. The screens derive all states from those models and pass existing seeds/level numbers to `SolitaireGameScreen`.

**Tech Stack:** Flutter, Dart 3.11, `flutter_test`, `shared_preferences`, existing felt/gold widgets.

---

### Task 1: Add failing tests for the journey catalog and daily descriptors

**Files:**
- Create: `test/features/levels/level_catalog_test.dart`
- Modify: `test/features/home/home_controller_test.dart`

**Step 1: Write the failing tests**

- Assert the catalog contains four chapters and 40 unique levels.
- Assert each chapter contains exactly ten levels and seeds are stable.
- Assert completed levels unlock sequentially through level 40 and never exceed level 40.
- Assert two calls for the same daily date return identical title, accent, difficulty, and seed; different dates can produce a different presentation descriptor.

**Step 2: Run the focused tests**

Run: `flutter test test/features/levels/level_catalog_test.dart test/features/home/home_controller_test.dart`

Expected: FAIL because the catalog and daily presentation properties do not exist yet.

### Task 2: Implement the static level catalog and progress/daily model behavior

**Files:**
- Create: `lib/features/levels/level_catalog.dart`
- Modify: `lib/features/home/home_controller.dart`

**Step 1: Implement the catalog**

Add four chapters and 40 level definitions with stable seeds, titles, goals, colors, and icons.

**Step 2: Extend progress behavior**

Use the catalog's total level count for sequential unlocks and expose a helper for the current chapter and per-chapter completion count.

**Step 3: Add deterministic daily presentation metadata**

Add title, subtitle, difficulty, and accent fields derived from the normalized date without changing the existing seed rule.

**Step 4: Run the focused tests**

Run: `flutter test test/features/levels/level_catalog_test.dart test/features/home/home_controller_test.dart`

Expected: PASS.

### Task 3: Redesign the Level screen and home progress card

**Files:**
- Modify: `lib/features/levels/level_screen.dart`
- Modify: `lib/features/home/home_screen.dart`
- Create: `test/features/levels/level_screen_test.dart`
- Modify: `test/features/home/home_screen_test.dart`

**Step 1: Write widget tests**

Assert the Level screen exposes all four chapter labels, ten level labels for the selected chapter, lock styling/copy for a locked chapter, and completed star display. Assert the home screen uses the current chapter title and a dynamic progress value.

**Step 2: Run widget tests to verify the intended UI fails**

Run: `flutter test test/features/levels/level_screen_test.dart test/features/home/home_screen_test.dart`

Expected: FAIL because the current screen only renders Chapter 1's ten hard-coded nodes and the home card is hard-coded to Chapter 1.

**Step 3: Implement the map UI**

Render the selected chapter as a responsive, scrollable path with custom-painted route texture, chapter selector, stateful nodes, three-star labels, and a chapter progress panel. Use `LayoutBuilder` for horizontal placement and avoid `Expanded` inside scrollable content.

**Step 4: Implement dynamic home progress**

Derive the current chapter and its completed-level count from `LevelCatalog` and `PlayerProgress`.

**Step 5: Run widget tests**

Run: `flutter test test/features/levels/level_screen_test.dart test/features/home/home_screen_test.dart`

Expected: PASS.

### Task 4: Redesign the Daily Challenge screen

**Files:**
- Modify: `lib/features/daily_challenge/daily_challenge_screen.dart`
- Create: `test/features/daily_challenge/daily_challenge_screen_test.dart`

**Step 1: Write the widget tests**

Inject a fixed date and assert the screen shows the formatted date, deterministic challenge title, difficulty, and a Play Now action.

**Step 2: Run the test to verify the intended UI fails**

Run: `flutter test test/features/daily_challenge/daily_challenge_screen_test.dart`

Expected: FAIL because the existing page has only a generic title/date card and no injected date or descriptor copy.

**Step 3: Implement the hero card**

Build a scroll-safe daily screen with a title row, oversized themed card, date identity, difficulty, descriptive copy, and the existing seeded navigation action.

**Step 4: Run the widget test**

Run: `flutter test test/features/daily_challenge/daily_challenge_screen_test.dart`

Expected: PASS.

### Task 5: Verify the complete change

**Files:**
- Check: all modified Dart files and tests

**Step 1: Format**

Run: `dart format lib test`

**Step 2: Analyze**

Run: `flutter analyze`

Expected: no issues.

**Step 3: Run the full suite**

Run: `flutter test`

Expected: all tests pass.

