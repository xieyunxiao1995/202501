import 'dart:math';
import '../core/constants.dart';

class BeastStats {
  int hp;
  int atk;
  int def;
  int spd;

  BeastStats({
    required this.hp,
    required this.atk,
    required this.def,
    required this.spd,
  });

  Map<String, dynamic> toJson() => {
    'hp': hp,
    'atk': atk,
    'def': def,
    'spd': spd,
  };

  factory BeastStats.fromJson(Map<String, dynamic> json) => BeastStats(
    hp: json['hp'] ?? 100,
    atk: json['atk'] ?? 10, // 修复：去掉了引号
    def: json['def'] ?? 10, // 修复：去掉了引号
    spd: json['spd'] ?? 10, // 修复：去掉了引号
  );

  BeastStats copyWith({int? hp, int? atk, int? def, int? spd}) => BeastStats(
    hp: hp ?? this.hp,
    atk: atk ?? this.atk,
    def: def ?? this.def,
    spd: spd ?? this.spd,
  );

  // 计算总战力评分
  int get totalScore => hp + (atk * 5) + (def * 3) + (spd * 2);
}

class Beast {
  final String id;
  String name;
  String tier;
  final List<String> parts;
  final BeastStats stats;
  bool isLocked; // 新增：锁定状态
  String? description; // 新增：描述文本

  Beast({
    required this.id,
    required this.name,
    required this.tier,
    required this.parts,
    required this.stats,
    this.isLocked = false,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tier': tier,
    'parts': parts,
    'stats': stats.toJson(),
    'isLocked': isLocked,
    'description': description,
  };

  factory Beast.fromJson(Map<String, dynamic> json) => Beast(
    id: json['id'],
    name: json['name'],
    tier: json['tier'],
    parts: List<String>.from(json['parts']),
    stats: BeastStats.fromJson(json['stats']),
    isLocked: json['isLocked'] ?? false,
    description: json['description'],
  );

  static Beast generateRandom({String? name, String? tier}) {
    final random = Random();
    final finalName = name ?? beastNames[random.nextInt(beastNames.length)];
    final finalTier =
        tier ??
        (random.nextDouble() < 0.05
            ? "万年"
            : random.nextDouble() < 0.2
            ? "千年"
            : "百年");
    final multiplier = finalTier == "万年"
        ? 5.0
        : (finalTier == "千年" ? 2.5 : 1.0);

    return Beast(
      id:
          DateTime.now().millisecondsSinceEpoch.toString() +
          random.nextInt(1000).toString(),
      name: finalName,
      tier: finalTier,
      parts: [beastParts[random.nextInt(beastParts.length)]],
      stats: BeastStats(
        hp: (80 + random.nextInt(40) * multiplier).toInt(),
        atk: (15 + random.nextInt(15) * multiplier).toInt(),
        def: (10 + random.nextInt(10) * multiplier).toInt(),
        spd: (10 + random.nextInt(20) * multiplier).toInt(),
      ),
      description: "产自大荒深处的神秘异兽，周身散发着${finalTier}的气息。",
      isLocked: false,
    );
  }
}
