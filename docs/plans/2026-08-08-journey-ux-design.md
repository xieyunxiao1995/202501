# Solitaire Journey UX Design

## Goal

Add the missing product moments around launch, victory, undo, Journey progression, Creative Mode onboarding, empty statistics, and saved-game recovery while reusing the existing local progress and game state models.

## Scope

- Show a three-page, lightweight splash flow on every app launch: brand, the three play paths, and a continue prompt.
- Replace the current win-only return flow with a settlement card showing time, moves, stars, and Replay / Next Level / Home actions.
- Show the current undo history count in the game toolbar and action row.
- Make the Journey landing flow chapter-first, with a chapter overview and a level detail page before starting a level.
- Add a short Creative Mode explanation page before entering a mode.
- Give Statistics an intentional first-use empty state.
- Give saved-game load failures an explicit recovery page instead of silently discarding the saved game.

Out of scope: leaderboards, sharing, daily tasks, currency, unlock economies, network services, and complex particle systems.

## Architecture

Use small Material widgets and existing `FeltScaffold` / `GoldPanel` styling. Add a launch gate above the current app shell so the existing navigation remains the source of truth after the splash completes. Keep screen state local to each feature and continue using `GameStorage`, `PlayerProgress`, `CreativeProgress`, and `SolitaireGameController`; no duplicate persistence model is introduced.

The victory card stays a reusable widget invoked by `GameScreen`. A completed Journey level passes its level number and computed stars into the same result surface. The “Next Level” action returns a level selection result and starts the next unlocked level through the existing catalog route. Creative mode gets a detail/briefing page that starts the existing `GameScreen` with the selected mode.

## Visual direction

Use the existing forest/felt palette with restrained gold accents. The win card uses a short `AnimationController` for a gold shimmer and a few positioned card-shaped marks flying toward a foundation icon; if the animation is disabled or skipped, the content remains fully usable. All new top-level screens use `SafeArea`, `LayoutBuilder` where width changes the layout, and scrollable content for small phones.

## Data and error handling

- Time is formatted from the existing elapsed seconds.
- Moves come from the existing game move counter.
- Stars are derived from the existing Journey goal thresholds and are stored through `PlayerProgress.recordWin`.
- Undo displays the length of the controller history; the controller exposes a read-only count without changing undo behavior.
- `GameStorage.loadGame()` remains nullable. `GameScreen` distinguishes “no active save” from “save exists but cannot be decoded” so a failed restore can be acknowledged and the player can start a new deal.
- Statistics shows the empty message only when all classic and Creative counters are zero.

## Verification

Add widget tests for the launch pages, victory metrics/actions, undo count, chapter/level detail navigation, Creative briefing, empty statistics, and save recovery. Run the focused tests first, then `flutter test`, `flutter analyze`, and a debug build if the platform toolchain is available.
