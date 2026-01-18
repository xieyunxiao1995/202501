import 'enums.dart';

enum MaterialType {
  herb,
  ore,
  essence,
}

class AlchemyMaterial {
  final String id;
  final String name;
  final String icon;
  final MaterialType type;
  final Rarity rarity;
  final String description;

  const AlchemyMaterial({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.rarity,
    required this.description,
  });
}

class Elixir {
  final String id;
  final String name;
  final String icon;
  final String description;
  final Rarity rarity;
  final Map<String, int> recipe; // materialId -> count
  final Map<String, dynamic> effects; // e.g. {'start_hp': 20}

  const Elixir({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.rarity,
    required this.recipe,
    required this.effects,
  });
}
