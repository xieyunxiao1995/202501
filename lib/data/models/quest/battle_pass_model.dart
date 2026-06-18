/// 通行证数据模型（DTO）
///
/// 表示赛季通行证配置，包含等级、经验、免费/付费奖励。
class BattlePassModel {
  /// 通行证唯一标识
  final String id;

  /// 赛季名称
  final String seasonName;

  /// 当前等级
  final int currentLevel;

  /// 最大等级
  final int maxLevel;

  /// 当前经验值
  final int currentExp;

  /// 每级所需经验
  final int expPerLevel;

  /// 是否已购买高级通行证
  final bool premium;

  /// 赛季开始时间戳（毫秒）
  final int startTime;

  /// 赛季结束时间戳（毫秒）
  final int endTime;

  const BattlePassModel({
    required this.id,
    required this.seasonName,
    this.currentLevel = 0,
    this.maxLevel = 50,
    this.currentExp = 0,
    this.expPerLevel = 1000,
    this.premium = false,
    this.startTime = 0,
    this.endTime = 0,
  });

  factory BattlePassModel.fromJson(Map<String, dynamic> json) {
    return BattlePassModel(
      id: json['id'] as String,
      seasonName: json['season_name'] as String? ?? json['seasonName'] as String? ?? '',
      currentLevel: (json['current_level'] as num?)?.toInt() ?? (json['currentLevel'] as num?)?.toInt() ?? 0,
      maxLevel: (json['max_level'] as num?)?.toInt() ?? (json['maxLevel'] as num?)?.toInt() ?? 50,
      currentExp: (json['current_exp'] as num?)?.toInt() ?? (json['currentExp'] as num?)?.toInt() ?? 0,
      expPerLevel: (json['exp_per_level'] as num?)?.toInt() ?? (json['expPerLevel'] as num?)?.toInt() ?? 1000,
      premium: json['premium'] as bool? ?? false,
      startTime: (json['start_time'] as num?)?.toInt() ?? (json['startTime'] as num?)?.toInt() ?? 0,
      endTime: (json['end_time'] as num?)?.toInt() ?? (json['endTime'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'season_name': seasonName,
        'current_level': currentLevel,
        'max_level': maxLevel,
        'current_exp': currentExp,
        'exp_per_level': expPerLevel,
        'premium': premium,
        'start_time': startTime,
        'end_time': endTime,
      };

  BattlePassModel copyWith({
    String? id,
    String? seasonName,
    int? currentLevel,
    int? maxLevel,
    int? currentExp,
    int? expPerLevel,
    bool? premium,
    int? startTime,
    int? endTime,
  }) {
    return BattlePassModel(
      id: id ?? this.id,
      seasonName: seasonName ?? this.seasonName,
      currentLevel: currentLevel ?? this.currentLevel,
      maxLevel: maxLevel ?? this.maxLevel,
      currentExp: currentExp ?? this.currentExp,
      expPerLevel: expPerLevel ?? this.expPerLevel,
      premium: premium ?? this.premium,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
