/// 主城数据模型（DTO）
///
/// 表示玩家主城的整体数据，包含主城名称、等级和建筑列表。
class CityModel {
  /// 主城唯一标识
  final String id;

  /// 主城名称
  final String name;

  /// 主城等级
  final int level;

  /// 建筑 ID 列表
  final List<String> buildingIds;

  const CityModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.buildingIds = const [],
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      level: (json['level'] as num?)?.toInt() ?? 1,
      buildingIds: (json['buildingIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'buildingIds': buildingIds,
      };

  CityModel copyWith({
    String? id,
    String? name,
    int? level,
    List<String>? buildingIds,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      buildingIds: buildingIds ?? this.buildingIds,
    );
  }
}
