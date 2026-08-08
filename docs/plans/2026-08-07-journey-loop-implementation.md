# Solitaire Journey Loop Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Turn the playable Klondike game into a complete offline journey loop with settings, time-based play, rewards, progression, themes, achievements, and daily challenges.

**Architecture:** Extend `PlayerProgress` as the single serializable local profile for settings, currency, theme ownership, level stars, and lifetime statistics. Screens load and save this profile using the existing `GameStorage`; `SolitaireGameScreen` owns only its active board timer and reports a typed result when an adventure game is won.

**Tech Stack:** Flutter, Dart, `flutter_test`, `shared_preferences`, local assets and Material icons.

---

### Task 1: Extend the local profile and storage contract

**Files:**
- Modify: `lib/features/home/home_controller.dart`
- Modify: `lib/core/storage/game_storage.dart`
- Test: `test/features/home/home_controller_test.dart`

**Steps:** Write a failing test for profile JSON round-trip, a paid theme purchase, a recorded win, and a deterministic daily seed. Run `flutter test test/features/home/home_controller_test.dart` and confirm it fails. Add immutable `GameSettings`, `GameStatistics`, theme ownership, achievement checks, level unlock logic, profile copy methods and date seed helper. Verify the test passes.

### Task 2: Make elapsed time live and retained with the board

**Files:**
- Modify: `lib/features/solitaire/game_controller.dart`
- Modify: `lib/features/solitaire/game_screen.dart`
- Test: `test/features/solitaire/game_controller_test.dart`

**Steps:** Add a failing test that ticking increments `elapsedSeconds` without creating an undo history record. Verify red. Implement a controller tick method and a one-second screen timer that starts after local restore and cancels in `dispose`; render `mm:ss`. Verify green.

### Task 3: Add game-result settlement and progress updates

**Files:**
- Create: `lib/features/solitaire/widgets/win_sheet.dart`
- Modify: `lib/features/solitaire/game_screen.dart`
- Modify: `lib/features/levels/level_screen.dart`
- Test: `test/features/solitaire/game_controller_test.dart`

**Steps:** Add a failing test for 1–3 stars derived from move and time targets. Verify red. Implement a result model, reward calculation, actual profile save, and a victory sheet with time, moves, coins, stars, next-level and map actions. Adventure games report a level completion; classic games record a win. Verify green.

### Task 4: Add settings and theme collection screens

**Files:**
- Create: `lib/features/settings/settings_screen.dart`
- Create: `lib/features/settings/settings_controller.dart`
- Create: `lib/features/themes/theme_screen.dart`
- Modify: `lib/features/home/home_screen.dart`
- Test: `test/features/settings/settings_screen_test.dart`

**Steps:** Write a failing widget test for settings labels and the theme store. Verify red. Implement local switches for effects/sound/music, a card-style selector, version information, and theme purchases with coins—without in-app purchases or network calls. Link top settings and bottom theme actions. Verify green.

### Task 5: Add achievement and statistics surfaces; complete the map and daily flow

**Files:**
- Create: `lib/features/achievement/achievement_screen.dart`
- Create: `lib/features/statistics/statistics_screen.dart`
- Create: `lib/features/daily_challenge/daily_challenge.dart`
- Modify: `lib/features/home/home_screen.dart`
- Modify: `lib/features/levels/level_screen.dart`
- Test: `test/features/home/home_screen_test.dart`

**Steps:** Write failing widget tests for date-derived daily data and the journey shortcuts. Verify red. Implement an offline daily card with date, reward and date-derived seed; show live profile values in home/map; add accessible achievement and statistics sheets. Verify green.

### Task 6: Release verification

**Files:**
- Modify only files that fail validation

**Steps:** Format with `dart format lib test`, run `flutter analyze`, run `flutter test`, then run `flutter build ios --debug --no-codesign`. Verify clean analysis, all tests passing, and `build/ios/Debug-iphoneos/Runner.app` present.
