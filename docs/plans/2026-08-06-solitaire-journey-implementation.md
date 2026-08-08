# Solitaire Journey Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a fully playable, offline, single-draw Klondike Flutter game with the Solitaire Journey home, level map, and creative-mode experience.

**Architecture:** Keep deterministic Klondike rules in plain Dart model and controller classes, then use `setState` in feature screens to render and mutate that state. Persist a JSON representation of the game and player progress behind a compact SharedPreferences repository. Reusable presentation components provide the dark-felt, gold-trim visual system.

**Tech Stack:** Flutter, Dart, flutter_test, shared_preferences, bundled Material/Cupertino icons, existing local PNG assets.

---

### Task 1: Configure offline dependencies and asset discovery

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/core/constants/asset_paths.dart`
- Test: `test/core/constants/asset_paths_test.dart`

**Step 1: Write the failing test**

```dart
import 'package:cardgame/core/constants/asset_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('card asset catalog exposes 52 face paths and a card back', () {
    expect(CardAssets.facePaths, hasLength(52));
    expect(CardAssets.cardBack, startsWith('assets/'));
  });
}
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/constants/asset_paths_test.dart`

Expected: FAIL because `CardAssets` does not exist.

**Step 3: Write minimal implementation**

Add `shared_preferences: ^2.2.3` to dependencies and declare `assets/` in `pubspec.yaml`. Implement `CardAssets` with the actual existing card and card-back paths, indexed by rank and suit, and a safe fallback to drawn cards when an image is unavailable.

**Step 4: Run test to verify it passes**

Run: `flutter pub get && flutter test test/core/constants/asset_paths_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/core/constants/asset_paths.dart test/core/constants/asset_paths_test.dart
git commit -m "chore: configure local solitaire assets"
```

### Task 2: Model cards and serializable pile locations

**Files:**
- Create: `lib/features/solitaire/models/card_model.dart`
- Create: `lib/features/solitaire/models/pile_location.dart`
- Test: `test/features/solitaire/models/card_model_test.dart`

**Step 1: Write the failing test**

```dart
test('a card round-trips through JSON with its face state', () {
  const card = PlayingCard(suit: Suit.hearts, rank: Rank.queen, isFaceUp: true);
  expect(PlayingCard.fromJson(card.toJson()), card);
});

test('clubs and spades are black while hearts and diamonds are red', () {
  expect(Suit.clubs.isRed, isFalse);
  expect(Suit.diamonds.isRed, isTrue);
});
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/solitaire/models/card_model_test.dart`

Expected: FAIL because the models do not exist.

**Step 3: Write minimal implementation**

Implement immutable `Suit`, `Rank`, `PlayingCard`, and `PileLocation` types. Include display label/symbol/color helpers, equality, copy-with face state, and JSON methods without using `freezed` or `part` files.

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/solitaire/models/card_model_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/solitaire/models test/features/solitaire/models/card_model_test.dart
git commit -m "feat: add solitaire card models"
```

### Task 3: Deal an invariant-correct Klondike state

**Files:**
- Create: `lib/features/solitaire/models/game_state.dart`
- Create: `lib/features/solitaire/game_controller.dart`
- Test: `test/features/solitaire/game_controller_test.dart`

**Step 1: Write the failing test**

```dart
test('new deal creates seven tableau piles with only top cards face up', () {
  final game = SolitaireGameController.newGame(seed: 42).state;
  expect(game.tableau.map((pile) => pile.length), [1, 2, 3, 4, 5, 6, 7]);
  expect(game.tableau.expand((pile) => pile).where((card) => card.isFaceUp), hasLength(7));
  expect(game.stock, hasLength(24));
});

test('a seed deals the same layout every time', () {
  expect(SolitaireGameController.newGame(seed: 42).state,
      SolitaireGameController.newGame(seed: 42).state);
});
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/solitaire/game_controller_test.dart`

Expected: FAIL because the controller does not exist.

**Step 3: Write minimal implementation**

Create immutable `SolitaireGameState` with stock, waste, foundation map, seven tableaus, moves, elapsed seconds, seed, and completed flag. Implement deterministic Fisher-Yates shuffle and the 1..7 deal with the top tableau card face-up.

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/solitaire/game_controller_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/solitaire/models/game_state.dart lib/features/solitaire/game_controller.dart test/features/solitaire/game_controller_test.dart
git commit -m "feat: deal deterministic klondike games"
```

### Task 4: Add stock, tableau, and foundation rules

**Files:**
- Modify: `lib/features/solitaire/game_controller.dart`
- Test: `test/features/solitaire/game_controller_test.dart`

**Step 1: Write failing tests**

```dart
test('draw moves one card from stock to waste and recycling preserves order', () { /* ... */ });
test('only descending alternating face-up card sequences can join tableau', () { /* red 8 accepts black 7 */ });
test('only kings can move to an empty tableau column', () { /* ... */ });
test('foundation starts with ace and builds matching suit upward', () { /* ... */ });
test('uncovering a tableau card automatically turns it face up', () { /* ... */ });
```

**Step 2: Run tests to verify they fail**

Run: `flutter test test/features/solitaire/game_controller_test.dart`

Expected: FAIL only on the new unimplemented rules.

**Step 3: Write minimal implementation**

Add `drawFromStock`, `canMove`, `moveCards`, `moveToFoundation`, and `autoFlipExposedTableauCard`. Validate every source and destination before state mutation. Each successful action increments moves; rejected actions leave state unchanged.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/features/solitaire/game_controller_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/solitaire/game_controller.dart test/features/solitaire/game_controller_test.dart
git commit -m "feat: implement klondike movement rules"
```

### Task 5: Add undo, hint discovery, and winning state

**Files:**
- Modify: `lib/features/solitaire/game_controller.dart`
- Test: `test/features/solitaire/game_controller_test.dart`

**Step 1: Write failing tests**

```dart
test('undo restores the exact state before a successful move', () { /* ... */ });
test('hint returns a legal move when one is available', () { /* deterministic fixture */ });
test('four complete foundations mark the game complete', () { /* ... */ });
```

**Step 2: Run tests to verify they fail**

Run: `flutter test test/features/solitaire/game_controller_test.dart`

Expected: FAIL only for missing history, hint, and completion behavior.

**Step 3: Write minimal implementation**

Store immutable pre-action state snapshots for undo. Return a small `SuggestedMove` object by scanning foundation, tableau, and stock moves in that priority order. Set `completed` when all four foundations contain thirteen cards.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/features/solitaire/game_controller_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/solitaire/game_controller.dart test/features/solitaire/game_controller_test.dart
git commit -m "feat: add solitaire undo hints and wins"
```

### Task 6: Persist player and game data safely

**Files:**
- Create: `lib/core/storage/game_storage.dart`
- Create: `lib/features/home/home_controller.dart`
- Test: `test/core/storage/game_storage_test.dart`

**Step 1: Write failing tests**

```dart
test('saved game restores all card piles and counters', () async { /* fake SharedPreferences */ });
test('malformed saved game returns null instead of throwing', () async { /* ... */ });
test('completed level persists in player progress', () async { /* ... */ });
```

**Step 2: Run tests to verify they fail**

Run: `flutter test test/core/storage/game_storage_test.dart`

Expected: FAIL because storage does not exist.

**Step 3: Write minimal implementation**

Wrap `SharedPreferences` in `GameStorage`; store versioned JSON for the active state and a compact player-progress document. Catch parse and schema errors, clear only the invalid key, and return a new-game path.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/core/storage/game_storage_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/core/storage lib/features/home/home_controller.dart test/core/storage/game_storage_test.dart
git commit -m "feat: persist solitaire progress locally"
```

### Task 7: Build the reusable felt-and-gold interface system

**Files:**
- Create: `lib/app/app.dart`
- Create: `lib/app/routes.dart`
- Create: `lib/app/theme.dart`
- Create: `lib/core/widgets/felt_scaffold.dart`
- Create: `lib/core/widgets/gold_panel.dart`
- Create: `lib/core/widgets/bottom_nav.dart`
- Test: `test/core/widgets/felt_scaffold_test.dart`

**Step 1: Write the failing widget test**

```dart
testWidgets('felt scaffold renders a dark green surface and child', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: FeltScaffold(child: Text('Journey'))));
  expect(find.text('Journey'), findsOneWidget);
});
```

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/felt_scaffold_test.dart`

Expected: FAIL because the widget does not exist.

**Step 3: Write minimal implementation**

Define the app theme and named routes. Implement a reusable green radial-gradient scaffold, gold-stroke rounded panel, compact icon/text bottom navigation and restrained screen-transition animation.

**Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/felt_scaffold_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/app lib/core/widgets test/core/widgets/felt_scaffold_test.dart
git commit -m "feat: add solitaire journey visual foundation"
```

### Task 8: Render interactive cards and the playable game screen

**Files:**
- Create: `lib/features/solitaire/widgets/playing_card_view.dart`
- Create: `lib/features/solitaire/widgets/tableau_pile.dart`
- Create: `lib/features/solitaire/game_screen.dart`
- Test: `test/features/solitaire/game_screen_test.dart`

**Step 1: Write failing widget tests**

```dart
testWidgets('game screen renders seven tableau piles and four foundations', (tester) async { /* ... */ });
testWidgets('tapping stock draws a card to waste', (tester) async { /* ... */ });
testWidgets('new deal confirmation replaces the current game', (tester) async { /* ... */ });
```

**Step 2: Run tests to verify they fail**

Run: `flutter test test/features/solitaire/game_screen_test.dart`

Expected: FAIL because the screen does not exist.

**Step 3: Write minimal implementation**

Use `LayoutBuilder` to fit a portrait iPhone size while preserving card aspect ratio. Render existing assets where mapped and a clean rank/suit fallback otherwise. Add tap-select/tap-destination and `Draggable`/`DragTarget` movement, legal-target highlights, score/time/move header, hint/undo/new-deal controls, and a win dialog.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/features/solitaire/game_screen_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/solitaire/widgets lib/features/solitaire/game_screen.dart test/features/solitaire/game_screen_test.dart
git commit -m "feat: add playable solitaire table"
```

### Task 9: Build home, level map, and creative mode flows

**Files:**
- Create: `lib/features/home/home_screen.dart`
- Create: `lib/features/levels/level_screen.dart`
- Create: `lib/features/creative/creative_screen.dart`
- Modify: `lib/app/routes.dart`
- Modify: `lib/app/app.dart`
- Modify: `lib/main.dart`
- Test: `test/features/home/home_screen_test.dart`

**Step 1: Write failing widget tests**

```dart
testWidgets('home exposes classic solitaire and creative modes', (tester) async { /* ... */ });
testWidgets('classic solitaire button opens the game route', (tester) async { /* ... */ });
testWidgets('level map opens a deterministic adventure deal', (tester) async { /* ... */ });
```

**Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/home_screen_test.dart`

Expected: FAIL because the feature screens and routes do not exist.

**Step 3: Write minimal implementation**

Implement the source-inspired home hierarchy, chapter path with accessible level buttons and star display, and creative mode tiles. Route classic, continue, and an available creative tile to `GameScreen`; inject a seed and adventure metadata for selected levels. Mark unavailable creative tiles as coming soon with no dead navigation.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/features/home/home_screen_test.dart`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/main.dart lib/app lib/features/home lib/features/levels lib/features/creative test/features/home/home_screen_test.dart
git commit -m "feat: add solitaire journey navigation"
```

### Task 10: Run complete validation and iOS build

**Files:**
- Modify: any only when validation identifies a specific defect

**Step 1: Format all Dart files**

Run: `dart format lib test`

Expected: all Dart files formatted.

**Step 2: Run static analysis**

Run: `flutter analyze`

Expected: `No issues found!`.

**Step 3: Run all automated tests**

Run: `flutter test`

Expected: every test passes.

**Step 4: Build the iOS app**

Run: `flutter build ios --debug --no-codesign`

Expected: exit code 0 and generated debug iOS application output.

**Step 5: Commit validation fixes**

```bash
git add lib test pubspec.yaml pubspec.lock
git commit -m "fix: polish solitaire journey release"
```
