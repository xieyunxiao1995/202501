/// 成就数据模型（DTO）
///
/// 表示游戏成就配置，包含成就目标、阶段和奖励。
class AchievementModel {
  /// 成就唯一标识
  final String id;

  /// 成就名称
  final String name;

  /// 成就描述
  final String? description;

  /// 成就分类
  final String category;

  /// 当前阶段（1-N）
  final int stage;

  /// 最大阶段
  final int maxStage;

  /// 各阶段目标值列表
  final List<int> stageTargets;

  /// 当前进度
  final int currentProgress;

  /// 奖励列表（物品ID -> 数量）
  final Map<String, int> rewards;

  /// 是否已完成全部阶段
  final bool completed;

  const AchievementModel({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    this.stage = 1,
    this.maxStage = 1,
    this.stageTargets = const [],
    this.currentProgress = 0,
    this.rewards = const {},
    this.completed = false,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      stage: (json['stage'] as num?)?.toInt() ?? 1,
      maxStage: (json['max_stage'] as num?)?.toInt() ?? (json['maxStage'] as num?)?.toInt() ?? 1,
      stageTargets: (json['stage_targets'] as List<dynamic>? ?? json['stageTargets'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt()).toList() ?? const [],
      currentProgress: (json['current_progress'] as num?)?.toInt() ?? (json['currentProgress'] as num?)?.toInt() ?? 0,
      rewards: (json['rewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'category': category,
        'stage': stage,
        'max_stage': maxStage,
        'stage_targets': stageTargets,
        'current_progress': currentProgress,
        'rewards': rewards,
        'completed': completed,
      };

  AchievementModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? stage,
    int? maxStage,
    List<int>? stageTargets,
    int? currentProgress,
    Map<String, int>? rewards,
    bool? completed,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      stage: stage ?? this.stage,
      maxStage: maxStage ?? this.maxStage,
      stageTargets: stageTargets ?? this.stageTargets,
      currentProgress: currentProgress ?? this.currentProgress,
      rewards: rewards ?? this.rewards,
      completed: completed ?? this.completed,
    );
  }
}
