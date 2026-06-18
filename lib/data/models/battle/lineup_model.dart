/// 出战阵容数据模型（DTO）
///
/// 表示一个出战阵容配置，包含阵容名称、武将列表、阵法关联和羁绊效果。
class LineupModel {
  /// 阵容唯一标识
  final String id;

  /// 阵容名称
  final String name;

  /// 武将 ID 列表（最多3位）
  final List<String> generalIds;

  /// 关联阵法 ID
  final String? formationId;

  /// 羁绊 ID 列表
  final List<String> bondIds;

  const LineupModel({
    required this.id,
    required this.name,
    this.generalIds = const [],
    this.formationId,
    this.bondIds = const [],
  });

  factory LineupModel.fromJson(Map<String, dynamic> json) {
    return LineupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      generalIds: (json['generalIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
      formationId: json['formationId'] as String?,
      bondIds: (json['bondIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'generalIds': generalIds,
        if (formationId != null) 'formationId': formationId,
        'bondIds': bondIds,
      };

  LineupModel copyWith({
    String? id,
    String? name,
    List<String>? generalIds,
    String? formationId,
    List<String>? bondIds,
  }) {
    return LineupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      generalIds: generalIds ?? this.generalIds,
      formationId: formationId ?? this.formationId,
      bondIds: bondIds ?? this.bondIds,
    );
  }
}
