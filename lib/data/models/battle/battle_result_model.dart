/// 战斗结果数据模型（DTO）
///
/// 表示战斗结束后的结算数据，包含胜负、奖励、MVP武将和伤害统计。
class BattleResultModel {
  /// 战斗 ID
  final String battleId;

  /// 是否胜利
  final bool isVictory;

  /// 奖励列表（键值对：物品ID -> 数量）
  final Map<String, int> rewards;

  /// MVP 武将 ID
  final String? mvpGeneralId;

  /// 总伤害值
  final int damageDealt;

  const BattleResultModel({
    required this.battleId,
    required this.isVictory,
    this.rewards = const {},
    this.mvpGeneralId,
    this.damageDealt = 0,
  });

  factory BattleResultModel.fromJson(Map<String, dynamic> json) {
    return BattleResultModel(
      battleId: json['battleId'] as String,
      isVictory: json['isVictory'] as bool,
      rewards: (json['rewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          const {},
      mvpGeneralId: json['mvpGeneralId'] as String?,
      damageDealt: (json['damageDealt'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'battleId': battleId,
        'isVictory': isVictory,
        'rewards': rewards,
        if (mvpGeneralId != null) 'mvpGeneralId': mvpGeneralId,
        'damageDealt': damageDealt,
      };

  BattleResultModel copyWith({
    String? battleId,
    bool? isVictory,
    Map<String, int>? rewards,
    String? mvpGeneralId,
    int? damageDealt,
  }) {
    return BattleResultModel(
      battleId: battleId ?? this.battleId,
      isVictory: isVictory ?? this.isVictory,
      rewards: rewards ?? this.rewards,
      mvpGeneralId: mvpGeneralId ?? this.mvpGeneralId,
      damageDealt: damageDealt ?? this.damageDealt,
    );
  }
}
