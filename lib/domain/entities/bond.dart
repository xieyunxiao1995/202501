import '../../shared/enums/bond_type.dart' as enums;

/// 羁绊实体
///
/// 表示武将之间的羁绊关系，当阵容中同时上阵指定武将时激活。
/// 羁绊提供属性加成，类型涵盖桃园结义、五虎上将等经典组合。
class Bond {
  /// 羁绊唯一标识
  final String id;

  /// 羁绊名称
  final String name;

  /// 羁绊类型（桃园结义/五虎上将/五大谋士/龙凤呈祥/义结金兰/君臣之义/歃血为盟/师徒传承/亦敌亦友/血脉相连）
  final enums.BondType type;

  /// 触发所需的武将 ID 列表
  final List<String> requiredGeneralIds;

  /// 攻击加成
  final int atkBonus;

  /// 防御加成
  final int defBonus;

  /// 生命加成
  final int hpBonus;

  /// 羁绊描述
  final String description;

  const Bond({
    required this.id,
    required this.name,
    required this.type,
    this.requiredGeneralIds = const [],
    this.atkBonus = 0,
    this.defBonus = 0,
    this.hpBonus = 0,
    this.description = '',
  });

  factory Bond.fromJson(Map<String, dynamic> json) {
    return Bond(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] != null
          ? enums.BondType.fromJson(json['type'] as String)
          : enums.BondType.peachGarden,
      requiredGeneralIds: (json['requiredGeneralIds'] as List<dynamic>? ?? json['required_general_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      atkBonus: (json['atkBonus'] as num? ?? json['atk_bonus'] as num?)?.toInt() ?? 0,
      defBonus: (json['defBonus'] as num? ?? json['def_bonus'] as num?)?.toInt() ?? 0,
      hpBonus: (json['hpBonus'] as num? ?? json['hp_bonus'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'requiredGeneralIds': requiredGeneralIds,
        'atkBonus': atkBonus,
        'defBonus': defBonus,
        'hpBonus': hpBonus,
        'description': description,
      };

  Bond copyWith({
    String? id,
    String? name,
    enums.BondType? type,
    List<String>? requiredGeneralIds,
    int? atkBonus,
    int? defBonus,
    int? hpBonus,
    String? description,
  }) {
    return Bond(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      requiredGeneralIds: requiredGeneralIds ?? this.requiredGeneralIds,
      atkBonus: atkBonus ?? this.atkBonus,
      defBonus: defBonus ?? this.defBonus,
      hpBonus: hpBonus ?? this.hpBonus,
      description: description ?? this.description,
    );
  }
}

