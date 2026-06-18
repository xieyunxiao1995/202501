import '../../shared/enums/battle_status.dart' as enums;

/// 战斗实体
///
/// 表示一场战斗的完整状态，包括当前回合、最大回合数、战斗状态和胜者信息。
/// 战斗由双方阵容对阵，按回合制进行。
class Battle {
  /// 战斗唯一标识
  final String id;

  /// 我方阵容 ID
  final String lineupId;

  /// 敌方阵容 ID
  final String enemyLineupId;

  /// 当前回合数
  final int currentRound;

  /// 最大回合数
  final int maxRounds;

  /// 战斗状态（空闲/准备中/战斗中/暂停/已结束）
  final enums.BattleStatus status;

  /// 胜者 ID，战斗未结束时为空
  final String? winnerId;

  const Battle({
    required this.id,
    required this.lineupId,
    required this.enemyLineupId,
    this.currentRound = 1,
    this.maxRounds = 15,
    this.status = enums.BattleStatus.idle,
    this.winnerId,
  });

  factory Battle.fromJson(Map<String, dynamic> json) {
    return Battle(
      id: json['id'] as String,
      lineupId: json['lineup_id'] as String? ?? (json['lineupId'] as String? ?? ''),
      enemyLineupId: json['enemy_lineup_id'] as String? ?? (json['enemyLineupId'] as String? ?? ''),
      currentRound: (json['current_round'] as num?)?.toInt() ?? (json['currentRound'] as num?)?.toInt() ?? 1,
      maxRounds: (json['max_rounds'] as num?)?.toInt() ?? (json['maxRounds'] as num?)?.toInt() ?? 15,
      status: json['status'] != null
          ? enums.BattleStatus.fromJson(json['status'] as String)
          : enums.BattleStatus.idle,
      winnerId: json['winner_id'] as String? ?? (json['winnerId'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lineup_id': lineupId,
        'enemy_lineup_id': enemyLineupId,
        'current_round': currentRound,
        'max_rounds': maxRounds,
        'status': status.toJson(),
        if (winnerId != null) 'winner_id': winnerId,
      };

  Battle copyWith({
    String? id,
    String? lineupId,
    String? enemyLineupId,
    int? currentRound,
    int? maxRounds,
    enums.BattleStatus? status,
    String? winnerId,
  }) {
    return Battle(
      id: id ?? this.id,
      lineupId: lineupId ?? this.lineupId,
      enemyLineupId: enemyLineupId ?? this.enemyLineupId,
      currentRound: currentRound ?? this.currentRound,
      maxRounds: maxRounds ?? this.maxRounds,
      status: status ?? this.status,
      winnerId: winnerId ?? this.winnerId,
    );
  }
}
