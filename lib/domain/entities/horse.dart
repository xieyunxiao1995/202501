import '../../shared/enums/rarity.dart' as enums;

/// 战马实体
///
/// 表示武将可骑乘的战马，提供属性加成和特殊技能。
/// 战马的稀有度决定了其属性上限和技能强度。
class Horse {
  /// 战马唯一标识
  final String id;

  /// 战马名称
  final String name;

  /// 稀有度
  final enums.Rarity rarity;

  /// 攻击加成
  final int atkBonus;

  /// 防御加成
  final int defBonus;

  /// 生命加成
  final int hpBonus;

  /// 速度加成
  final int spdBonus;

  /// 特殊技能描述
  final String? specialSkill;

  const Horse({
    required this.id,
    required this.name,
    required this.rarity,
    this.atkBonus = 0,
    this.defBonus = 0,
    this.hpBonus = 0,
    this.spdBonus = 0,
    this.specialSkill,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['id'] as String,
      name: json['name'] as String,
      rarity: json['rarity'] != null
          ? enums.Rarity.fromJson(json['rarity'] as String)
          : enums.Rarity.n,
      atkBonus: (json['atkBonus'] as num? ?? json['atk_bonus'] as num?)?.toInt() ?? 0,
      defBonus: (json['defBonus'] as num? ?? json['def_bonus'] as num?)?.toInt() ?? 0,
      hpBonus: (json['hpBonus'] as num? ?? json['hp_bonus'] as num?)?.toInt() ?? 0,
      spdBonus: (json['spdBonus'] as num? ?? json['spd_bonus'] as num?)?.toInt() ?? 0,
      specialSkill: json['specialSkill'] as String? ?? json['special_skill'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rarity': rarity.toJson(),
        'atkBonus': atkBonus,
        'defBonus': defBonus,
        'hpBonus': hpBonus,
        'spdBonus': spdBonus,
        'specialSkill': specialSkill,
      };

  Horse copyWith({
    String? id,
    String? name,
    enums.Rarity? rarity,
    int? atkBonus,
    int? defBonus,
    int? hpBonus,
    int? spdBonus,
    String? specialSkill,
  }) {
    return Horse(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      atkBonus: atkBonus ?? this.atkBonus,
      defBonus: defBonus ?? this.defBonus,
      hpBonus: hpBonus ?? this.hpBonus,
      spdBonus: spdBonus ?? this.spdBonus,
      specialSkill: specialSkill ?? this.specialSkill,
    );
  }
}

