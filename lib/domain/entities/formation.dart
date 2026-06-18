import '../../shared/enums/formation_type.dart' as enums;

/// 阵法实体
///
/// 表示战斗中的阵法配置，不同阵法提供不同位置的属性加成。
/// 阵法类型决定了加成的分布方式，影响战斗策略。
class Formation {
  /// 阵法唯一标识
  final String id;

  /// 阵法类型（长蛇阵/双龙出水阵/三才阵/四象阵/五行阵/六合阵/七星阵/八卦阵/九宫阵）
  final enums.FormationType type;

  /// 阵法名称
  final String name;

  /// 阵法描述
  final String description;

  /// 各位置加成（位置索引 -> 攻击/防御/速度加成）
  final Map<int, PositionBonus> positionBonuses;

  const Formation({
    required this.id,
    required this.type,
    required this.name,
    this.description = '',
    this.positionBonuses = const {},
  });

  factory Formation.fromJson(Map<String, dynamic> json) {
    final pbRaw = json['positionBonuses'] as Map<String, dynamic>? ??
        json['position_bonuses'] as Map<String, dynamic>?;
    final Map<int, PositionBonus> positionBonuses = pbRaw?.map(
          (k, v) => MapEntry(
            int.parse(k),
            PositionBonus.fromJson(v as Map<String, dynamic>),
          ),
        ) ??
        const {};

    return Formation(
      id: json['id'] as String,
      type: json['type'] != null
          ? enums.FormationType.fromJson(json['type'] as String)
          : enums.FormationType.longSnake,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      positionBonuses: positionBonuses,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toJson(),
        'name': name,
        'description': description,
        'positionBonuses':
            positionBonuses.map((k, v) => MapEntry(k.toString(), v.toJson())),
      };

  Formation copyWith({
    String? id,
    enums.FormationType? type,
    String? name,
    String? description,
    Map<int, PositionBonus>? positionBonuses,
  }) {
    return Formation(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      positionBonuses: positionBonuses ?? this.positionBonuses,
    );
  }
}

/// 位置加成
///
/// 表示阵法中某一位置的属性加成值。
class PositionBonus {
  /// 攻击加成
  final int atk;

  /// 防御加成
  final int def;

  /// 速度加成
  final int spd;

  const PositionBonus({
    this.atk = 0,
    this.def = 0,
    this.spd = 0,
  });

  factory PositionBonus.fromJson(Map<String, dynamic> json) {
    return PositionBonus(
      atk: (json['atk'] as num?)?.toInt() ?? 0,
      def: (json['def'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'atk': atk,
        'def': def,
        'spd': spd,
      };

  PositionBonus copyWith({
    int? atk,
    int? def,
    int? spd,
  }) {
    return PositionBonus(
      atk: atk ?? this.atk,
      def: def ?? this.def,
      spd: spd ?? this.spd,
    );
  }
}

