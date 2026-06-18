/// 战斗状态
///
/// 管理战斗流程的完整状态，包括空闲、准备中、战斗进行中、
/// 暂停和结束等阶段，以及回合数、武将和行动序列等数据。
sealed class BattleState {
  const BattleState();
  const factory BattleState.idle() = BattleIdle;
  const factory BattleState.preparing({required String battleType, required List<String> ownGeneralIds, required List<String> enemyGeneralIds}) = BattlePreparing;
  const factory BattleState.inProgress({required int round, required List<String> ownGenerals, required List<String> enemyGenerals, required List<String> actions}) = BattleInProgress;
  const factory BattleState.paused({required int round}) = BattlePaused;
  const factory BattleState.ended({required bool isVictory, required int totalRounds, required Map<String, int> rewards}) = BattleEnded;
}

final class BattleIdle extends BattleState {
  const BattleIdle();
}

final class BattlePreparing extends BattleState {
  final String battleType;
  final List<String> ownGeneralIds;
  final List<String> enemyGeneralIds;
  const BattlePreparing({required this.battleType, required this.ownGeneralIds, required this.enemyGeneralIds});
}

final class BattleInProgress extends BattleState {
  final int round;
  final List<String> ownGenerals;
  final List<String> enemyGenerals;
  final List<String> actions;
  const BattleInProgress({required this.round, required this.ownGenerals, required this.enemyGenerals, required this.actions});
}

final class BattlePaused extends BattleState {
  final int round;
  const BattlePaused({required this.round});
}

final class BattleEnded extends BattleState {
  final bool isVictory;
  final int totalRounds;
  final Map<String, int> rewards;
  const BattleEnded({required this.isVictory, required this.totalRounds, required this.rewards});
}
