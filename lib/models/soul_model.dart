import 'enums.dart';

class Soul {
  final String id;
  final String name;
  final String icon;
  final String description;
  final SoulEffectType effectType;
  final double effectValue;
  final Rarity rarity;

  const Soul({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.effectType,
    required this.effectValue,
    required this.rarity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'effectType': effectType.index,
      'effectValue': effectValue,
      'rarity': rarity.index,
    };
  }

  factory Soul.fromJson(Map<String, dynamic> json) {
    return Soul(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      effectType: SoulEffectType.values[json['effectType']],
      effectValue: json['effectValue'],
      rarity: Rarity.values[json['rarity']],
    );
  }
}
