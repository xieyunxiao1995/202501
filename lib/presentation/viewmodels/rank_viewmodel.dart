import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/app_state.dart';

/// 排行榜 ViewModel Provider
final rankViewModelProvider =
    NotifierProvider<RankViewModel, AppState>(
  RankViewModel.new,
);

/// 排行榜 ViewModel
///
/// 管理排行榜数据，包括各类排行查看和自身排名查询。
class RankViewModel extends Notifier<AppState> {
  @override
  AppState build() => const AppState.initialized();

  /// 加载排行榜数据
  Future<void> loadRankData({
    required String rankType,
    int page = 1,
  }) async {
    // TODO: 实现加载排行榜逻辑
  }

  /// 查看自身排名
  Future<void> loadMyRank() async {
    // TODO: 实现查看自身排名逻辑
  }

  /// 切换排行榜类型
  void switchRankType(String rankType) {
    // TODO: 实现切换排行榜类型逻辑
  }
}
