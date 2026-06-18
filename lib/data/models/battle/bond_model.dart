/// 羁绊数据模型（DTO）
///
/// 表示武将之间的羁绊效果配置，包含所需武将、属性加成和描述。
class BondModel {
  /// 羁绊唯一标识
  final String id;

  /// 羁绊名称
  final String name;

  /// 羁绊类型标识
  final String type;

  /// 所需武将 ID 列表
  final List<String> requiredGeneralIds;

  /// 攻击加成
  final int atk;

  /// 防御加成
  final int def;

  /// 生命加成
  final int hp;

  /// 羁绊描述
  final String? description;

  const BondModel({
    required this.id,
    required this.name,
    required this.type,
    this.requiredGeneralIds = const [],
    this.atk = 0,
    this.def = 0,
    this.hp = 0,
    this.description,
  });

  factory BondModel.fromJson(Map<String, dynamic> json) {
    return BondModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      requiredGeneralIds: (json['requiredGeneralIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
      atk: (json['atk'] as num?)?.toInt() ?? 0,
      def: (json['def'] as num?)?.toInt() ?? 0,
      hp: (json['hp'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'requiredGeneralIds': requiredGeneralIds,
        'atk': atk,
        'def': def,
        'hp': hp,
        if (description != null) 'description': description,
      };

  BondModel copyWith({
    String? id,
    String? name,
    String? type,
    List<String>? requiredGeneralIds,
    int? atk,
    int? def,
    int? hp,
    String? description,
  }) {
    return BondModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      requiredGeneralIds: requiredGeneralIds ?? this.requiredGeneralIds,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      hp: hp ?? this.hp,
      description: description ?? this.description,
    );
  }
}
