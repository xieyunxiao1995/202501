/// 阵营枚举
enum FactionType {
  fire,
  water,
  wind,
  light,
  dark,
}

/// 阵营数据类
class Faction {
  final FactionType type;
  final String name;
  final String color;
  final String bg;

  const Faction({
    required this.type,
    required this.name,
    required this.color,
    required this.bg,
  });

  static const FIRE = Faction(
    type: FactionType.fire,
    name: '炎',
    color: 'text-red-500',
    bg: 'bg-red-500',
  );

  static const WATER = Faction(
    type: FactionType.water,
    name: '水',
    color: 'text-blue-500',
    bg: 'bg-blue-500',
  );

  static const WIND = Faction(
    type: FactionType.wind,
    name: '風',
    color: 'text-green-500',
    bg: 'bg-green-500',
  );

  static const LIGHT = Faction(
    type: FactionType.light,
    name: '光',
    color: 'text-yellow-500',
    bg: 'bg-yellow-500',
  );

  static const DARK = Faction(
    type: FactionType.dark,
    name: '闇',
    color: 'text-purple-500',
    bg: 'bg-purple-500',
  );

  static const VALUES = [FIRE, WATER, WIND, LIGHT, DARK];
}
