import '../../shared/enums/item_type.dart' as enums;
import '../../shared/enums/rarity.dart' as enums;

/// 装备实体
///
/// 表示武将可穿戴的装备，提供攻击、防御、生命、速度等属性加成。
/// 装备可组成套装，获得额外效果。
class Equipment {
  /// 装备唯一标识
  final String id;

  /// 装备名称
  final String name;

  /// 道具类型
  final enums.ItemType type;

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

  /// 装备等级
  final int level;

  /// 套装描述
  final String? setDescription;

  const Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    this.atkBonus = 0,
    this.defBonus = 0,
    this.hpBonus = 0,
    this.spdBonus = 0,
    this.level = 1,
    this.setDescription,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] != null
          ? enums.ItemType.fromJson(json['type'] as String)
          : enums.ItemType.material,
      rarity: json['rarity'] != null
          ? enums.Rarity.fromJson(json['rarity'] as String)
          : enums.Rarity.n,
      atkBonus: (json['atkBonus'] as num? ?? json['atk_bonus'] as num?)?.toInt() ?? 0,
      defBonus: (json['defBonus'] as num? ?? json['def_bonus'] as num?)?.toInt() ?? 0,
      hpBonus: (json['hpBonus'] as num? ?? json['hp_bonus'] as num?)?.toInt() ?? 0,
      spdBonus: (json['spdBonus'] as num? ?? json['spd_bonus'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      setDescription: json['setDescription'] as String? ?? json['set_description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'rarity': rarity.toJson(),
        'atkBonus': atkBonus,
        'defBonus': defBonus,
        'hpBonus': hpBonus,
        'spdBonus': spdBonus,
        'level': level,
        'setDescription': setDescription,
      };

  Equipment copyWith({
    String? id,
    String? name,
    enums.ItemType? type,
    enums.Rarity? rarity,
    int? atkBonus,
    int? defBonus,
    int? hpBonus,
    int? spdBonus,
    int? level,
    String? setDescription,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      atkBonus: atkBonus ?? this.atkBonus,
      defBonus: defBonus ?? this.defBonus,
      hpBonus: hpBonus ?? this.hpBonus,
      spdBonus: spdBonus ?? this.spdBonus,
      level: level ?? this.level,
      setDescription: setDescription ?? this.setDescription,
    );
  }
}

