import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// 认证状态
///
/// 管理用户登录认证流程的状态，包括空闲、加载中、已认证和错误等状态。
@freezed
class AuthState with _$AuthState {
  /// 空闲状态
  const factory AuthState.idle() = _Idle;

  /// 登录加载中
  const factory AuthState.loading() = _AuthLoading;

  /// 认证成功
  const factory AuthState.authenticated({
    required String userId,
    required String username,
  }) = _AuthAuthenticated;

  /// 认证失败
  const factory AuthState.error({
    required String message,
  }) = _AuthError;
}
