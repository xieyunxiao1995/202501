/// 加载状态 Mixin
///
/// 为 ChangeNotifier 提供加载状态管理能力。
/// 配合 [runWithLoading] 可自动管理异步操作的加载状态。
///
/// 使用示例：
/// ```dart
/// class MyViewModel extends ChangeNotifier with LoadingMixin {
///   Future<void> loadData() async {
///     await runWithLoading(() async {
///       // 执行异步操作...
///     });
///   }
/// }
/// ```
library;

import 'package:flutter/foundation.dart';

mixin LoadingMixin on ChangeNotifier {
  bool _isLoading = false;

  /// 当前是否正在加载
  bool get isLoading => _isLoading;

  /// 设置加载状态
  ///
  /// 仅当状态发生变化时才会通知监听者。
  void setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// 在加载状态下执行异步操作
  ///
  /// 自动在操作开始前设置加载状态为 true，操作结束后（无论成功或失败）恢复为 false。
  /// ```dart
  /// await runWithLoading(() => api.fetchData());
  /// ```
  Future<T> runWithLoading<T>(Future<T> Function() action) async {
    setLoading(true);
    try {
      return await action();
    } finally {
      setLoading(false);
    }
  }
}
