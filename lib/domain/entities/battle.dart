import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/battle_status.dart' as enums;

part 'battle.freezed.dart';
part 'battle.g.dart';

/// 战斗实体
///
/// 表示一场战斗的完整状态，包括当前回合、最大回合数、战斗状态和胜者信息。
/// 战斗由双方阵容对阵，按回合制进行。
@freezed
class Battle with _$Battle {
  const factory Battle({
    /// 战斗唯一标识
    required String id,

    /// 我方阵容 ID
    required String lineupId,

    /// 敌方阵容 ID
    required String enemyLineupId,

    /// 当前回合数
    @Default(1) int currentRound,

    /// 最大回合数
    @Default(15) int maxRounds,

    /// 战斗状态（空闲/准备中/战斗中/暂停/已结束）
    @Default(enums.BattleStatus.idle) enums.BattleStatus status,

    /// 胜者 ID，战斗未结束时为空
    String? winnerId,
  }) = _Battle;

  factory Battle.fromJson(Map<String, dynamic> json) =>
      _$BattleFromJson(json);
}
