import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/home_state.dart';

/// 主城 ViewModel Provider
final homeViewModelProvider =
    NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);

/// 主城 ViewModel
///
/// 管理主城页面的数据和交互，包括玩家信息、资源数据和国家信息。
class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState.loading();

  /// 加载主城数据
  Future<void> loadHomeData() async {
    // TODO: 实现加载主城数据逻辑
  }

  /// 刷新资源数据
  Future<void> refreshResources() async {
    // TODO: 实现刷新资源逻辑
  }

  /// 领取离线奖励
  Future<void> claimOfflineReward() async {
    // TODO: 实现领取离线奖励逻辑
  }
}
