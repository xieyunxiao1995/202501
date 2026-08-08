# Solitaire Journey · 100-Level Journey Map Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Turn the existing four-chapter connected level map into a five-chapter, 100-level adventure booklet while preserving the current local progress model and game launch flow.

**Architecture:** Keep `PlayerProgress.completedStars` as the source of truth for stars and sequential unlocks. Expand `LevelCatalog` with stable seeds, chapter presentation metadata, and 20 levels per chapter. Render a responsive, vertically scrollable LevelScreen with a chapter header, alternating S-shaped wood-sign cards, and a level detail dialog. Reuse the existing `SolitaireGameScreen` and storage JSON so old saves remain readable.

**Tech Stack:** Flutter, Dart, `flutter_test`, `shared_preferences`, existing felt/gold widgets and Material icons.

---

### Task 1: Lock the catalog and UI contract with tests

**Files:**
- Modify: `test/features/levels/level_catalog_test.dart`
- Modify: `test/features/levels/level_screen_test.dart`

**Step 1: Write failing tests**

- Assert five chapters, 100 unique levels, 20 levels per chapter, and unique stable seeds.
- Assert the requested chapter names and 1–20, 21–40, 41–60, 61–80, 81–100 ranges.
- Assert the selected chapter header reports completed levels and `x/60` stars.
- Assert the first chapter renders all 20 level labels, no `Future Mode`/coming-soon copy, and a lock state for an unavailable level.
- Assert tapping an unlocked level opens a detail dialog with `Best`, `Stars`, and `Start`.

**Step 2: Run focused tests**

Run: `flutter test test/features/levels/level_catalog_test.dart test/features/levels/level_screen_test.dart`

Expected: FAIL because the current catalog has four ten-level chapters and the screen still renders connected nodes.

### Task 2: Expand the static catalog to five themed chapters and 100 levels

**Files:**
- Modify: `lib/features/levels/level_catalog.dart`

**Step 1: Preserve existing definitions**

Keep levels 1–40 and their seeds unchanged for save/deal compatibility, while renaming their chapter presentation to the new Forest Journey, Royal Garden, and Midnight Cards themes where appropriate.

**Step 2: Add levels 41–100**

Add two twenty-level chapters with stable seeds and presentation titles/goals. Add difficulty, target time, and target moves as catalog metadata for the three-star display/feedback contract without changing the core Solitaire rules.

**Step 3: Update catalog helpers**

Set `levelsPerChapter` to 20 and `totalLevels` to 100. Keep `level`, `chapterForLevel`, `completedLevels`, and `starsInChapter` APIs compatible.

### Task 3: Replace the connected map with the adventure booklet UI

**Files:**
- Modify: `lib/features/levels/level_screen.dart`

**Step 1: Build the chapter header**

Show the current chapter number/title, subtitle, completed count out of 20, and stars out of 60. Use chapter accent colors and light decorative icons rather than a separate complex map system.

**Step 2: Build the S-shaped level list**

Use a responsive `Column` with alternating left/center/right alignment and fixed gaps. Render wood-sign cards instead of circular nodes. Show playable/current, completed, and locked states with visible stars and a direct play affordance.

**Step 3: Add the detail dialog**

Tapping an unlocked card opens a modal detail view with title, goal, best record derived from existing level progress, stars, and a `Start` action. Starting continues to pass the same level number and seed into `SolitaireGameScreen`.

**Step 4: Add lightweight chapter completion presentation**

When all 20 levels in the selected chapter are complete, show a local “Chapter Complete!” panel with the chapter theme reward copy. Do not add currency, networking, or a new unlock economy.

### Task 4: Keep progress and launch behavior compatible

**Files:**
- Modify only if needed: `lib/features/home/home_controller.dart`, `lib/features/solitaire/game_screen.dart`

**Step 1: Verify sequential unlock behavior**

Ensure old `completedStars` maps still unlock the next level and a level 100 completion does not advance beyond 100.

**Step 2: Wire catalog thresholds only where supported**

Keep existing generic star calculation unless the current game flow can consume the new metadata without changing gameplay rules. The catalog remains the single source for level presentation thresholds.

**Step 3: Preserve JSON compatibility**

Do not rename or remove existing progress keys. Any optional metadata must have defaults when reading older saves.

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
