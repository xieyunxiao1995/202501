import 'enums.dart';

class CardData {
  final String id;
  final CardType type;
  final int value;
  final int maxHp; // For monsters (Tank/Summoner)
  int currentHp; // For monsters
  final EnemyType enemyType; // For monsters
  bool isFlipped;
  bool isRevealed;
  final String name;
  final String icon;
  final Rarity rarity;
  final bool isBoss;
  final Affix affix;
  final GameElement element;
  final String? description; // Optional description (used for material ID)

  CardData({
    required this.id,
    required this.type,
    required this.value,
    required this.isFlipped,
    this.isRevealed = false,
    required this.name,
    required this.icon,
    this.rarity = Rarity.common,
    this.maxHp = 0,
    this.currentHp = 0,
    this.enemyType = EnemyType.standard,
    this.isBoss = false,
    this.affix = Affix.none,
    this.element = GameElement.none,
    this.description,
  });

  CardData copyWith({
    String? id,
    CardType? type,
    int? value,
    bool? isFlipped,
    bool? isRevealed,
    String? name,
    String? icon,
    Rarity? rarity,
    int? maxHp,
    int? currentHp,
    EnemyType? enemyType,
    bool? isBoss,
    Affix? affix,
    GameElement? element,
    String? description,
  }) {
    return CardData(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      isFlipped: isFlipped ?? this.isFlipped,
      isRevealed: isRevealed ?? this.isRevealed,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      rarity: rarity ?? this.rarity,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      enemyType: enemyType ?? this.enemyType,
      isBoss: isBoss ?? this.isBoss,
      affix: affix ?? this.affix,
      element: element ?? this.element,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'value': value,
      'maxHp': maxHp,
      'currentHp': currentHp,
      'enemyType': enemyType.index,
      'isFlipped': isFlipped,
      'isRevealed': isRevealed,
      'name': name,
      'icon': icon,
      'rarity': rarity.index,
      'isBoss': isBoss,
      'affix': affix.index,
      'element': element.index,
      'description': description,
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'],
      type: CardType.values[json['type']],
      value: json['value'],
      maxHp: json['maxHp'] ?? 0,
      currentHp: json['currentHp'] ?? 0,
      enemyType: EnemyType.values[json['enemyType'] ?? 0],
      isFlipped: json['isFlipped'],
      isRevealed: json['isRevealed'] ?? false,
      name: json['name'],
      icon: json['icon'],
      rarity: Rarity.values[json['rarity']],
      isBoss: json['isBoss'] ?? false,
      affix: Affix.values[json['affix'] ?? 0],
      element: GameElement.values[json['element'] ?? 0],
      description: json['description'],
    );
  }
}
