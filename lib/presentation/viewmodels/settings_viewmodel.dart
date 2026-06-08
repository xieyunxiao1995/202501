import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/app_state.dart';

/// 设置 ViewModel Provider
final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, AppState>(
  SettingsViewModel.new,
);

/// 设置 ViewModel
///
/// 管理游戏设置，包括音频、画面、账号和关于信息。
class SettingsViewModel extends Notifier<AppState> {
  @override
  AppState build() => const AppState.initialized();

  /// 加载设置
  Future<void> loadSettings() async {
    // TODO: 实现加载设置逻辑
  }

  /// 保存音频设置
  Future<void> saveAudioSettings({
    required double bgmVolume,
    required double sfxVolume,
    required double voiceVolume,
  }) async {
    // TODO: 实现保存音频设置逻辑
  }

  /// 保存画面设置
  Future<void> saveGraphicsSettings({
    required String quality,
    required bool particles,
  }) async {
    // TODO: 实现保存画面设置逻辑
  }

  /// 切换账号
  Future<void> switchAccount() async {
    // TODO: 实现切换账号逻辑
  }

  /// 退出登录
  Future<void> logout() async {
    // TODO: 实现退出登录逻辑
  }
}
