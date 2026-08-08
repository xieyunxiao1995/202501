import '../solitaire/models/card_model.dart';
import '../solitaire/models/game_state.dart';
import 'creative_mode.dart';

class CreativeGameController {
  CreativeGameController._({
    required this.mode,
    required Set<String> treasureKeys,
    required List<PlayingCard> memoryCards,
  }) : _treasureKeys = Set.unmodifiable(treasureKeys),
       _memoryCards = List.unmodifiable(memoryCards);

  factory CreativeGameController.fromState(
    CreativeModeType mode,
    SolitaireGameState initialState,
  ) {
    final targets = mode == CreativeModeType.treasureHunt
        ? initialState.stock
              .where((card) => !card.isFaceUp)
              .take(_totalTreasureCards)
              .map(cardKey)
              .toSet()
        : <String>{};
    final memoryCards = mode == CreativeModeType.shadowSolitaire
        ? initialState.tableau
              .where((pile) => pile.isNotEmpty)
              .map((pile) => pile.last)
              .take(_memoryCardCount)
              .toList()
        : <PlayingCard>[];
    return CreativeGameController._(
      mode: mode,
      treasureKeys: targets,
      memoryCards: memoryCards,
    );
  }

  static const _totalTreasureCards = 5;
  static const _memoryCardCount = 5;
  static const jokerUnlockMoves = 5;

  final CreativeModeType mode;
  final Set<String> _treasureKeys;
  final List<PlayingCard> _memoryCards;

  static String cardKey(PlayingCard card) =>
      '${card.suit.name}:${card.rank.name}';

  Set<String> get treasureKeys => _treasureKeys;

  int get totalTreasures => _treasureKeys.length;

  bool get isStockRecycleAllowed => mode != CreativeModeType.oneDrawSprint;

  bool get isTimeTrial => mode == CreativeModeType.timeTrial;

  List<PlayingCard> get memoryCards => _memoryCards;

  List<String> get memoryCardLabels => List.unmodifiable(
    _memoryCards.map((card) => '${card.rank.label}${card.suit.symbol}'),
  );

  int jokerMoves(SolitaireGameState state) => state.moves < jokerUnlockMoves
      ? state.moves.clamp(0, jokerUnlockMoves)
      : jokerUnlockMoves;

  bool jokerUnlocked(SolitaireGameState state) =>
      mode == CreativeModeType.jokerRescue && state.moves >= jokerUnlockMoves;

  PlayingCard jokerCard(SolitaireGameState state) =>
      PlayingCard.joker(isFaceUp: jokerUnlocked(state));

  int treasuresFound(SolitaireGameState state) {
    if (_treasureKeys.isEmpty) return 0;
    final visibleCards = <PlayingCard>[
      ...state.waste,
      ...state.tableau.expand((pile) => pile),
      ...state.foundations.values.expand((pile) => pile),
    ];
    return visibleCards
        .where((card) => card.isFaceUp && _treasureKeys.contains(cardKey(card)))
        .map(cardKey)
        .toSet()
        .length;
  }
}
