import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/arena_state.dart';

/// 竞技场 ViewModel Provider
final arenaViewModelProvider =
    NotifierProvider<ArenaViewModel, ArenaState>(
  ArenaViewModel.new,
);

/// 竞技场 ViewModel
///
/// 管理竞技场PVP玩法，包括匹配、战斗和排名。
class ArenaViewModel extends Notifier<ArenaState> {
  @override
  ArenaState build() => const ArenaState.idle();

  /// 加载竞技场数据
  Future<void> loadArenaData() async {
    // TODO: 实现加载竞技场数据逻辑
  }

  /// 开始匹配
  Future<void> startMatching() async {
    // TODO: 实现匹配逻辑
  }

  /// 取消匹配
  void cancelMatching() {
    // TODO: 实现取消匹配逻辑
  }

  /// 刷新对手列表
  Future<void> refreshOpponents() async {
    // TODO: 实现刷新对手逻辑
  }

  /// 挑战对手
  Future<void> challengeOpponent(String opponentId) async {
    // TODO: 实现挑战逻辑
  }
}
