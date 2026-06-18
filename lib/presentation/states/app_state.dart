/// 应用全局状态
///
/// 管理应用的整体生命周期状态，包括初始化、加载中、已认证和未认证等阶段。
sealed class AppState {
  const AppState();
  const factory AppState.initialized() = AppInitialized;
  const factory AppState.loading() = AppLoading;
  const factory AppState.authenticated({required String userId, required String token}) = AppAuthenticated;
  const factory AppState.unauthenticated() = AppUnauthenticated;
}

final class AppInitialized extends AppState {
  const AppInitialized();
}

final class AppLoading extends AppState {
  const AppLoading();
}

final class AppAuthenticated extends AppState {
  final String userId;
  final String token;
  const AppAuthenticated({required this.userId, required this.token});
}

final class AppUnauthenticated extends AppState {
  const AppUnauthenticated();
}
