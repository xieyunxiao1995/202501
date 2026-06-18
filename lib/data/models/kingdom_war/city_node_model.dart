/// 城池节点数据模型（DTO）
///
/// 表示国战地图上的一个城池节点，包含城池归属、防御和驻军信息。
class CityNodeModel {
  /// 城池唯一标识
  final String id;

  /// 城池名称
  final String name;

  /// 当前归属阵营（neutral/wei/shu/wu）
  final String owner;

  /// 城池等级
  final int level;

  /// 防御值
  final int defense;

  /// 驻军武将 ID 列表
  final List<String> garrisonGeneralIds;

  /// 相邻城池 ID 列表
  final List<String> adjacentCityIds;

  /// 坐标 X
  final int posX;

  /// 坐标 Y
  final int posY;

  const CityNodeModel({
    required this.id,
    required this.name,
    this.owner = 'neutral',
    this.level = 1,
    this.defense = 100,
    this.garrisonGeneralIds = const [],
    this.adjacentCityIds = const [],
    this.posX = 0,
    this.posY = 0,
  });

  factory CityNodeModel.fromJson(Map<String, dynamic> json) {
    return CityNodeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      owner: json['owner'] as String? ?? 'neutral',
      level: (json['level'] as num?)?.toInt() ?? 1,
      defense: (json['defense'] as num?)?.toInt() ?? 100,
      garrisonGeneralIds: (json['garrison_general_ids'] as List<dynamic>? ?? json['garrisonGeneralIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ?? const [],
      adjacentCityIds: (json['adjacent_city_ids'] as List<dynamic>? ?? json['adjacentCityIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ?? const [],
      posX: (json['pos_x'] as num?)?.toInt() ?? (json['posX'] as num?)?.toInt() ?? 0,
      posY: (json['pos_y'] as num?)?.toInt() ?? (json['posY'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'owner': owner,
        'level': level,
        'defense': defense,
        'garrison_general_ids': garrisonGeneralIds,
        'adjacent_city_ids': adjacentCityIds,
        'pos_x': posX,
        'pos_y': posY,
      };

  CityNodeModel copyWith({
    String? id,
    String? name,
    String? owner,
    int? level,
    int? defense,
    List<String>? garrisonGeneralIds,
    List<String>? adjacentCityIds,
    int? posX,
    int? posY,
  }) {
    return CityNodeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      level: level ?? this.level,
      defense: defense ?? this.defense,
      garrisonGeneralIds: garrisonGeneralIds ?? this.garrisonGeneralIds,
      adjacentCityIds: adjacentCityIds ?? this.adjacentCityIds,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
    );
  }
}
