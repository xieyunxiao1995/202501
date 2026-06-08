/// BuildContext 扩展方法
///
/// 提供对 Theme、MediaQuery、Navigator 等常用 Inherited Widget 的快捷访问。
library;

import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  // ========== 主题相关 ==========

  /// 当前主题数据
  ///
  /// 等价于 `Theme.of(this)`。
  ThemeData get theme => Theme.of(this);

  /// 当前颜色方案
  ///
  /// 等价于 `Theme.of(this).colorScheme`。
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// 当前文本主题
  ///
  /// 等价于 `Theme.of(this).textTheme`。
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ========== 媒体查询相关 ==========

  /// 当前 MediaQueryData
  ///
  /// 等价于 `MediaQuery.of(this)`。
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// 屏幕宽度
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// 屏幕高度
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// 系统安全区域边距
  ///
  /// 等价于 `MediaQuery.of(this).padding`。
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// 屏幕像素密度
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// 屏幕方向
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// 是否为横屏
  bool get isLandscape => orientation == Orientation.landscape;

  /// 是否为竖屏
  bool get isPortrait => orientation == Orientation.portrait;

  // ========== 导航相关 ==========

  /// 当前 NavigatorState
  ///
  /// 等价于 `Navigator.of(this)`。
  NavigatorState get navigator => Navigator.of(this);

  /// 是否可以弹出
  ///
  /// 等价于 `Navigator.canPop(this)`。
  bool get canPop => Navigator.canPop(this);

  // ========== 聚焦相关 ==========

  /// 隐藏键盘
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// 是否有键盘弹出
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// 键盘高度
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;
}
