/// 国战任务数据模型（DTO）
///
/// 表示国战中的任务配置，包含任务目标、进度和奖励。
class WarTaskModel {
  /// 任务唯一标识
  final String id;

  /// 任务名称
  final String name;

  /// 任务描述
  final String? description;

  /// 任务目标值
  final int targetValue;

  /// 当前进度
  final int currentProgress;

  /// 奖励列表（物品ID -> 数量）
  final Map<String, int> rewards;

  /// 是否已完成
  final bool completed;

  /// 是否已领取奖励
  final bool claimed;

  const WarTaskModel({
    required this.id,
    required this.name,
    this.description,
    required this.targetValue,
    this.currentProgress = 0,
    this.rewards = const {},
    this.completed = false,
    this.claimed = false,
  });

  factory WarTaskModel.fromJson(Map<String, dynamic> json) {
    return WarTaskModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      targetValue: (json['target_value'] as num?)?.toInt() ?? (json['targetValue'] as num?)?.toInt() ?? 0,
      currentProgress: (json['current_progress'] as num?)?.toInt() ?? (json['currentProgress'] as num?)?.toInt() ?? 0,
      rewards: (json['rewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      completed: json['completed'] as bool? ?? false,
      claimed: json['claimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'target_value': targetValue,
        'current_progress': currentProgress,
        'rewards': rewards,
        'completed': completed,
        'claimed': claimed,
      };

  WarTaskModel copyWith({
    String? id,
    String? name,
    String? description,
    int? targetValue,
    int? currentProgress,
    Map<String, int>? rewards,
    bool? completed,
    bool? claimed,
  }) {
    return WarTaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      rewards: rewards ?? this.rewards,
      completed: completed ?? this.completed,
      claimed: claimed ?? this.claimed,
    );
  }
}
