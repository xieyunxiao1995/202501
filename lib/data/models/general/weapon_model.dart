/// 专属兵器数据模型（DTO）
///
/// 表示武将专属兵器数据，关联特定武将，包含属性加成和特殊效果。
class WeaponModel {
  /// 兵器唯一标识
  final String id;

  /// 兵器名称
  final String name;

  /// 所属武将 ID
  final String generalId;

  /// 攻击力加成
  final int atk;

  /// 防御力加成
  final int def;

  /// 生命值加成
  final int hp;

  /// 速度加成
  final int spd;

  /// 兵器等级
  final int level;

  /// 特殊效果描述
  final String? specialEffect;

  const WeaponModel({
    required this.id,
    required this.name,
    required this.generalId,
    this.atk = 0,
    this.def = 0,
    this.hp = 0,
    this.spd = 0,
    this.level = 1,
    this.specialEffect,
  });

  factory WeaponModel.fromJson(Map<String, dynamic> json) {
    return WeaponModel(
      id: json['id'] as String,
      name: json['name'] as String,
      generalId: json['generalId'] as String,
      atk: (json['atk'] as num?)?.toInt() ?? 0,
      def: (json['def'] as num?)?.toInt() ?? 0,
      hp: (json['hp'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      specialEffect: json['specialEffect'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generalId': generalId,
      'atk': atk,
      'def': def,
      'hp': hp,
      'spd': spd,
      'level': level,
      'specialEffect': specialEffect,
    };
  }

  WeaponModel copyWith({
    String? id,
    String? name,
    String? generalId,
    int? atk,
    int? def,
    int? hp,
    int? spd,
    int? level,
    String? specialEffect,
  }) {
    return WeaponModel(
      id: id ?? this.id,
      name: name ?? this.name,
      generalId: generalId ?? this.generalId,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      hp: hp ?? this.hp,
      spd: spd ?? this.spd,
      level: level ?? this.level,
      specialEffect: specialEffect ?? this.specialEffect,
    );
  }
}
