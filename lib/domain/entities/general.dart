import '../../shared/enums/kingdom.dart' as enums;
import '../../shared/enums/profession.dart' as enums;
import '../../shared/enums/rarity.dart' as enums;

/// 武将实体
///
/// 表示游戏中的武将角色，包含基础属性、阵营、职业、稀有度等信息。
/// 武将是战斗的核心单位，可装备兵器、战马，拥有技能和计谋。
class General {
  /// 武将唯一标识
  final String id;

  /// 武将名称
  final String name;

  /// 所属阵营（魏/蜀/吴/群/晋/女将）
  final enums.Kingdom kingdom;

  /// 职业类型（猛将/守将/武圣/刺客/军师/辅助/奇谋）
  final enums.Profession profession;

  /// 稀有度（普通/稀有/史诗/传说/至尊/绝世）
  final enums.Rarity rarity;

  /// 星级（1-7）
  final int star;

  /// 等级
  final int level;

  /// 攻击力
  final int atk;

  /// 防御力
  final int def;

  /// 生命值
  final int hp;

  /// 速度
  final int spd;

  /// 技能 ID 列表
  final List<String> skillIds;

  /// 计谋 ID
  final String? tacticId;

  /// 装备 ID
  final String? equipmentId;

  /// 专属兵器 ID
  final String? weaponId;

  /// 战马 ID
  final String? horseId;

  /// 羁绊 ID 列表
  final List<String> bondIds;

  /// 是否已觉醒
  final bool isAwakened;

  /// 战力值
  final int power;

  const General({
    required this.id,
    required this.name,
    required this.kingdom,
    required this.profession,
    required this.rarity,
    this.star = 1,
    this.level = 1,
    this.atk = 0,
    this.def = 0,
    this.hp = 0,
    this.spd = 0,
    this.skillIds = const [],
    this.tacticId,
    this.equipmentId,
    this.weaponId,
    this.horseId,
    this.bondIds = const [],
    this.isAwakened = false,
    this.power = 0,
  });

  factory General.fromJson(Map<String, dynamic> json) {
    return General(
      id: json['id'] as String,
      name: json['name'] as String,
      kingdom: json['kingdom'] != null
          ? enums.Kingdom.fromJson(json['kingdom'] as String)
          : enums.Kingdom.wei,
      profession: json['profession'] != null
          ? enums.Profession.fromJson(json['profession'] as String)
          : enums.Profession.berserker,
      rarity: json['rarity'] != null
          ? enums.Rarity.fromJson(json['rarity'] as String)
          : enums.Rarity.n,
      star: (json['star'] as num?)?.toInt() ?? 1,
      level: (json['level'] as num?)?.toInt() ?? 1,
      atk: (json['atk'] as num?)?.toInt() ?? 0,
      def: (json['def'] as num?)?.toInt() ?? 0,
      hp: (json['hp'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
      skillIds: (json['skillIds'] as List<dynamic>? ?? json['skill_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tacticId: json['tacticId'] as String? ?? json['tactic_id'] as String?,
      equipmentId: json['equipmentId'] as String? ?? json['equipment_id'] as String?,
      weaponId: json['weaponId'] as String? ?? json['weapon_id'] as String?,
      horseId: json['horseId'] as String? ?? json['horse_id'] as String?,
      bondIds: (json['bondIds'] as List<dynamic>? ?? json['bond_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAwakened: json['isAwakened'] as bool? ?? json['is_awakened'] as bool? ?? false,
      power: (json['power'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kingdom': kingdom.toJson(),
        'profession': profession.toJson(),
        'rarity': rarity.toJson(),
        'star': star,
        'level': level,
        'atk': atk,
        'def': def,
        'hp': hp,
        'spd': spd,
        'skillIds': skillIds,
        'tacticId': tacticId,
        'equipmentId': equipmentId,
        'weaponId': weaponId,
        'horseId': horseId,
        'bondIds': bondIds,
        'isAwakened': isAwakened,
        'power': power,
      };

  General copyWith({
    String? id,
    String? name,
    enums.Kingdom? kingdom,
    enums.Profession? profession,
    enums.Rarity? rarity,
    int? star,
    int? level,
    int? atk,
    int? def,
    int? hp,
    int? spd,
    List<String>? skillIds,
    String? tacticId,
    String? equipmentId,
    String? weaponId,
    String? horseId,
    List<String>? bondIds,
    bool? isAwakened,
    int? power,
  }) {
    return General(
      id: id ?? this.id,
      name: name ?? this.name,
      kingdom: kingdom ?? this.kingdom,
      profession: profession ?? this.profession,
      rarity: rarity ?? this.rarity,
      star: star ?? this.star,
      level: level ?? this.level,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      hp: hp ?? this.hp,
      spd: spd ?? this.spd,
      skillIds: skillIds ?? this.skillIds,
      tacticId: tacticId ?? this.tacticId,
      equipmentId: equipmentId ?? this.equipmentId,
      weaponId: weaponId ?? this.weaponId,
      horseId: horseId ?? this.horseId,
      bondIds: bondIds ?? this.bondIds,
      isAwakened: isAwakened ?? this.isAwakened,
      power: power ?? this.power,
    );
  }
}

