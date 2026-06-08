/// Widget 扩展方法
///
/// 提供链式调用的 Widget 装饰工具，简化 Padding、Expanded、Center 等常用包裹。
library;

import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  // ========== Padding 相关 ==========

  /// 四周添加相同内边距
  ///
  /// ```dart
  /// Text('你好').paddingAll(16)
  /// ```
  Widget paddingAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  /// 水平内边距
  ///
  /// ```dart
  /// Text('你好').paddingHorizontal(16)
  /// ```
  Widget paddingHorizontal(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  /// 垂直内边距
  ///
  /// ```dart
  /// Text('你好').paddingVertical(8)
  /// ```
  Widget paddingVertical(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  /// 仅左侧内边距
  Widget paddingLeft(double value) =>
      Padding(padding: EdgeInsets.only(left: value), child: this);

  /// 仅右侧内边距
  Widget paddingRight(double value) =>
      Padding(padding: EdgeInsets.only(right: value), child: this);

  /// 仅顶部内边距
  Widget paddingTop(double value) =>
      Padding(padding: EdgeInsets.only(top: value), child: this);

  /// 仅底部内边距
  Widget paddingBottom(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);

  /// 自定义 EdgeInsets 内边距
  Widget padding(EdgeInsets padding) => Padding(padding: padding, child: this);

  // ========== 布局相关 ==========

  /// 包裹为 Expanded
  ///
  /// ```dart
  /// Text('你好').expanded()
  /// Text('你好').expanded(flex: 2)
  /// ```
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// 包裹为 Flexible
  ///
  /// ```dart
  /// Text('你好').flexible()
  /// ```
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// 居中显示
  ///
  /// ```dart
  /// Text('你好').center()
  /// ```
  Widget center() => Center(child: this);

  /// 指定对齐方式
  ///
  /// ```dart
  /// Text('你好').align(Alignment.centerLeft)
  /// ```
  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);

  // ========== 可见性相关 ==========

  /// 根据条件控制可见性
  ///
  /// [visible] 为 false 时，Widget 占位但不可见（保留空间）。
  /// ```dart
  /// Text('你好').visible(isLoggedIn)
  /// ```
  Widget visible(bool visible, {bool maintainSize = true, bool maintainAnimation = true}) =>
      Visibility(
        visible: visible,
        maintainSize: maintainSize,
        maintainAnimation: maintainAnimation,
        maintainState: maintainSize,
        child: this,
      );

  /// 设置透明度
  ///
  /// ```dart
  /// Text('你好').opacity(0.5)
  /// ```
  Widget opacity(double opacity, {bool alwaysIncludeSemantics = false}) =>
      Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        child: this,
      );

  // ========== Sliver 相关 ==========

  /// 转换为 SliverToBoxAdapter，用于 CustomScrollView
  ///
  /// ```dart
  /// Text('标题').sliver()
  /// ```
  Widget sliver() => SliverToBoxAdapter(child: this);

  // ========== 装饰相关 ==========

  /// 包裹圆形裁剪
  Widget clipCircle() => ClipOval(child: this);

  /// 包裹圆角裁剪
  Widget clipRRect(BorderRadius borderRadius) =>
      ClipRRect(borderRadius: borderRadius, child: this);

  /// 添加点击事件
  Widget onTap(VoidCallback onTap, {bool absorb = false}) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: absorb ? AbsorbPointer(child: this) : this,
      );

  /// 添加 Ink 点击效果
  Widget inkWell(VoidCallback onTap, {BorderRadius? borderRadius}) => InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: this,
      );
}
