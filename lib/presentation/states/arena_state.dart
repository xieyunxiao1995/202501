/// 竞技场状态
///
/// 管理竞技场PVP玩法的状态，包括空闲、匹配中、战斗中和出结果等阶段。
sealed class ArenaState {
  const ArenaState();
  const factory ArenaState.idle({int currentRank, int remainingChallenges}) = ArenaIdle;
  const factory ArenaState.matching({int elapsedSeconds}) = ArenaMatching;
  const factory ArenaState.inBattle({required String opponentId, required String opponentName}) = ArenaInBattle;
  const factory ArenaState.result({required bool isVictory, int rankChange}) = ArenaResult;
}

final class ArenaIdle extends ArenaState {
  final int currentRank;
  final int remainingChallenges;
  const ArenaIdle({this.currentRank = 0, this.remainingChallenges = 0});
}

final class ArenaMatching extends ArenaState {
  final int elapsedSeconds;
  const ArenaMatching({this.elapsedSeconds = 0});
}

final class ArenaInBattle extends ArenaState {
  final String opponentId;
  final String opponentName;
  const ArenaInBattle({required this.opponentId, required this.opponentName});
}

final class ArenaResult extends ArenaState {
  final bool isVictory;
  final int rankChange;
  const ArenaResult({required this.isVictory, this.rankChange = 0});
}
