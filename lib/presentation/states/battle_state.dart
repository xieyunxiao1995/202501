import 'package:freezed_annotation/freezed_annotation.dart';

part 'battle_state.freezed.dart';

/// 战斗状态
///
/// 管理战斗流程的完整状态，包括空闲、准备中、战斗进行中、
/// 暂停和结束等阶段，以及回合数、武将和行动序列等数据。
@freezed
class BattleState with _$BattleState {
  /// 空闲状态
  const factory BattleState.idle() = _BattleIdle;

  /// 准备阶段
  const factory BattleState.preparing({
    /// 战斗类型
    required String battleType,

    /// 己方武将ID列表
    required List<String> ownGeneralIds,

    /// 敌方武将ID列表
    required List<String> enemyGeneralIds,
  }) = _Preparing;

  /// 战斗进行中
  const factory BattleState.inProgress({
    /// 当前回合
    required int round,

    /// 己方武将列表
    required List<String> ownGenerals,

    /// 敌方武将列表
    required List<String> enemyGenerals,

    /// 行动队列
    required List<String> actions,
  }) = _InProgress;

  /// 战斗暂停
  const factory BattleState.paused({
    /// 当前回合
    required int round,
  }) = _Paused;

  /// 战斗结束
  const factory BattleState.ended({
    /// 是否胜利
    required bool isVictory,

    /// 战斗回合数
    required int totalRounds,

    /// 获得奖励
    required Map<String, int> rewards,
  }) = _Ended;
}
