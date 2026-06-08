import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/arena_state.dart';

/// 巅峰竞技场 ViewModel Provider
final peakArenaViewModelProvider =
    NotifierProvider<PeakArenaViewModel, ArenaState>(
  PeakArenaViewModel.new,
);

/// 巅峰竞技场 ViewModel
///
/// 管理巅峰竞技场高阶PVP玩法，包括Ban/Pick和实时对战。
class PeakArenaViewModel extends Notifier<ArenaState> {
  @override
  ArenaState build() => const ArenaState.idle();

  /// 加载巅峰竞技场数据
  Future<void> loadPeakArenaData() async {
    // TODO: 实现加载巅峰竞技场数据逻辑
  }

  /// 开始巅峰赛匹配
  Future<void> startPeakMatching() async {
    // TODO: 实现匹配逻辑
  }

  /// 禁用武将（Ban阶段）
  void banGeneral(String generalId) {
    // TODO: 实现禁用武将逻辑
  }

  /// 选择武将（Pick阶段）
  void pickGeneral(String generalId) {
    // TODO: 实现选择武将逻辑
  }

  /// 确认阵容
  Future<void> confirmLineup() async {
    // TODO: 实现确认阵容逻辑
  }
}
