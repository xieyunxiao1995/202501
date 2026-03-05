/// 稀有度枚举
enum RarityType {
  R,
  SR,
  SSR,
  UR,
}

/// 稀有度数据类
class Rarity {
  final RarityType type;
  final String name;
  final String color;
  final String border;
  final String bg;
  final double probability;

  const Rarity({
    required this.type,
    required this.name,
    required this.color,
    required this.border,
    required this.bg,
    required this.probability,
  });

  static const R = Rarity(
    type: RarityType.R,
    name: 'R',
    color: 'text-blue-500',
    border: 'border-blue-500',
    bg: 'bg-blue-100',
    probability: 0.5,
  );

  static const SR = Rarity(
    type: RarityType.SR,
    name: 'SR',
    color: 'text-purple-500',
    border: 'border-purple-500',
    bg: 'bg-purple-100',
    probability: 0.432,
  );

  static const SSR = Rarity(
    type: RarityType.SSR,
    name: 'SSR',
    color: 'text-orange-500',
    border: 'border-orange-500',
    bg: 'bg-orange-100',
    probability: 0.06,
  );

  static const UR = Rarity(
    type: RarityType.UR,
    name: 'UR',
    color: 'text-red-600',
    border: 'border-red-600',
    bg: 'bg-red-100',
    probability: 0.008,
  );

  static const VALUES = [R, SR, SSR, UR];
}
