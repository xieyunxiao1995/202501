/// 试炼之塔层数据模型（DTO）
///
/// 表示试炼之塔中某一层的配置，包含层数、敌人和奖励信息。
class TowerFloorModel {
  /// 层唯一标识
  final String id;

  /// 层数
  final int floor;

  /// 敌方武将 ID 列表
  final List<String> enemyGeneralIds;

  /// 推荐战力
  final int recommendedPower;

  /// 通关奖励（物品ID -> 数量）
  final Map<String, int> rewards;

  /// 是否已通关
  final bool cleared;

  const TowerFloorModel({
    required this.id,
    required this.floor,
    this.enemyGeneralIds = const [],
    this.recommendedPower = 0,
    this.rewards = const {},
    this.cleared = false,
  });

  factory TowerFloorModel.fromJson(Map<String, dynamic> json) {
    return TowerFloorModel(
      id: json['id'] as String,
      floor: (json['floor'] as num?)?.toInt() ?? 0,
      enemyGeneralIds: (json['enemy_general_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendedPower: (json['recommended_power'] as num?)?.toInt() ?? (json['recommendedPower'] as num?)?.toInt() ?? 0,
      rewards: (json['rewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      cleared: json['cleared'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'floor': floor,
        'enemy_general_ids': enemyGeneralIds,
        'recommended_power': recommendedPower,
        'rewards': rewards,
        'cleared': cleared,
      };

  TowerFloorModel copyWith({
    String? id,
    int? floor,
    List<String>? enemyGeneralIds,
    int? recommendedPower,
    Map<String, int>? rewards,
    bool? cleared,
  }) {
    return TowerFloorModel(
      id: id ?? this.id,
      floor: floor ?? this.floor,
      enemyGeneralIds: enemyGeneralIds ?? this.enemyGeneralIds,
      recommendedPower: recommendedPower ?? this.recommendedPower,
      rewards: rewards ?? this.rewards,
      cleared: cleared ?? this.cleared,
    );
  }
}
