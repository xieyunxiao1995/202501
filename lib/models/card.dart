enum ElementType {
  metal,
  wood,
  water,
  fire,
  earth,
  special,
  none, // Added for safety
}

enum EffectType {
  damage,
  shield,
  heal,
  poison,
  burn,
  weak, // Reduce attack
  vulnerable, // Increase damage taken
  draw,
}

class CardEffect {
  final EffectType type;
  final int value;

  const CardEffect({required this.type, required this.value});

  Map<String, dynamic> toJson() => {'type': type.index, 'value': value};

  factory CardEffect.fromJson(Map<String, dynamic> json) {
    return CardEffect(
      type: EffectType.values[json['type']],
      value: json['value'],
    );
  }
}

class WordCard {
  final String id;
  final String character; // The Kanji/Hanzi
  final ElementType element;
  final String name;
  final String description;
  final int manaCost;
  final List<CardEffect> effects;

  const WordCard({
    required this.id,
    required this.character,
    required this.element,
    required this.name,
    required this.description,
    required this.manaCost,
    this.effects = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character': character,
      'element': element.index,
      'name': name,
      'description': description,
      'manaCost': manaCost,
      'effects': effects.map((e) => e.toJson()).toList(),
    };
  }

  factory WordCard.fromJson(Map<String, dynamic> json) {
    return WordCard(
      id: json['id'],
      character: json['character'],
      element: ElementType.values[json['element']],
      name: json['name'],
      description: json['description'],
      manaCost: json['manaCost'],
      effects: (json['effects'] as List<dynamic>?)
          ?.map((e) => CardEffect.fromJson(e))
          .toList() ?? [],
    );
  }
}
