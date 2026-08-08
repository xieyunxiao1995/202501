# Solitaire Journey · Levels and Daily Challenge Design

## Scope

This iteration improves the first-phase sense of progression without adding networking, social features, currency, or a new persistence system:

- Four chapters with ten levels each, for 40 local levels.
- A single-chapter adventure map showing ten connected nodes at a time.
- Clear visual states for locked, playable, current, and completed levels.
- Existing `completedStars` progress remains the source of truth for level stars and sequential unlocks.
- A redesigned Daily Challenge hero card with a date, deterministic title/theme, and difficulty.
- No daily streak, challenge history calendar, special rule enforcement, or theme-unlock economy in this iteration.

## Level experience

`LevelCatalog` owns static chapter and level definitions. A chapter contains its number, title, subtitle, color, icon, and ten `LevelDefinition` records. Each level has a stable local seed, display title, and short goal copy. The game screen continues to receive the selected level number and seed, so gameplay rules remain unchanged.

The level screen selects the chapter containing the current unlocked level on first load. A compact chapter strip exposes all four chapters; locked chapters remain visible but cannot be entered. The selected chapter renders a vertically scrollable path with alternating nodes. The node state is derived from `completedStars` and `unlockedLevel`, not stored separately. A lower progress panel reports the selected chapter's completed levels and stars.

The home screen derives its chapter title and progress from the same catalog, eliminating the hard-coded Chapter 1 label and `/10` calculation.

## Daily Challenge experience

`DailyChallenge.forDate` remains deterministic by calendar date. It additionally maps the normalized date to one of five presentation descriptors (for example, “Royal Morning Deal”), a subtitle, an accent color, and a 1–3 star difficulty. These are presentation metadata only; all challenges still use the existing seeded Solitaire game.

The screen uses a `ListView` inside `FeltScaffold` so it remains safe on small phones. It contains a back/title row, an oversized `GoldPanel` hero card, a large Play Now action, and a small local-only “tomorrow” reassurance. The card emphasizes the exact date and the daily identity, making the daily visit feel intentional without pretending that the app has a server or global ranking.

## Testing

Unit tests cover catalog cardinality, stable level seeds, sequential unlock behavior through level 40, and deterministic daily presentation metadata. Widget tests cover the chapter/level map labels, locked chapter presentation, dynamic home chapter progress, and the Daily Challenge hero card/date/action.

