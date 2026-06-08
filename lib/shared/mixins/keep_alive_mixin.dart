/// 保活 Mixin
///
/// 封装 AutomaticKeepAliveClientMixin，使 Tab 页面在切换后保持状态不被销毁。
///
/// 使用示例：
/// ```dart
/// class MyTabPage extends StatefulWidget { ... }
///
/// class _MyTabPageState extends State<MyTabPage>
///     with KeepAliveMixin {
///   @override
///   Widget build(BuildContext context) { ... }
/// }
/// ```
library;

import 'package:flutter/material.dart';

mixin KeepAliveMixin on StatefulWidget {
  // Mixin 标记，用于类型约束
}

/// KeepAliveMixin 的 State 混入
///
/// 提供 [wantKeepAlive] 并自动调用 [updateKeepAlive]。
mixin KeepAliveStateMixin<T extends StatefulWidget> on State<T>
    implements AutomaticKeepAliveClientMixin<T> {
  bool _wantKeepAlive = true;

  @override
  bool get wantKeepAlive => _wantKeepAlive;

  /// 更新保活状态
  ///
  /// 调用此方法后，AutomaticKeepAlive 会根据新状态决定是否保持活跃。
  /// ```dart
  /// setKeepAlive(false); // 允许被回收
  /// ```
  void setKeepAlive(bool value) {
    if (_wantKeepAlive != value) {
      _wantKeepAlive = value;
      updateKeepAlive();
    }
  }
}
