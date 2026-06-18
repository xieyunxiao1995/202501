/// 关卡数据模型（DTO）
///
/// 表示游戏中的单个关卡配置，包含关卡名称、难度、敌人和奖励等信息。
class StageModel {
  /// 关卡唯一标识
  final String id;

  /// 所属章节 ID
  final String chapterId;

  /// 关卡名称
  final String name;

  /// 难度等级
  final int difficulty;

  /// 敌方武将 ID 列表
  final List<String> enemyGeneralIds;

  /// 推荐战力
  final int recommendedPower;

  /// 通关奖励（物品ID -> 数量）
  final Map<String, int> rewards;

  /// 是否已通关
  final bool cleared;

  /// 是否已三星通关
  final bool threeStarred;

  const StageModel({
    required this.id,
    required this.chapterId,
    required this.name,
    this.difficulty = 1,
    this.enemyGeneralIds = const [],
    this.recommendedPower = 0,
    this.rewards = const {},
    this.cleared = false,
    this.threeStarred = false,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'] as String,
      chapterId: json['chapter_id'] as String? ?? (json['chapterId'] as String? ?? ''),
      name: json['name'] as String? ?? '',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      enemyGeneralIds: (json['enemy_general_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendedPower: (json['recommended_power'] as num?)?.toInt() ?? (json['recommendedPower'] as num?)?.toInt() ?? 0,
      rewards: (json['rewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      cleared: json['cleared'] as bool? ?? false,
      threeStarred: json['three_starred'] as bool? ?? (json['threeStarred'] as bool? ?? false),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapter_id': chapterId,
        'name': name,
        'difficulty': difficulty,
        'enemy_general_ids': enemyGeneralIds,
        'recommended_power': recommendedPower,
        'rewards': rewards,
        'cleared': cleared,
        'three_starred': threeStarred,
      };

  StageModel copyWith({
    String? id,
    String? chapterId,
    String? name,
    int? difficulty,
    List<String>? enemyGeneralIds,
    int? recommendedPower,
    Map<String, int>? rewards,
    bool? cleared,
    bool? threeStarred,
  }) {
    return StageModel(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      enemyGeneralIds: enemyGeneralIds ?? this.enemyGeneralIds,
      recommendedPower: recommendedPower ?? this.recommendedPower,
      rewards: rewards ?? this.rewards,
      cleared: cleared ?? this.cleared,
      threeStarred: threeStarred ?? this.threeStarred,
    );
  }
}
