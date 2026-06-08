import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/recruit_state.dart';

/// 招募 ViewModel Provider
final recruitViewModelProvider =
    NotifierProvider<RecruitViewModel, RecruitState>(
  RecruitViewModel.new,
);

/// 招募 ViewModel
///
/// 管理武将招募流程，包括单抽、十连和卡池切换。
class RecruitViewModel extends Notifier<RecruitState> {
  @override
  RecruitState build() => const RecruitState.idle(poolId: 'default');

  /// 单抽
  Future<void> singleRecruit() async {
    // TODO: 实现单抽逻辑
  }

  /// 十连抽
  Future<void> tenRecruit() async {
    // TODO: 实现十连抽逻辑
  }

  /// 切换卡池
  void switchPool(String poolId) {
    // TODO: 实现切换卡池逻辑
  }

  /// 加载卡池信息
  Future<void> loadPoolInfo() async {
    // TODO: 实现加载卡池信息逻辑
  }

  /// 关闭结果展示
  void dismissResult() {
    // TODO: 实现关闭结果逻辑
  }
}
