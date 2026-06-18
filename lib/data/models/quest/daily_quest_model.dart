/// 日常任务数据模型（DTO）
///
/// 表示每日刷新的任务，包含活跃度进度和宝箱奖励。
class DailyQuestModel {
  /// 日常任务唯一标识
  final String id;

  /// 任务名称
  final String name;

  /// 任务描述
  final String? description;

  /// 任务目标值
  final int targetValue;

  /// 当前进度
  final int currentProgress;

  /// 活跃度奖励
  final int activityReward;

  /// 是否已完成
  final bool completed;

  /// 是否已领取奖励
  final bool claimed;

  /// 每日重置时间戳（毫秒）
  final int resetAt;

  const DailyQuestModel({
    required this.id,
    required this.name,
    this.description,
    required this.targetValue,
    this.currentProgress = 0,
    this.activityReward = 0,
    this.completed = false,
    this.claimed = false,
    this.resetAt = 0,
  });

  factory DailyQuestModel.fromJson(Map<String, dynamic> json) {
    return DailyQuestModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      targetValue: (json['target_value'] as num?)?.toInt() ?? (json['targetValue'] as num?)?.toInt() ?? 0,
      currentProgress: (json['current_progress'] as num?)?.toInt() ?? (json['currentProgress'] as num?)?.toInt() ?? 0,
      activityReward: (json['activity_reward'] as num?)?.toInt() ?? (json['activityReward'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
      claimed: json['claimed'] as bool? ?? false,
      resetAt: (json['reset_at'] as num?)?.toInt() ?? (json['resetAt'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'target_value': targetValue,
        'current_progress': currentProgress,
        'activity_reward': activityReward,
        'completed': completed,
        'claimed': claimed,
        'reset_at': resetAt,
      };

  DailyQuestModel copyWith({
    String? id,
    String? name,
    String? description,
    int? targetValue,
    int? currentProgress,
    int? activityReward,
    bool? completed,
    bool? claimed,
    int? resetAt,
  }) {
    return DailyQuestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      activityReward: activityReward ?? this.activityReward,
      completed: completed ?? this.completed,
      claimed: claimed ?? this.claimed,
      resetAt: resetAt ?? this.resetAt,
    );
  }
}
