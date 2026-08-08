# Creative Mode Phase 1 Design

## Goal

Turn Creative Mode from a list of placeholder buttons into a small, playable extension of the existing Solitaire engine while keeping the product offline, free, non-social, non-push, non-vibration, and free of coin mechanics.

## Scope

Phase 1 includes:

- A data-driven Creative Mode catalog.
- A redesigned Creative Mode landing page grouped by purpose.
- A detail page for every listed mode.
- Playable Treasure Hunt, Time Trial, and One-Draw Sprint modes.
- Coming Later presentation for Shadow Solitaire, Chain Deck, and Joker Rescue.
- Tests for catalog behavior, Treasure Hunt tracking, and One-Draw Sprint stock rules.

Phase 1 does not include Creative statistics, recent-play history, persistent Creative sessions, a Joker card model, or chain-lock animations.

## Design

### Shared engine with a mode adapter

`SolitaireGameScreen` remains the single board implementation. It receives an optional `CreativeModeType` and creates a lightweight `CreativeGameController` for mode-specific state and rules. Classic games continue using the existing path unchanged.

This keeps card movement, undo, hint, pause, timer, and win presentation in one place. Creative games do not load or overwrite the classic active-game save and do not contribute to classic player statistics in this phase.

### Mode catalog

`CreativeModeType` and `CreativeModeDefinition` own the stable mode ID, title, short description, goal, rules, difficulty, icon, accent color, section, and playability. The catalog is the single source for both the landing page and detail page.

Playable modes:

- Treasure Hunt: six deterministic target cards are selected from the initially hidden stock; a target counts when it becomes face up anywhere on the board.
- Time Trial: uses the existing elapsed timer and provides non-vibrating text pace feedback at 30 and 60 seconds.
- One-Draw Sprint: draws one card at a time and forbids stock recycling after the first pass.

Deferred modes remain visible so the product roadmap is discoverable, but their detail page has a disabled Coming Later action.

### Treasure Hunt tracking

Treasure targets are derived from the initial stock, so they are hidden at the start and deterministic for a seed. The controller derives a stable suit/rank key for each target and recomputes revealed treasures from the current Solitaire state. No new card identity field or server state is needed.

### One-Draw Sprint rule

The current engine already draws one card per action, so the meaningful variant is a single stock pass. Normal Solitaire keeps unlimited recycling; One-Draw Sprint rejects recycling and exposes that rule through the mode status and a SnackBar when the player tries to recycle.

### UI

The landing page uses Featured, Speed, Classic Twist, Memory, Puzzle, and Coming Later sections as applicable. Each card shows an icon, title, one-line description, difficulty, and either Play or Coming Later. Tapping any card opens its detail page. The detail page shows goal, rules, difficulty, and the primary action.

The game board shows a compact mode tag. Treasure Hunt also shows its found/total counter. Time Trial pace messages are text-only. Existing pause, undo, hint, and no-more-moves behavior is reused.

## Verification

- Unit tests cover catalog IDs and availability, deterministic Treasure Hunt target selection/reveal counting, and the no-recycle rule.
- Widget tests cover the landing page, detail page navigation, playable mode launch, and deferred mode presentation.
- `flutter analyze` and the complete `flutter test` suite must pass before completion.
