import 'enums.dart';

class Perk {
  final String id;
  final String name;
  final String desc;
  final String icon;
  final Rarity rarity;

  const Perk({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.rarity,
  });
}

class ClassConfig {
  final String id;
  final String name;
  final String icon;
  final int hp;
  final int power;
  final int shield;
  final String desc;
  final String skillName;
  final String skillDesc;
  final String passiveName;
  final String passiveDesc;

  const ClassConfig({
    required this.id,
    required this.name,
    required this.icon,
    required this.hp,
    required this.power,
    required this.shield,
    required this.desc,
    required this.skillName,
    required this.skillDesc,
    required this.passiveName,
    required this.passiveDesc,
  });
}

class ShopItem {
  final String id;
  final String name;
  final String type; // 'stat' | 'heal' | 'relic' | 'key'
  final int value;
  final int cost;
  final String icon;
  final String desc;
  bool isSold;

  ShopItem({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.cost,
    required this.icon,
    required this.desc,
    this.isSold = false,
  });
}

class RelicConfig {
  final String id;
  final String name;
  final String icon;
  final String desc;
  final int cost;

  const RelicConfig({
    required this.id,
    required this.name,
    required this.icon,
    required this.desc,
    required this.cost,
  });
}

class Achievement {
  final String id;
  final String name;
  final String desc;
  final String icon;
  final int targetValue; // e.g., 100 kills
  final String type; // 'kill', 'gold', 'floor', 'death'

  const Achievement({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.targetValue,
    required this.type,
  });
}

class FloatingTextData {
  final int id;
  final double x;
  final double y;
  final String text;
  final String color; // Hex string or identifier

  FloatingTextData({
    required this.id,
    required this.x,
    required this.y,
    required this.text,
    required this.color,
  });
}
