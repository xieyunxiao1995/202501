import 'dart:math';

class Skill {
  final String id;
  final String name;
  final String description;
  int level;
  final int maxLevel;
  final double baseValue;
  final double growthValue;
  final int baseCost;
  final double costMultiplier;
  final String statKey; // attack, defense, speed, hp, maxInk, maxSanity

  Skill({
    required this.id,
    required this.name,
    required this.description,
    this.level = 1,
    this.maxLevel = 10,
    required this.baseValue,
    required this.growthValue,
    required this.baseCost,
    this.costMultiplier = 1.5,
    required this.statKey,
  });

  int get currentValue => (baseValue + (growthValue * (level - 1))).round();
  int get nextValue => (baseValue + (growthValue * level)).round();
  int get upgradeCost => (baseCost * pow(costMultiplier, level - 1)).toInt();
  bool get isMaxLevel => level >= maxLevel;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'level': level,
      'maxLevel': maxLevel,
      'baseValue': baseValue,
      'growthValue': growthValue,
      'baseCost': baseCost,
      'costMultiplier': costMultiplier,
      'statKey': statKey,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      level: json['level'] ?? 1,
      maxLevel: json['maxLevel'] ?? 10,
      baseValue: json['baseValue'].toDouble(),
      growthValue: json['growthValue'].toDouble(),
      baseCost: json['baseCost'],
      costMultiplier: json['costMultiplier']?.toDouble() ?? 1.5,
      statKey: json['statKey'],
    );
  }
}
