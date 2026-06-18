/// 战马数据模型（DTO）
///
/// 表示武将可骑乘的战马数据，包含稀有度、属性加成和特殊技能。
class HorseModel {
  /// 战马唯一标识
  final String id;

  /// 战马名称
  final String name;

  /// 稀有度标识
  final String rarity;

  /// 攻击力加成
  final int atk;

  /// 防御力加成
  final int def;

  /// 生命值加成
  final int hp;

  /// 速度加成
  final int spd;

  /// 特殊技能描述
  final String? specialSkill;

  const HorseModel({
    required this.id,
    required this.name,
    required this.rarity,
    this.atk = 0,
    this.def = 0,
    this.hp = 0,
    this.spd = 0,
    this.specialSkill,
  });

  factory HorseModel.fromJson(Map<String, dynamic> json) {
    return HorseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rarity: json['rarity'] as String,
      atk: (json['atk'] as num?)?.toInt() ?? 0,
      def: (json['def'] as num?)?.toInt() ?? 0,
      hp: (json['hp'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
      specialSkill: json['specialSkill'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rarity': rarity,
      'atk': atk,
      'def': def,
      'hp': hp,
      'spd': spd,
      'specialSkill': specialSkill,
    };
  }

  HorseModel copyWith({
    String? id,
    String? name,
    String? rarity,
    int? atk,
    int? def,
    int? hp,
    int? spd,
    String? specialSkill,
  }) {
    return HorseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      hp: hp ?? this.hp,
      spd: spd ?? this.spd,
      specialSkill: specialSkill ?? this.specialSkill,
    );
  }
}
