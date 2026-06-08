/// 动画 Mixin
///
/// 封装 SingleTickerProviderStateMixin，提供常用动画的快捷创建方法。
/// 自动管理 AnimationController 的生命周期。
///
/// 使用示例：
/// ```dart
/// class _MyWidgetState extends State<MyWidget>
///     with AnimationMixin<MyWidget> {
///   late final Animation<double> fadeIn = createFadeInAnimation();
///   late final Animation<double> scaleIn = createScaleInAnimation();
///
///   @override
///   void initState() {
///     super.initState();
///     forward(); // 启动动画
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return FadeTransition(opacity: fadeIn, child: child);
///   }
/// }
/// ```
library;

import 'package:flutter/material.dart';

mixin AnimationMixin<T extends StatefulWidget> on State<T>
    implements SingleTickerProviderStateMixin<T> {
  /// 动画控制器
  late final AnimationController animationController;

  /// 默认动画时长
  Duration animationDuration = const Duration(milliseconds: 300);

  /// 默认动画曲线
  Curve animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // ========== 控制器操作 ==========

  /// 正向播放动画（从 0 到 1）
  TickerFuture forward({double? from}) {
    return animationController.forward(from: from);
  }

  /// 反向播放动画（从 1 到 0）
  TickerFuture reverse({double? from}) {
    return animationController.reverse(from: from);
  }

  /// 重复播放动画
  TickerFuture repeat({
    double? min,
    double? max,
    Duration? period,
    int? count,
  }) {
    return animationController.repeat(
      min: min,
      max: max,
      period: period,
      count: count,
    );
  }

  /// 重置动画到起始位置
  void reset() => animationController.reset();

  /// 停止动画
  void stop({bool canceled = true}) => animationController.stop(canceled: canceled);

  // ========== 常用动画工厂方法 ==========

  /// 创建淡入动画
  ///
  /// ```dart
  /// late final fadeIn = createFadeInAnimation();
  /// // 配合 FadeTransition 使用
  /// FadeTransition(opacity: fadeIn, child: child)
  /// ```
  Animation<double> createFadeInAnimation({
    Duration? duration,
    Curve curve = Curves.easeIn,
  }) {
    final parent = _configuredController(duration);
    return CurvedAnimation(parent: parent, curve: curve);
  }

  /// 创建缩放动画
  ///
  /// ```dart
  /// late final scaleIn = createScaleInAnimation(beginScale: 0.5);
  /// // 配合 ScaleTransition 使用
  /// ScaleTransition(scale: scaleIn, child: child)
  /// ```
  Animation<double> createScaleInAnimation({
    double beginScale = 0.0,
    double endScale = 1.0,
    Duration? duration,
    Curve curve = Curves.elasticOut,
  }) {
    final parent = _configuredController(duration);
    return Tween<double>(begin: beginScale, end: endScale).animate(
      CurvedAnimation(parent: parent, curve: curve),
    );
  }

  /// 创建滑动动画
  ///
  /// ```dart
  /// late final slideIn = createSlideInAnimation();
  /// // 配合 SlideTransition 使用
  /// SlideTransition(position: slideIn, child: child)
  /// ```
  Animation<Offset> createSlideInAnimation({
    Offset beginOffset = const Offset(0.0, 0.3),
    Offset endOffset = Offset.zero,
    Duration? duration,
    Curve curve = Curves.easeOutCubic,
  }) {
    final parent = _configuredController(duration);
    return Tween<Offset>(begin: beginOffset, end: endOffset).animate(
      CurvedAnimation(parent: parent, curve: curve),
    );
  }

  /// 创建旋转动画
  ///
  /// ```dart
  /// late final rotation = createRotationAnimation();
  /// // 配合 RotationTransition 使用
  /// RotationTransition(turns: rotation, child: child)
  /// ```
  Animation<double> createRotationAnimation({
    double beginTurns = 0.0,
    double endTurns = 1.0,
    Duration? duration,
    Curve curve = Curves.easeInOut,
  }) {
    final parent = _configuredController(duration);
    return Tween<double>(begin: beginTurns, end: endTurns).animate(
      CurvedAnimation(parent: parent, curve: curve),
    );
  }

  /// 创建尺寸动画
  ///
  /// ```dart
  /// late final sizeAnim = createSizeAnimation();
  /// // 配合 SizeTransition 使用
  /// SizeTransition(sizeFactor: sizeAnim, child: child)
  /// ```
  Animation<double> createSizeAnimation({
    double beginFactor = 0.0,
    double endFactor = 1.0,
    Duration? duration,
    Curve curve = Curves.easeInOut,
  }) {
    final parent = _configuredController(duration);
    return Tween<double>(begin: beginFactor, end: endFactor).animate(
      CurvedAnimation(parent: parent, curve: curve),
    );
  }

  // ========== 私有方法 ==========

  /// 获取配置了指定时长的 AnimationController（复用同一个控制器）
  AnimationController _configuredController(Duration? duration) {
    if (duration != null) {
      animationController.duration = duration;
    }
    return animationController;
  }
}
