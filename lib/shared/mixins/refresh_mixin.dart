/// 下拉刷新 Mixin
///
/// 为 ChangeNotifier 提供下拉刷新支持，管理刷新状态和刷新回调。
///
/// 使用示例：
/// ```dart
/// class MyViewModel extends ChangeNotifier with RefreshMixin {
///   @override
///   Future<void> onRefresh() async {
///     // 执行刷新逻辑
///     await loadData();
///   }
/// }
/// ```
library;

import 'package:flutter/material.dart';

mixin RefreshMixin on ChangeNotifier {
  /// 刷新标识的 Key，用于 RefreshIndicator
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  bool _isRefreshing = false;

  /// 当前是否正在刷新
  bool get isRefreshing => _isRefreshing;

  /// 下拉刷新回调
  ///
  /// 子类需要实现此方法来定义刷新逻辑。
  Future<void> onRefresh();

  /// 执行刷新操作
  ///
  /// 自动管理刷新状态，防止重复刷新。
  /// ```dart
  /// await performRefresh();
  /// ```
  Future<void> performRefresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();

    try {
      await onRefresh();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// 编程式触发刷新指示器
  ///
  /// 可在页面初始化时调用以显示刷新动画。
  /// ```dart
  /// WidgetsBinding.instance.addPostFrameCallback((_) {
  ///   triggerRefresh();
  /// });
  /// ```
  void triggerRefresh() {
    refreshKey.currentState?.show();
  }
}
