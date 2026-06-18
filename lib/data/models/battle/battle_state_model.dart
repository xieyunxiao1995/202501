/// 战斗状态数据模型（DTO）
///
/// 表示战斗中某一回合的状态快照，包含武将状态、活跃增益和羁绊效果。
class BattleStateModel {
  /// 当前回合数
  final int round;

  /// 武将状态列表（武将ID -> 状态数据）
  final Map<String, dynamic> generalStates;

  /// 活跃增益效果列表
  final List<String> activeBuffs;

  /// 活跃羁绊效果列表
  final List<String> activeBonds;

  const BattleStateModel({
    required this.round,
    this.generalStates = const {},
    this.activeBuffs = const [],
    this.activeBonds = const [],
  });

  factory BattleStateModel.fromJson(Map<String, dynamic> json) {
    return BattleStateModel(
      round: (json['round'] as num?)?.toInt() ?? 0,
      generalStates: json['generalStates'] as Map<String, dynamic>? ?? const {},
      activeBuffs: (json['activeBuffs'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
      activeBonds: (json['activeBonds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'round': round,
        'generalStates': generalStates,
        'activeBuffs': activeBuffs,
        'activeBonds': activeBonds,
      };

  BattleStateModel copyWith({
    int? round,
    Map<String, dynamic>? generalStates,
    List<String>? activeBuffs,
    List<String>? activeBonds,
  }) {
    return BattleStateModel(
      round: round ?? this.round,
      generalStates: generalStates ?? this.generalStates,
      activeBuffs: activeBuffs ?? this.activeBuffs,
      activeBonds: activeBonds ?? this.activeBonds,
    );
  }
}
