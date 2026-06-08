import 'package:freezed_annotation/freezed_annotation.dart';

part 'arena_state.freezed.dart';

/// 竞技场状态
///
/// 管理竞技场PVP玩法的状态，包括空闲、匹配中、战斗中和出结果等阶段。
@freezed
class ArenaState with _$ArenaState {
  /// 空闲状态
  const factory ArenaState.idle({
    /// 当前排名
    @Default(0) int currentRank,

    /// 剩余挑战次数
    @Default(0) int remainingChallenges,
  }) = _ArenaIdle;

  /// 匹配中
  const factory ArenaState.matching({
    /// 匹配时长（秒）
    @Default(0) int elapsedSeconds,
  }) = _Matching;

  /// 战斗中
  const factory ArenaState.inBattle({
    /// 对手ID
    required String opponentId,

    /// 对手名称
    required String opponentName,
  }) = _ArenaInBattle;

  /// 战斗结果
  const factory ArenaState.result({
    /// 是否胜利
    required bool isVictory,

    /// 排名变化
    @Default(0) int rankChange,
  }) = _ArenaResult;
}
