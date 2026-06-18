/// 武将数据模型（DTO）
///
/// 对应 [General] 实体，面向 API 契约的武将数据传输对象。
/// 包含武将基础属性、阵营、职业、稀有度、星级、等级、战斗属性等。
class GeneralModel {
  /// 武将唯一标识
  final String id;

  /// 武将名称
  final String name;

  /// 所属阵营标识（wei/shu/wu/qun/jin/female）
  final String kingdom;

  /// 职业标识（berserker/guardian/warSage/assassin/strategist/support/trickster）
  final String profession;

  /// 稀有度标识（n/r/sr/ssr/ur/legendary）
  final String rarity;

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

  /// 是否已觉醒
  final bool isAwakened;

  /// 战力值
  final int power;

  const GeneralModel({
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
    this.isAwakened = false,
    this.power = 0,
  });

  factory GeneralModel.fromJson(Map<String, dynamic> json) {
    return GeneralModel(
      id: json['id'] as String,
      name: json['name'] as String,
      kingdom: json['kingdom'] as String,
      profession: json['profession'] as String,
      rarity: json['rarity'] as String,
      star: (json['star'] as num?)?.toInt() ?? 1,
      level: (json['level'] as num?)?.toInt() ?? 1,
      atk: (json['atk'] as num?)?.toInt() ?? 0,
      def: (json['def'] as num?)?.toInt() ?? 0,
      hp: (json['hp'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
      skillIds: (json['skillIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tacticId: json['tacticId'] as String?,
      isAwakened: json['isAwakened'] as bool? ?? false,
      power: (json['power'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kingdom': kingdom,
      'profession': profession,
      'rarity': rarity,
      'star': star,
      'level': level,
      'atk': atk,
      'def': def,
      'hp': hp,
      'spd': spd,
      'skillIds': skillIds,
      'tacticId': tacticId,
      'isAwakened': isAwakened,
      'power': power,
    };
  }

  GeneralModel copyWith({
    String? id,
    String? name,
    String? kingdom,
    String? profession,
    String? rarity,
    int? star,
    int? level,
    int? atk,
    int? def,
    int? hp,
    int? spd,
    List<String>? skillIds,
    String? tacticId,
    bool? isAwakened,
    int? power,
  }) {
    return GeneralModel(
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
      isAwakened: isAwakened ?? this.isAwakened,
      power: power ?? this.power,
    );
  }
}
