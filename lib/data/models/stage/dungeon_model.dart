/// 副本数据模型（DTO）
///
/// 表示游戏中的副本配置，包含副本名称、类型、层数和奖励等信息。
class DungeonModel {
  /// 副本唯一标识
  final String id;

  /// 副本名称
  final String name;

  /// 副本类型标识
  final String type;

  /// 当前层数
  final int currentFloor;

  /// 最大层数
  final int maxFloor;

  /// 每日可挑战次数
  final int dailyLimit;

  /// 今日已挑战次数
  final int todayCount;

  /// 是否已解锁
  final bool unlocked;

  const DungeonModel({
    required this.id,
    required this.name,
    required this.type,
    this.currentFloor = 1,
    this.maxFloor = 50,
    this.dailyLimit = 3,
    this.todayCount = 0,
    this.unlocked = false,
  });

  factory DungeonModel.fromJson(Map<String, dynamic> json) {
    return DungeonModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      currentFloor: (json['current_floor'] as num?)?.toInt() ?? (json['currentFloor'] as num?)?.toInt() ?? 1,
      maxFloor: (json['max_floor'] as num?)?.toInt() ?? (json['maxFloor'] as num?)?.toInt() ?? 50,
      dailyLimit: (json['daily_limit'] as num?)?.toInt() ?? (json['dailyLimit'] as num?)?.toInt() ?? 3,
      todayCount: (json['today_count'] as num?)?.toInt() ?? (json['todayCount'] as num?)?.toInt() ?? 0,
      unlocked: json['unlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'current_floor': currentFloor,
        'max_floor': maxFloor,
        'daily_limit': dailyLimit,
        'today_count': todayCount,
        'unlocked': unlocked,
      };

  DungeonModel copyWith({
    String? id,
    String? name,
    String? type,
    int? currentFloor,
    int? maxFloor,
    int? dailyLimit,
    int? todayCount,
    bool? unlocked,
  }) {
    return DungeonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currentFloor: currentFloor ?? this.currentFloor,
      maxFloor: maxFloor ?? this.maxFloor,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      todayCount: todayCount ?? this.todayCount,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
