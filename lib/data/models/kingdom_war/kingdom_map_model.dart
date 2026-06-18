/// 国战地图数据模型（DTO）
///
/// 表示国战中的全局地图数据，包含地图节点和城池信息。
class KingdomMapModel {
  /// 地图唯一标识
  final String id;

  /// 地图名称
  final String name;

  /// 城池节点 ID 列表
  final List<String> cityNodeIds;

  /// 赛季编号
  final int season;

  const KingdomMapModel({
    required this.id,
    required this.name,
    this.cityNodeIds = const [],
    required this.season,
  });

  factory KingdomMapModel.fromJson(Map<String, dynamic> json) {
    return KingdomMapModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cityNodeIds: (json['city_node_ids'] as List<dynamic>? ?? json['cityNodeIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ?? const [],
      season: (json['season'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city_node_ids': cityNodeIds,
        'season': season,
      };

  KingdomMapModel copyWith({
    String? id,
    String? name,
    List<String>? cityNodeIds,
    int? season,
  }) {
    return KingdomMapModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cityNodeIds: cityNodeIds ?? this.cityNodeIds,
      season: season ?? this.season,
    );
  }
}
