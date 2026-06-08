import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/battle_state.dart';

/// 关卡列表 ViewModel Provider
final stageListViewModelProvider =
    NotifierProvider<StageListViewModel, BattleState>(
  StageListViewModel.new,
);

/// 关卡列表 ViewModel
///
/// 管理关卡列表的数据加载和关卡状态查询。
class StageListViewModel extends Notifier<BattleState> {
  @override
  BattleState build() => const BattleState.idle();

  /// 加载章节列表
  Future<void> loadChapters() async {
    // TODO: 实现加载章节逻辑
  }

  /// 加载关卡列表
  Future<void> loadStages(String chapterId) async {
    // TODO: 实现加载关卡逻辑
  }

  /// 进入关卡
  Future<void> enterStage(String stageId) async {
    // TODO: 实现进入关卡逻辑
  }

  /// 扫荡关卡
  Future<void> sweepStage(String stageId) async {
    // TODO: 实现扫荡逻辑
  }
}
