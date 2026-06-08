import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/auth_state.dart';

/// 登录 ViewModel Provider
final loginViewModelProvider =
    NotifierProvider<LoginViewModel, AuthState>(
  LoginViewModel.new,
);

/// 登录 ViewModel
///
/// 管理用户登录流程，包括账号密码登录和第三方登录。
class LoginViewModel extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState.idle();

  /// 账号密码登录
  Future<void> loginWithPassword({
    required String username,
    required String password,
  }) async {
    // TODO: 实现账号密码登录
  }

  /// 微信登录
  Future<void> loginWithWechat() async {
    // TODO: 实现微信登录
  }

  /// QQ登录
  Future<void> loginWithQQ() async {
    // TODO: 实现QQ登录
  }

  /// 游客登录
  Future<void> loginAsGuest() async {
    // TODO: 实现游客登录
  }

  /// 重置为空闲状态
  void reset() {
    state = const AuthState.idle();
  }
}
