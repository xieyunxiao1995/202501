# Creative Mode V1 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Turn Creative Mode into a five-mode, fully playable local experience where every visible mode has rules, a playable Solitaire session, a result screen, and persistent records.

**Architecture:** Keep `SolitaireGameScreen` and `SolitaireGameController` as the single board/game engine. Add mode-specific behavior to the pure `CreativeGameController`, pass mode configuration into the board, and keep local Creative records in the immutable `CreativeProgress` model behind `GameStorage`. The landing page and detail page consume the same catalog and progress snapshot, while classic Solitaire saves and progress remain isolated.

**Tech Stack:** Flutter/Dart, Material 3 widgets, `SharedPreferences`, existing felt/gold components, and `flutter_test`.

---

## Product decisions

- The visible catalog contains exactly five playable modes: Treasure Hunt, Time Trial, One-Draw Sprint, Joker Rescue, and Shadow Cards.
- Chain Deck is removed from the visible catalog. The old enum value remains only for stored-data/source compatibility and is never rendered.
- The old `shadowSolitaire` enum value remains the stable storage ID, but its visible title is `Shadow Cards`.
- No `Future Mode`, `Coming Soon`, online leaderboard, sharing, coins, paid unlocks, daily tasks, AI hints, or vibration feedback is added.
- Joker Rescue uses a `CardType.joker` presentation/state card and unlocks after five successful board actions. It does not alter standard Solitaire legality.
- Shadow Cards uses a five-second memory overlay over a normal Solitaire deal. The overlay blocks board actions and the regular game timer until it finishes.

## Task 1: Update tests and the mode/progress contracts

**Files:**
- Modify: `test/features/creative/creative_mode_test.dart`
- Modify: `test/features/creative/creative_progress_test.dart`
- Modify: `test/features/creative/creative_controller_test.dart`
- Modify: `test/features/solitaire/models/card_model_test.dart`
- Create/modify: `test/features/solitaire/game_screen_test.dart`
- Create/modify: `test/features/solitaire/widgets/win_sheet_test.dart`

Write tests for the desired five-mode catalog, no Future Mode copy, five Treasure targets, Joker unlock progress, Shadow memory labels, and the expanded progress fields. Run each focused test before changing production code and confirm the failure is caused by the missing/new behavior.

## Task 2: Implement the catalog, card type, controller, and progress model

**Files:**
- Modify: `lib/features/creative/creative_mode.dart`
- Modify: `lib/features/creative/creative_controller.dart`
- Modify: `lib/features/creative/creative_progress.dart`
- Modify: `lib/features/solitaire/models/card_model.dart`
- Modify: `lib/features/solitaire/widgets/playing_card_view.dart`

Make the catalog contain five visible, playable definitions with the requested sections/copy. Add immutable `bestMoves` and `highestScores` maps plus accessors and JSON compatibility to `CreativeProgress`; update `recordWin` to retain the best time/moves, highest score, best treasures, and best stars.

Add `CardType.standard/joker` and a backward-compatible `PlayingCard.joker` constructor. Preserve old card JSON by defaulting missing type data to standard. Render a face-up Joker card without making it part of the standard deck. Extend `CreativeGameController` with deterministic Treasure Hunt targets, `jokerUnlocked`/progress helpers, and Shadow memory card labels.

Run the focused model/controller tests and the existing card tests after the implementation.

## Task 3: Redesign Creative landing/detail screens

**Files:**
- Modify: `lib/features/creative/creative_screen.dart`
- Modify: `lib/features/creative/creative_detail_screen.dart`
- Modify: `test/features/creative/creative_screen_test.dart`

Use the catalog’s five sections in the order Featured, Speed Challenge, Special Rules, Puzzle, and Memory. Remove all Future Mode UI. Keep every card tappable and show mode-specific records including wins, best time, best moves, score, and stars. Add the detail-page `Your Record` panel, Treasure Hunt five-gift preview, Joker locked preview, Shadow memory preview, and the existing Time Trial 30/60/Unlimited selector. Starting a mode records a play, saves it, then opens the board.

Run the Creative screen widget tests, then format the changed files.

## Task 4: Complete board feedback and mode rules

**Files:**
- Modify: `lib/features/solitaire/game_screen.dart`
- Modify: `lib/features/solitaire/game_controller.dart` only if a rule hook is required by tests
- Modify: `test/features/solitaire/game_screen_test.dart`
- Modify: `test/features/solitaire/game_controller_test.dart` only if a regression test is required

Keep the existing no-recycle policy for One-Draw Sprint and expose a clear stock count/`NO RECYCLE` banner. Show Treasure progress as a compact top status and announce newly found gifts. Show Time Trial current time and stored best time; use mode-specific speed stars and text-only timeout/pace feedback. Track Joker Rescue’s five-action unlock and present the unlocked card/status. Start Shadow Cards in a five-second, action-blocking memory phase, then return to ordinary board play.

Keep Creative sessions out of classic active-game persistence and classic `PlayerProgress`, while preserving existing pause, undo, hint, dead-end, and retry flows. Record Creative wins with elapsed time, moves, score, stars, and Treasure progress.

Run focused board/controller tests after each rule group.

## Task 5: Improve Creative results and shared progress views

**Files:**
- Modify: `lib/features/solitaire/widgets/win_sheet.dart`
- Modify: `lib/features/statistics/statistics_screen.dart`
- Modify: `lib/features/achievement/achievement_screen.dart`
- Modify: related widget tests under `test/features/solitaire/widgets/`, `test/features/statistics/`, and `test/features/achievement/`

Make Creative result copy mode-specific: Treasure Hunt shows completion and found gifts; Time Trial shows Speed Result, a speed evaluation, time, moves, and stars; Joker Rescue shows Joker Rescued when unlocked. Keep classic result labels unchanged. Show the expanded record fields in Statistics and Creative Detail, and keep Memory Master as a locked achievement until Shadow Cards has a recorded win.

## Task 6: Verify the full experience

Run:

```bash
dart format lib test
flutter analyze
flutter test
```

Read the complete output and inspect the changed files. Since this workspace has no `.git` directory, do not commit or run Git diff commands that assume a repository. Report any remaining limitation explicitly instead of claiming completion without fresh verification.
