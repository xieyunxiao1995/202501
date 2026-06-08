import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/app_state.dart';

/// 传记 ViewModel Provider
final biographyViewModelProvider =
    NotifierProvider<BiographyViewModel, AppState>(
  BiographyViewModel.new,
);

/// 传记 ViewModel
///
/// 管理武将传记系统，包括传记解锁、阅读和收集进度。
class BiographyViewModel extends Notifier<AppState> {
  @override
  AppState build() => const AppState.initialized();

  /// 加载传记列表
  Future<void> loadBiographies() async {
    // TODO: 实现加载传记列表逻辑
  }

  /// 解锁传记
  Future<void> unlockBiography(String biographyId) async {
    // TODO: 实现解锁传记逻辑
  }

  /// 阅读传记章节
  Future<void> readChapter({
    required String biographyId,
    required String chapterId,
  }) async {
    // TODO: 实现阅读章节逻辑
  }

  /// 领取传记收集奖励
  Future<void> claimCollectionReward(String biographyId) async {
    // TODO: 实现领取收集奖励逻辑
  }
}
