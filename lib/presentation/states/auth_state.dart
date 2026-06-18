/// 认证状态
///
/// 管理用户登录认证流程的状态，包括空闲、加载中、已认证和错误等状态。
sealed class AuthState {
  const AuthState();
  const factory AuthState.idle() = AuthIdle;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({required String userId, required String username}) = AuthAuthenticated;
  const factory AuthState.error({required String message}) = AuthError;
}

final class AuthIdle extends AuthState {
  const AuthIdle();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final String userId;
  final String username;
  const AuthAuthenticated({required this.userId, required this.username});
}

final class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
}
