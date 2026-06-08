import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/kingdom_war_state.dart';

/// 国战 ViewModel Provider
final kingdomWarViewModelProvider =
    NotifierProvider<KingdomWarViewModel, KingdomWarState>(
  KingdomWarViewModel.new,
);

/// 国战 ViewModel
///
/// 管理国战玩法的全局数据和交互，包括地图查看、城池攻防和任务领取。
class KingdomWarViewModel extends Notifier<KingdomWarState> {
  @override
  KingdomWarState build() => const KingdomWarState.loading();

  /// 加载国战地图数据
  Future<void> loadWarMap() async {
    // TODO: 实现加载地图逻辑
  }

  /// 攻击城池
  Future<void> attackCity(String cityId) async {
    // TODO: 实现攻城逻辑
  }

  /// 防守城池
  Future<void> defendCity(String cityId) async {
    // TODO: 实现防守逻辑
  }

  /// 领取国战任务奖励
  Future<void> claimTaskReward(String taskId) async {
    // TODO: 实现领取任务奖励逻辑
  }

  /// 查看国战排名
  Future<void> loadWarRank() async {
    // TODO: 实现加载排名逻辑
  }
}
