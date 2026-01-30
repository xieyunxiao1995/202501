import '../core/constants.dart';

class TotemBlessing {
  final String id;
  final String name;
  final String desc;
  int level;
  int cost;
  final String icon;

  TotemBlessing({
    required this.id,
    required this.name,
    required this.desc,
    required this.level,
    required this.cost,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'desc': desc,
    'level': level,
    'cost': cost,
    'icon': icon,
  };

  factory TotemBlessing.fromJson(Map<String, dynamic> json) => TotemBlessing(
    id: json['id'],
    name: json['name'],
    desc: json['desc'],
    level: json['level'],
    cost: json['cost'],
    icon: json['icon'],
  );

  void upgrade() {
    level++;
    cost = (cost * 1.5).toInt();
  }

  double get effectValue {
    // 简单的数值加成逻辑，可以根据不同赐福类型调整
    return level * 0.05; // 每级 5%
  }
}

class TribeData {
  int level;
  List<TotemBlessing> blessings;

  TribeData({required this.level, required this.blessings});

  Map<String, dynamic> toJson() => {
    'level': level,
    'blessings': blessings.map((b) => b.toJson()).toList(),
  };

  factory TribeData.fromJson(Map<String, dynamic> json) => TribeData(
    level: json['level'] ?? 1,
    blessings:
        (json['blessings'] as List?)
            ?.map((item) => TotemBlessing.fromJson(item))
            .toList() ??
        [],
  );

  factory TribeData.initial() {
    return TribeData(
      level: 1,
      blessings: totems
          .map(
            (t) => TotemBlessing(
              id: t['id'],
              name: t['name'],
              desc: t['desc'],
              level: t['level'],
              cost: t['cost'],
              icon: t['icon'],
            ),
          )
          .toList(),
    );
  }

  int get upgradeCost => level * 1000;

  void upgradeLevel() {
    level++;
  }

  // 获取各种加成倍率
  double get attackBonus => 1.0 + _getEffectValue("1");
  double get spiritIncomeBonus => 1.0 + _getEffectValue("2") * 2; // 收益加成更高
  double get swallowSuccessBonus => _getEffectValue("3") * 0.4; // 成功率加成较小
  double get defenseBonus => 1.0 + _getEffectValue("4");
  double get speedBonus => 1.0 + _getEffectValue("5");
  double get mutationBonus => _getEffectValue("6") * 0.2; // 异变概率加成
  double get deathReduction => _getEffectValue("7") * 0.2; // 死亡概率减免

  double _getEffectValue(String id) {
    try {
      return blessings.firstWhere((b) => b.id == id).effectValue;
    } catch (_) {
      return 0.0;
    }
  }
}
