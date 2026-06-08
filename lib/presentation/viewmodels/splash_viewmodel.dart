import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/app_state.dart';

/// 启动页 ViewModel Provider
final splashViewModelProvider =
    NotifierProvider<SplashViewModel, AppState>(
  SplashViewModel.new,
);

/// 启动页 ViewModel
///
/// 管理应用启动流程，包括资源加载、配置初始化和自动登录检查。
class SplashViewModel extends Notifier<AppState> {
  @override
  AppState build() => const AppState.loading();

  /// 初始化应用
  Future<void> initializeApp() async {
    // TODO: 实现初始化逻辑
  }

  /// 检查更新
  Future<bool> checkUpdate() async {
    // TODO: 实现更新检查逻辑
    return false;
  }

  /// 尝试自动登录
  Future<void> tryAutoLogin() async {
    // TODO: 实现自动登录逻辑
  }
}
