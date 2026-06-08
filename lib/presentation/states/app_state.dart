import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

/// 应用全局状态
///
/// 管理应用的整体生命周期状态，包括初始化、加载中、已认证和未认证等阶段。
@freezed
class AppState with _$AppState {
  /// 应用已初始化
  const factory AppState.initialized() = _Initialized;

  /// 应用加载中
  const factory AppState.loading() = _Loading;

  /// 用户已登录认证
  const factory AppState.authenticated({
    required String userId,
    required String token,
  }) = _Authenticated;

  /// 用户未认证
  const factory AppState.unauthenticated() = _Unauthenticated;
}
