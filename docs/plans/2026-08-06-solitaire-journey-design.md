# Solitaire Journey design

## Goal

Create an offline iOS-ready Flutter solitaire game inspired by the supplied
reference: a rich green felt table, gold highlights, chapter progression, and
compact game controls. The first release must include a fully playable,
single-draw Klondike game rather than a visual-only prototype.

## Product scope

* Home screen with daily challenge, continue game, classic solitaire, creative
  modes, and chapter progress.
* Standard Klondike: stock, waste, seven tableau piles, four foundations,
  clicking and drag-and-drop, legal-move feedback, automatic face-up cards,
  undo, hints, new deal, win detection, and a win reward panel.
* Adventure levels use the same game engine with deterministic deal seeds and
  step-based stars.
* Creative modes show the supplied-mode-inspired selection UI. One entry opens
  the playable rules engine; future modes are displayed as coming soon.
* Local persistence for the active game, completed levels, coins, selected
  theme, and settings. No account or network requests.

## Architecture

The project follows the README's feature-module layout and MVC-style split.
Pure game state and rules live outside widgets, while screen state is managed
with `setState`.

* `features/solitaire/models`: Card, suit, rank, pile location, move and game
  state value objects.
* `features/solitaire/game_controller.dart`: deals cards, validates and applies
  moves, tracks history, finds hints, detects wins, and serializes state.
* `features/*/*_screen.dart`: responsive presentation and navigation.
* `core/storage`: a small shared_preferences gateway, with defensive restore
  behavior when saved data is invalid or from a different version.
* `core/widgets`: reusable felt surface, gold panel, circular action control,
  card view, and bottom navigation.

## Rules and interaction

The game uses a shuffled 52-card deck and single-card draws. Tableau stacks
may only be built in descending rank with alternating colors. Only kings can
be moved to empty columns. Foundations start with aces and build upward within
one suit. A face-down tableau card turns face-up once uncovered; the player
wins when all four foundations contain thirteen cards.

The player may tap a movable card then tap a destination, or drag it to a
highlighted legal destination. Selecting stock draws to waste. Hint highlights
one available move. Undo restores the precise prior game state. Every
meaningful state change is saved locally.

## Visual system

Use the card and card-back images already under `assets/`; add the asset folder
to pubspec. Other controls use bundled Material/Cupertino icons to keep the
application fully offline. The interface uses layered dark forest-green felt,
subtle gold borders, translucent rounded panels, large cream text, and the
compact bottom action row visible in the reference.

## Error handling and testing

Restore failures begin a safe fresh deal without crashing. Invalid move requests
are ignored and the player receives light visual feedback. Unit tests are
written first for deal invariants, legal and illegal tableau moves, foundation
moves, face-up behavior, undo, and win detection. Widget tests cover core
navigation and deal-reset behavior. Final validation runs `flutter analyze`,
`flutter test`, and an iOS build.
