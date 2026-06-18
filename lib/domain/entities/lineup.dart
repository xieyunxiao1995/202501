/// 阵容实体
///
/// 表示战斗阵容配置，由武将列表、阵法和羁绊组成。
/// 阵容决定了战斗中武将的站位和配合效果。
class Lineup {
  /// 阵容唯一标识
  final String id;

  /// 阵容名称
  final String name;

  /// 武将 ID 列表（最多 6 位武将）
  final List<String> generalIds;

  /// 使用的阵法 ID
  final String? formationId;

  /// 激活的羁绊 ID 列表
  final List<String> bondIds;

  const Lineup({
    required this.id,
    required this.name,
    this.generalIds = const [],
    this.formationId,
    this.bondIds = const [],
  });

  factory Lineup.fromJson(Map<String, dynamic> json) {
    return Lineup(
      id: json['id'] as String,
      name: json['name'] as String,
      generalIds: (json['generalIds'] as List<dynamic>? ?? json['general_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      formationId: json['formationId'] as String? ?? json['formation_id'] as String?,
      bondIds: (json['bondIds'] as List<dynamic>? ?? json['bond_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'generalIds': generalIds,
        'formationId': formationId,
        'bondIds': bondIds,
      };

  Lineup copyWith({
    String? id,
    String? name,
    List<String>? generalIds,
    String? formationId,
    List<String>? bondIds,
  }) {
    return Lineup(
      id: id ?? this.id,
      name: name ?? this.name,
      generalIds: generalIds ?? this.generalIds,
      formationId: formationId ?? this.formationId,
      bondIds: bondIds ?? this.bondIds,
    );
  }
}
