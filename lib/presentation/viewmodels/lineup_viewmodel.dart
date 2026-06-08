import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/lineup_state.dart';

/// 阵容 ViewModel Provider
final lineupViewModelProvider =
    NotifierProvider<LineupViewModel, LineupState>(
  LineupViewModel.new,
);

/// 阵容 ViewModel
///
/// 管理阵容配置，包括武将上阵、阵型选择和缘分激活。
class LineupViewModel extends Notifier<LineupState> {
  @override
  LineupState build() => const LineupState.loading();

  /// 加载阵容数据
  Future<void> loadLineup() async {
    // TODO: 实现加载阵容逻辑
  }

  /// 上阵武将
  void addGeneral(String generalId, int position) {
    // TODO: 实现上阵逻辑
  }

  /// 下阵武将
  void removeGeneral(int position) {
    // TODO: 实现下阵逻辑
  }

  /// 交换武将位置
  void swapGenerals(int posA, int posB) {
    // TODO: 实现交换逻辑
  }

  /// 选择阵型
  void selectFormation(String formationId) {
    // TODO: 实现选择阵型逻辑
  }

  /// 保存阵容
  Future<void> saveLineup() async {
    // TODO: 实现保存逻辑
  }

  /// 切换预设阵容
  void switchPreset(int presetIndex) {
    // TODO: 实现切换预设逻辑
  }
}
