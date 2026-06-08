/// 滚动控制器 Mixin
///
/// 为 StatefulWidget 提供 ScrollController 的生命周期管理，
/// 包括创建、监听、销毁以及常用滚动操作。
///
/// 使用示例：
/// ```dart
/// class _MyPageState extends State<MyPage>
///     with ScrollControllerMixin<MyPage> {
///   @override
///   void onScrollUpdate() {
///     if (scrollController.position.pixels > 100) {
///       // 显示回到顶部按钮
///     }
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return ListView(controller: scrollController, ...);
///   }
/// }
/// ```
library;

import 'package:flutter/material.dart';

mixin ScrollControllerMixin<T extends StatefulWidget> on State<T> {
  /// 滚动控制器
  late final ScrollController scrollController;

  /// 是否滚动到底部
  bool get isAtBottom {
    if (!scrollController.hasClients) return false;
    return scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 50;
  }

  /// 是否滚动到顶部
  bool get isAtTop {
    if (!scrollController.hasClients) return false;
    return scrollController.position.pixels <=
        scrollController.position.minScrollExtent;
  }

  /// 当前滚动偏移量
  double get scrollOffset {
    if (!scrollController.hasClients) return 0.0;
    return scrollController.offset;
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!mounted) return;
    onScrollUpdate();
    if (isAtBottom) {
      onScrollToBottom();
    }
  }

  /// 滚动更新回调，子类可重写
  ///
  /// 每次滚动位置变化时触发。
  void onScrollUpdate() {}

  /// 滚动到底部回调，子类可重写
  ///
  /// 接近底部时触发，可用于加载更多。
  void onScrollToBottom() {}

  /// 滚动到顶部
  ///
  /// [animated] 为 true 时使用动画滚动，否则立即跳转。
  /// [duration] 和 [curve] 仅在动画模式下生效。
  void scrollToTop({
    bool animated = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (!scrollController.hasClients) return;
    if (animated) {
      scrollController.animateTo(
        0.0,
        duration: duration,
        curve: curve,
      );
    } else {
      scrollController.jumpTo(0.0);
    }
  }

  /// 滚动到底部
  void scrollToBottom({
    bool animated = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (!scrollController.hasClients) return;
    final maxScroll = scrollController.position.maxScrollExtent;
    if (animated) {
      scrollController.animateTo(
        maxScroll,
        duration: duration,
        curve: curve,
      );
    } else {
      scrollController.jumpTo(maxScroll);
    }
  }

  /// 滚动到指定偏移量
  void scrollTo(
    double offset, {
    bool animated = true,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (!scrollController.hasClients) return;
    if (animated) {
      scrollController.animateTo(offset, duration: duration, curve: curve);
    } else {
      scrollController.jumpTo(offset);
    }
  }
}
