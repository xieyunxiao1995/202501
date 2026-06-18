/// 装备数据模型（DTO）
///
/// 表示武将可穿戴的装备数据，包含装备类型、稀有度和各项属性加成。
class EquipmentModel {
  /// 装备唯一标识
  final String id;

  /// 装备名称
  final String name;

  /// 装备类型标识
  final String type;

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

  /// 装备等级
  final int level;

  const EquipmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    this.atk = 0,
    this.def = 0,
    this.hp = 0,
    this.spd = 0,
    this.level = 1,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      rarity: json['rarity'] as String,
      atk: (json['atk'] as num?)?.toInt() ?? 0,
      def: (json['def'] as num?)?.toInt() ?? 0,
      hp: (json['hp'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'rarity': rarity,
      'atk': atk,
      'def': def,
      'hp': hp,
      'spd': spd,
      'level': level,
    };
  }

  EquipmentModel copyWith({
    String? id,
    String? name,
    String? type,
    String? rarity,
    int? atk,
    int? def,
    int? hp,
    int? spd,
    int? level,
  }) {
    return EquipmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      hp: hp ?? this.hp,
      spd: spd ?? this.spd,
      level: level ?? this.level,
    );
  }
}
