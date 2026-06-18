/// 经典战役数据模型（DTO）
///
/// 表示历史上的经典战役关卡，包含战役背景、参战武将和星级评价。
class ClassicBattleModel {
  /// 战役唯一标识
  final String id;

  /// 战役名称
  final String name;

  /// 战役背景描述
  final String? background;

  /// 敌方武将 ID 列表
  final List<String> enemyGeneralIds;

  /// 推荐战力
  final int recommendedPower;

  /// 获得星数（0-3）
  final int stars;

  /// 首次通关奖励
  final Map<String, int> firstClearRewards;

  /// 是否已通关
  final bool cleared;

  const ClassicBattleModel({
    required this.id,
    required this.name,
    this.background,
    this.enemyGeneralIds = const [],
    this.recommendedPower = 0,
    this.stars = 0,
    this.firstClearRewards = const {},
    this.cleared = false,
  });

  factory ClassicBattleModel.fromJson(Map<String, dynamic> json) {
    return ClassicBattleModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      background: json['background'] as String?,
      enemyGeneralIds: (json['enemy_general_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendedPower: (json['recommended_power'] as num?)?.toInt() ?? (json['recommendedPower'] as num?)?.toInt() ?? 0,
      stars: (json['stars'] as num?)?.toInt() ?? 0,
      firstClearRewards: (json['first_clear_rewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      cleared: json['cleared'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (background != null) 'background': background,
        'enemy_general_ids': enemyGeneralIds,
        'recommended_power': recommendedPower,
        'stars': stars,
        'first_clear_rewards': firstClearRewards,
        'cleared': cleared,
      };

  ClassicBattleModel copyWith({
    String? id,
    String? name,
    String? background,
    List<String>? enemyGeneralIds,
    int? recommendedPower,
    int? stars,
    Map<String, int>? firstClearRewards,
    bool? cleared,
  }) {
    return ClassicBattleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      background: background ?? this.background,
      enemyGeneralIds: enemyGeneralIds ?? this.enemyGeneralIds,
      recommendedPower: recommendedPower ?? this.recommendedPower,
      stars: stars ?? this.stars,
      firstClearRewards: firstClearRewards ?? this.firstClearRewards,
      cleared: cleared ?? this.cleared,
    );
  }
}
