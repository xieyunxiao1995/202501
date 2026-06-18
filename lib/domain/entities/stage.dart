/// 关卡实体
///
/// 表示游戏中的闯关关卡，隶属于某一章节。
/// 关卡包含难度、等级要求、敌方阵容、通关奖励和星级评价等信息。
class Stage {
  /// 关卡唯一标识
  final String id;

  /// 所属章节 ID
  final String chapterId;

  /// 关卡名称
  final String name;

  /// 难度等级
  final int difficulty;

  /// 通关所需等级
  final int requiredLevel;

  /// 敌方阵容配置（武将 ID 列表）
  final List<String> enemyLineup;

  /// 通关奖励（道具 ID 到数量的映射）
  final Map<String, int> rewards;

  /// 是否已通关
  final bool isCleared;

  /// 星级评价（0-3）
  final int starCount;

  const Stage({
    required this.id,
    required this.chapterId,
    required this.name,
    this.difficulty = 1,
    this.requiredLevel = 1,
    this.enemyLineup = const [],
    this.rewards = const {},
    this.isCleared = false,
    this.starCount = 0,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String? ?? json['chapter_id'] as String,
      name: json['name'] as String,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      requiredLevel: (json['requiredLevel'] as num? ?? json['required_level'] as num?)?.toInt() ?? 1,
      enemyLineup: (json['enemyLineup'] as List<dynamic>? ?? json['enemy_lineup'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      rewards: (json['rewards'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      isCleared: json['isCleared'] as bool? ?? json['is_cleared'] as bool? ?? false,
      starCount: (json['starCount'] as num? ?? json['star_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapterId': chapterId,
        'name': name,
        'difficulty': difficulty,
        'requiredLevel': requiredLevel,
        'enemyLineup': enemyLineup,
        'rewards': rewards,
        'isCleared': isCleared,
        'starCount': starCount,
      };

  Stage copyWith({
    String? id,
    String? chapterId,
    String? name,
    int? difficulty,
    int? requiredLevel,
    List<String>? enemyLineup,
    Map<String, int>? rewards,
    bool? isCleared,
    int? starCount,
  }) {
    return Stage(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      enemyLineup: enemyLineup ?? this.enemyLineup,
      rewards: rewards ?? this.rewards,
      isCleared: isCleared ?? this.isCleared,
      starCount: starCount ?? this.starCount,
    );
  }
}
