/// 专属兵器实体
///
/// 表示武将的专属兵器，绑定特定武将使用。
/// 专属兵器拥有比普通装备更强的属性加成和特殊效果。
class Weapon {
  /// 兵器唯一标识
  final String id;

  /// 兵器名称
  final String name;

  /// 绑定武将 ID
  final String generalId;

  /// 攻击加成
  final int atkBonus;

  /// 防御加成
  final int defBonus;

  /// 生命加成
  final int hpBonus;

  /// 速度加成
  final int spdBonus;

  /// 兵器等级
  final int level;

  /// 兵器最大等级
  final int maxLevel;

  /// 特殊效果描述
  final String? specialEffect;

  const Weapon({
    required this.id,
    required this.name,
    required this.generalId,
    this.atkBonus = 0,
    this.defBonus = 0,
    this.hpBonus = 0,
    this.spdBonus = 0,
    this.level = 1,
    this.maxLevel = 30,
    this.specialEffect,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      id: json['id'] as String,
      name: json['name'] as String,
      generalId: json['generalId'] as String? ?? json['general_id'] as String,
      atkBonus: (json['atkBonus'] as num? ?? json['atk_bonus'] as num?)?.toInt() ?? 0,
      defBonus: (json['defBonus'] as num? ?? json['def_bonus'] as num?)?.toInt() ?? 0,
      hpBonus: (json['hpBonus'] as num? ?? json['hp_bonus'] as num?)?.toInt() ?? 0,
      spdBonus: (json['spdBonus'] as num? ?? json['spd_bonus'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      maxLevel: (json['maxLevel'] as num? ?? json['max_level'] as num?)?.toInt() ?? 30,
      specialEffect: json['specialEffect'] as String? ?? json['special_effect'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'generalId': generalId,
        'atkBonus': atkBonus,
        'defBonus': defBonus,
        'hpBonus': hpBonus,
        'spdBonus': spdBonus,
        'level': level,
        'maxLevel': maxLevel,
        'specialEffect': specialEffect,
      };

  Weapon copyWith({
    String? id,
    String? name,
    String? generalId,
    int? atkBonus,
    int? defBonus,
    int? hpBonus,
    int? spdBonus,
    int? level,
    int? maxLevel,
    String? specialEffect,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      generalId: generalId ?? this.generalId,
      atkBonus: atkBonus ?? this.atkBonus,
      defBonus: defBonus ?? this.defBonus,
      hpBonus: hpBonus ?? this.hpBonus,
      spdBonus: spdBonus ?? this.spdBonus,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      specialEffect: specialEffect ?? this.specialEffect,
    );
  }
}
