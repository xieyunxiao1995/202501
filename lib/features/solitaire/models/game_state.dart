import 'card_model.dart';

class SolitaireGameState {
  SolitaireGameState({
    required List<PlayingCard> stock,
    required List<PlayingCard> waste,
    required Map<Suit, List<PlayingCard>> foundations,
    required List<List<PlayingCard>> tableau,
    required this.moves,
    required this.elapsedSeconds,
    required this.seed,
    required this.completed,
    this.stockRecycles = 0,
  }) : stock = List<PlayingCard>.unmodifiable(stock),
       waste = List<PlayingCard>.unmodifiable(waste),
       foundations = Map<Suit, List<PlayingCard>>.unmodifiable(
         foundations.map(
           (suit, pile) => MapEntry(suit, List<PlayingCard>.unmodifiable(pile)),
         ),
       ),
       tableau = List<List<PlayingCard>>.unmodifiable(
         tableau.map(List<PlayingCard>.unmodifiable),
       );

  final List<PlayingCard> stock;
  final List<PlayingCard> waste;
  final Map<Suit, List<PlayingCard>> foundations;
  final List<List<PlayingCard>> tableau;
  final int moves;
  final int elapsedSeconds;
  final int seed;
  final bool completed;
  final int stockRecycles;

  SolitaireGameState copyWith({
    List<PlayingCard>? stock,
    List<PlayingCard>? waste,
    Map<Suit, List<PlayingCard>>? foundations,
    List<List<PlayingCard>>? tableau,
    int? moves,
    int? elapsedSeconds,
    bool? completed,
    int? stockRecycles,
  }) => SolitaireGameState(
    stock: stock ?? this.stock,
    waste: waste ?? this.waste,
    foundations: foundations ?? this.foundations,
    tableau: tableau ?? this.tableau,
    moves: moves ?? this.moves,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    seed: seed,
    completed: completed ?? this.completed,
    stockRecycles: stockRecycles ?? this.stockRecycles,
  );

  /// Returns an independent snapshot of every pile and card.
  ///
  /// The state is already immutable at its public boundary, but undo history
  /// should not rely on that implementation detail when it stores snapshots.
  SolitaireGameState deepCopy() => SolitaireGameState(
    stock: stock.map((card) => card.copyWith()).toList(),
    waste: waste.map((card) => card.copyWith()).toList(),
    foundations: <Suit, List<PlayingCard>>{
      for (final suit in Suit.values)
        suit: foundations[suit]!.map((card) => card.copyWith()).toList(),
    },
    tableau: tableau
        .map((pile) => pile.map((card) => card.copyWith()).toList())
        .toList(),
    moves: moves,
    elapsedSeconds: elapsedSeconds,
    seed: seed,
    completed: completed,
    stockRecycles: stockRecycles,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'stock': stock.map((card) => card.toJson()).toList(),
    'waste': waste.map((card) => card.toJson()).toList(),
    'foundations': <String, dynamic>{
      for (final suit in Suit.values)
        suit.name: foundations[suit]!.map((card) => card.toJson()).toList(),
    },
    'tableau': tableau
        .map((pile) => pile.map((card) => card.toJson()).toList())
        .toList(),
    'moves': moves,
    'elapsedSeconds': elapsedSeconds,
    'seed': seed,
    'completed': completed,
    'stockRecycles': stockRecycles,
  };

  factory SolitaireGameState.fromJson(Map<String, dynamic> json) {
    List<PlayingCard> cards(Object? raw) => (raw as List<dynamic>)
        .map((entry) => PlayingCard.fromJson(entry as Map<String, dynamic>))
        .toList();
    final rawFoundations = json['foundations'] as Map<String, dynamic>;
    return SolitaireGameState(
      stock: cards(json['stock']),
      waste: cards(json['waste']),
      foundations: <Suit, List<PlayingCard>>{
        for (final suit in Suit.values) suit: cards(rawFoundations[suit.name]),
      },
      tableau: (json['tableau'] as List<dynamic>).map(cards).toList(),
      moves: json['moves'] as int,
      elapsedSeconds: json['elapsedSeconds'] as int,
      seed: json['seed'] as int,
      completed: json['completed'] as bool,
      stockRecycles: json['stockRecycles'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SolitaireGameState &&
      _sameCards(stock, other.stock) &&
      _sameCards(waste, other.waste) &&
      _samePiles(tableau, other.tableau) &&
      Suit.values.every(
        (suit) => _sameCards(foundations[suit]!, other.foundations[suit]!),
      ) &&
      moves == other.moves &&
      elapsedSeconds == other.elapsedSeconds &&
      seed == other.seed &&
      completed == other.completed &&
      stockRecycles == other.stockRecycles;

  @override
  int get hashCode => Object.hash(
    moves,
    elapsedSeconds,
    seed,
    completed,
    stockRecycles,
    stock.length,
    waste.length,
  );

  static bool _sameCards(List<PlayingCard> first, List<PlayingCard> second) =>
      first.length == second.length &&
      Iterable<int>.generate(
        first.length,
      ).every((index) => first[index] == second[index]);

  static bool _samePiles(
    List<List<PlayingCard>> first,
    List<List<PlayingCard>> second,
  ) =>
      first.length == second.length &&
      Iterable<int>.generate(
        first.length,
      ).every((index) => _sameCards(first[index], second[index]));
}
