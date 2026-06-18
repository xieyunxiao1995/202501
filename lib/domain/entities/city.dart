/// 主城实体
///
/// 表示玩家的主城，包含建筑和资源信息。
/// 主城等级决定了可建造的建筑数量和类型。
class City {
  /// 主城唯一标识
  final String id;

  /// 主城等级
  final int level;

  /// 已建造的建筑 ID 列表
  final List<String> buildingIds;

  /// 资源储备（资源类型名称 -> 数量）
  final Map<String, int> resources;

  const City({
    required this.id,
    this.level = 1,
    this.buildingIds = const [],
    this.resources = const {},
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as String,
      level: (json['level'] as num?)?.toInt() ?? 1,
      buildingIds: (json['buildingIds'] as List<dynamic>? ?? json['building_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      resources: (json['resources'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          const {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'buildingIds': buildingIds,
        'resources': resources,
      };

  City copyWith({
    String? id,
    int? level,
    List<String>? buildingIds,
    Map<String, int>? resources,
  }) {
    return City(
      id: id ?? this.id,
      level: level ?? this.level,
      buildingIds: buildingIds ?? this.buildingIds,
      resources: resources ?? this.resources,
    );
  }
}

