import 'dart:math';

import 'models/card_model.dart';
import 'models/game_state.dart';
import 'models/pile_location.dart';

class SolitaireGameController {
  SolitaireGameController._(this.state, {this.maxStockRecycles});

  static const _maxHistoryLength = 50;

  SolitaireGameState state;
  final int? maxStockRecycles;
  final List<SolitaireGameState> _history = <SolitaireGameState>[];

  static const _maxDealAttempts = 64;
  static const _dealSeedStep = 0x9E3779B9;

  factory SolitaireGameController.fromState(
    SolitaireGameState state, {
    int? maxStockRecycles,
  }) => SolitaireGameController._(
    state.copyWith(completed: _foundationsComplete(state.foundations)),
    maxStockRecycles: maxStockRecycles,
  );

  factory SolitaireGameController.newGame({int? seed, int? maxStockRecycles}) {
    final dealSeed = seed ?? DateTime.now().microsecondsSinceEpoch;
    return SolitaireGameController._(
      _generateDeal(dealSeed),
      maxStockRecycles: maxStockRecycles,
    );
  }

  static SolitaireGameState _generateDeal(int seed) {
    SolitaireGameState? fallback;
    for (var attempt = 0; attempt < _maxDealAttempts; attempt++) {
      final candidate = _buildDeal(seed, attempt);
      fallback = candidate;
      if (_hasOpeningPlay(candidate)) return candidate;
    }
    return fallback!;
  }

  static SolitaireGameState _buildDeal(int seed, int attempt) {
    final candidateSeed = seed + (attempt * _dealSeedStep);
    final deck = <PlayingCard>[
      for (final suit in Suit.values)
        for (final rank in Rank.values)
          PlayingCard(suit: suit, rank: rank, isFaceUp: false),
    ]..shuffle(Random(candidateSeed));

    final tableau = <List<PlayingCard>>[];
    var cursor = 0;
    for (var pileIndex = 0; pileIndex < 7; pileIndex++) {
      final pile = <PlayingCard>[];
      for (var cardIndex = 0; cardIndex <= pileIndex; cardIndex++) {
        final card = deck[cursor++];
        pile.add(card.copyWith(isFaceUp: cardIndex == pileIndex));
      }
      tableau.add(pile);
    }

    return SolitaireGameState(
      stock: deck.sublist(cursor),
      waste: const [],
      foundations: <Suit, List<PlayingCard>>{
        for (final suit in Suit.values) suit: <PlayingCard>[],
      },
      tableau: tableau,
      moves: 0,
      elapsedSeconds: 0,
      seed: seed,
      completed: false,
    );
  }

  static bool _hasOpeningPlay(SolitaireGameState candidate) {
    final probe = SolitaireGameController._(candidate);
    final hint = probe.findHint();
    return hint != null && hint.source.type != PileType.stock;
  }

  bool get canDrawFromStock {
    if (state.stock.isNotEmpty) return true;
    if (state.waste.isEmpty) return false;
    return maxStockRecycles == null || state.stockRecycles < maxStockRecycles!;
  }

  bool drawFromStock() {
    if (state.stock.isNotEmpty) {
      final stock = state.stock.toList();
      final waste = state.waste.toList();
      waste.add(stock.removeLast().copyWith(isFaceUp: true));
      _commit(
        state.copyWith(stock: stock, waste: waste, moves: state.moves + 1),
      );
      return true;
    }
    if (state.waste.isEmpty || !canDrawFromStock) return false;
    _commit(
      state.copyWith(
        stock: state.waste.reversed
            .map((card) => card.copyWith(isFaceUp: false))
            .toList(),
        waste: const [],
        moves: state.moves + 1,
        stockRecycles: state.stockRecycles + 1,
      ),
    );
    return true;
  }

  bool moveCards(PileLocation source, PileLocation destination) {
    if (destination.type == PileType.foundation) {
      return moveToFoundation(source);
    }
    if (destination.type != PileType.tableau || destination.index == null) {
      return false;
    }
    final moving = _movingCards(source);
    if (moving == null || moving.isEmpty || !_isValidTableauSequence(moving)) {
      return false;
    }
    final targetIndex = destination.index!;
    if (targetIndex < 0 || targetIndex >= state.tableau.length) return false;
    if (source.type == PileType.tableau && source.index == targetIndex) {
      return false;
    }
    final destinationPile = state.tableau[targetIndex];
    if (!_canAddToTableau(moving.first, destinationPile)) return false;

    final tableau = state.tableau.map((pile) => pile.toList()).toList();
    final foundations = _mutableFoundations();
    final waste = state.waste.toList();
    _removeFromSource(source, tableau, foundations, waste);
    tableau[targetIndex].addAll(moving);
    _autoFlip(tableau, source);
    _commit(
      state.copyWith(
        tableau: tableau,
        foundations: foundations,
        waste: waste,
        moves: state.moves + 1,
      ),
    );
    return true;
  }

  bool moveToFoundation(PileLocation source) {
    final moving = _movingCards(source);
    if (moving == null || moving.length != 1 || !moving.single.isFaceUp) {
      return false;
    }
    final card = moving.single;
    final foundations = _mutableFoundations();
    final target = foundations[card.suit]!;
    if (!_canAddToFoundation(card)) return false;

    final tableau = state.tableau.map((pile) => pile.toList()).toList();
    final waste = state.waste.toList();
    _removeFromSource(source, tableau, foundations, waste);
    target.add(card);
    _autoFlip(tableau, source);
    _commit(
      state.copyWith(
        tableau: tableau,
        waste: waste,
        foundations: foundations,
        moves: state.moves + 1,
        completed: false,
      ),
    );
    if (checkWin()) {
      state = state.copyWith(completed: true);
    }
    return true;
  }

  /// Returns whether all four foundations contain a complete suit.
  ///
  /// Completion is derived from the piles rather than trusting the cached
  /// state flag, so restored or externally-created states are handled too.
  bool checkWin() => _foundationsComplete(state.foundations);

  bool undo() {
    if (!canUndo) return false;
    state = _history.removeLast().deepCopy();
    return true;
  }

  bool get canUndo => _history.isNotEmpty;

  /// Number of successful actions that can currently be undone.
  int get historyCount => _history.length;

  bool get hasAvailableMove => findHint() != null;

  void tick() {
    if (!state.completed) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    }
  }

  SuggestedMove? findHint() {
    final candidates = <_HintCandidate>[];
    var order = 0;

    void add(PileLocation source, PileLocation destination, int score) {
      candidates.add(
        _HintCandidate(
          move: SuggestedMove(source, destination),
          score: score,
          order: order++,
        ),
      );
    }

    void addFoundationMove(PileLocation source, PlayingCard card) {
      if (!card.isFaceUp || !_canAddToFoundation(card)) return;
      final aceBonus = card.rank == Rank.ace ? Rank.values.length + 1 : 0;
      add(
        source,
        PileLocation(PileType.foundation, index: card.suit.index),
        800 + card.rank.value + aceBonus,
      );
    }

    const wasteSource = PileLocation(PileType.waste);
    final wasteCard = _movingCards(wasteSource)?.lastOrNull;
    if (wasteCard != null) {
      addFoundationMove(wasteSource, wasteCard);
      for (var target = 0; target < state.tableau.length; target++) {
        if (_canAddToTableau(wasteCard, state.tableau[target])) {
          add(
            wasteSource,
            PileLocation(PileType.tableau, index: target),
            _tableauMoveScore(wasteCard, state.tableau[target]),
          );
        }
      }
    }

    for (var source = 0; source < state.tableau.length; source++) {
      final pile = state.tableau[source];
      if (pile.isNotEmpty && pile.last.isFaceUp) {
        addFoundationMove(
          PileLocation(
            PileType.tableau,
            index: source,
            cardIndex: pile.length - 1,
          ),
          pile.last,
        );
      }
      for (var cardIndex = 0; cardIndex < pile.length; cardIndex++) {
        final moving = pile.sublist(cardIndex);
        if (!_isValidTableauSequence(moving)) continue;
        for (var target = 0; target < state.tableau.length; target++) {
          if (target == source ||
              !_canAddToTableau(moving.first, state.tableau[target])) {
            continue;
          }
          final revealsHidden = _revealsHiddenCard(source, cardIndex);
          final score = revealsHidden
              ? 1000 + _tableauMoveScore(moving.first, state.tableau[target])
              : _tableauMoveScore(moving.first, state.tableau[target]);
          add(
            PileLocation(PileType.tableau, index: source, cardIndex: cardIndex),
            PileLocation(PileType.tableau, index: target),
            score,
          );
        }
      }
    }

    for (final suit in Suit.values) {
      final pile = state.foundations[suit]!;
      if (pile.isEmpty) continue;
      final card = pile.last;
      for (var target = 0; target < state.tableau.length; target++) {
        if (_canAddToTableau(card, state.tableau[target])) {
          add(
            PileLocation(PileType.foundation, index: suit.index),
            PileLocation(PileType.tableau, index: target),
            250,
          );
        }
      }
    }

    if (canDrawFromStock) {
      add(
        const PileLocation(PileType.stock),
        const PileLocation(PileType.waste),
        100,
      );
    }

    if (candidates.isEmpty) return null;
    candidates.sort((first, second) {
      final score = second.score.compareTo(first.score);
      return score == 0 ? first.order.compareTo(second.order) : score;
    });
    return candidates.first.move;
  }

  int _tableauMoveScore(PlayingCard card, List<PlayingCard> destination) {
    if (destination.isEmpty && card.rank == Rank.king) return 600;
    return 400;
  }

  bool _revealsHiddenCard(int source, int cardIndex) {
    final pile = state.tableau[source];
    return cardIndex > 0 && !pile[cardIndex - 1].isFaceUp;
  }

  List<PlayingCard>? _movingCards(PileLocation source) {
    switch (source.type) {
      case PileType.waste:
        return state.waste.isEmpty ? null : <PlayingCard>[state.waste.last];
      case PileType.foundation:
        final index = source.index;
        if (index == null || index < 0 || index >= Suit.values.length) {
          return null;
        }
        final pile = state.foundations[Suit.values[index]]!;
        return pile.isEmpty ? null : <PlayingCard>[pile.last];
      case PileType.tableau:
        final pileIndex = source.index;
        final cardIndex = source.cardIndex;
        if (pileIndex == null ||
            cardIndex == null ||
            pileIndex < 0 ||
            pileIndex >= state.tableau.length) {
          return null;
        }
        final pile = state.tableau[pileIndex];
        if (cardIndex < 0 || cardIndex >= pile.length) return null;
        return pile.sublist(cardIndex);
      case PileType.stock:
        return null;
    }
  }

  Map<Suit, List<PlayingCard>> _mutableFoundations() =>
      <Suit, List<PlayingCard>>{
        for (final suit in Suit.values) suit: state.foundations[suit]!.toList(),
      };

  void _removeFromSource(
    PileLocation source,
    List<List<PlayingCard>> tableau,
    Map<Suit, List<PlayingCard>> foundations,
    List<PlayingCard> waste,
  ) {
    switch (source.type) {
      case PileType.waste:
        waste.removeLast();
      case PileType.foundation:
        foundations[Suit.values[source.index!]]!.removeLast();
      case PileType.tableau:
        tableau[source.index!] = tableau[source.index!].sublist(
          0,
          source.cardIndex!,
        );
      case PileType.stock:
        break;
    }
  }

  void _autoFlip(List<List<PlayingCard>> tableau, PileLocation source) {
    if (source.type != PileType.tableau) return;
    final pile = tableau[source.index!];
    if (pile.isNotEmpty && !pile.last.isFaceUp) {
      pile[pile.length - 1] = pile.last.copyWith(isFaceUp: true);
    }
  }

  bool _canAddToTableau(PlayingCard card, List<PlayingCard> pile) {
    if (pile.isEmpty) return card.rank == Rank.king;
    final top = pile.last;
    return top.isFaceUp &&
        top.isRed != card.isRed &&
        top.rank.value == card.rank.value + 1;
  }

  bool _canAddToFoundation(PlayingCard card) {
    final pile = state.foundations[card.suit]!;
    final targetRank = pile.isEmpty ? 0 : pile.last.rank.value;
    return card.rank.value == targetRank + 1;
  }

  void _commit(SolitaireGameState nextState) {
    if (_history.length >= _maxHistoryLength) {
      _history.removeAt(0);
    }
    _history.add(state.deepCopy());
    state = nextState;
  }

  static bool _foundationsComplete(Map<Suit, List<PlayingCard>> foundations) =>
      Suit.values.every(
        (suit) => foundations[suit]?.length == Rank.values.length,
      );

  bool _isValidTableauSequence(List<PlayingCard> cards) {
    if (cards.any((card) => !card.isFaceUp)) return false;
    for (var index = 1; index < cards.length; index++) {
      final previous = cards[index - 1];
      final current = cards[index];
      if (previous.isRed == current.isRed ||
          previous.rank.value != current.rank.value + 1) {
        return false;
      }
    }
    return true;
  }
}

class SuggestedMove {
  const SuggestedMove(this.source, this.destination);

  final PileLocation source;
  final PileLocation destination;
}

class _HintCandidate {
  const _HintCandidate({
    required this.move,
    required this.score,
    required this.order,
  });

  final SuggestedMove move;
  final int score;
  final int order;
}

extension _ListTail<T> on List<T> {
  T? get lastOrNull => isEmpty ? null : last;
}
