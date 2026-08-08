enum Suit { clubs, diamonds, hearts, spades }

enum CardType { standard, joker }

extension SuitDetails on Suit {
  bool get isRed => this == Suit.diamonds || this == Suit.hearts;

  String get symbol => switch (this) {
    Suit.clubs => '♣',
    Suit.diamonds => '♦',
    Suit.hearts => '♥',
    Suit.spades => '♠',
  };

  String get storageKey => name;
}

enum Rank {
  ace(1, 'A'),
  two(2, '2'),
  three(3, '3'),
  four(4, '4'),
  five(5, '5'),
  six(6, '6'),
  seven(7, '7'),
  eight(8, '8'),
  nine(9, '9'),
  ten(10, '10'),
  jack(11, 'J'),
  queen(12, 'Q'),
  king(13, 'K');

  const Rank(this.value, this.label);

  final int value;
  final String label;
}

class PlayingCard {
  const PlayingCard({
    required this.suit,
    required this.rank,
    required this.isFaceUp,
    this.type = CardType.standard,
  });

  const PlayingCard.joker({this.isFaceUp = false})
    : suit = Suit.spades,
      rank = Rank.ace,
      type = CardType.joker;

  final Suit suit;
  final Rank rank;
  final bool isFaceUp;
  final CardType type;

  bool get isJoker => type == CardType.joker;

  bool get isRed => suit.isRed;

  PlayingCard copyWith({bool? isFaceUp, CardType? type}) => PlayingCard(
    suit: suit,
    rank: rank,
    isFaceUp: isFaceUp ?? this.isFaceUp,
    type: type ?? this.type,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'suit': suit.storageKey,
    'rank': rank.name,
    'isFaceUp': isFaceUp,
    'type': type.name,
  };

  factory PlayingCard.fromJson(Map<String, dynamic> json) => PlayingCard(
    suit: Suit.values.byName(json['suit'] as String),
    rank: Rank.values.byName(json['rank'] as String),
    isFaceUp: json['isFaceUp'] as bool,
    type: json['type'] is String
        ? CardType.values.byName(json['type'] as String)
        : CardType.standard,
  );

  @override
  bool operator ==(Object other) =>
      other is PlayingCard &&
      other.suit == suit &&
      other.rank == rank &&
      other.isFaceUp == isFaceUp &&
      other.type == type;

  @override
  int get hashCode => Object.hash(suit, rank, isFaceUp, type);
}
