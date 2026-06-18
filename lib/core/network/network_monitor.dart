import 'dart:async';

import '../utils/logger.dart';

/// 网络连接类型
enum ConnectionType {
  /// WiFi 连接
  wifi,

  /// 移动数据连接
  mobile,

  /// 以太网连接
  ethernet,

  /// 无网络连接
  none,

  /// 未知连接类型
  unknown,
}

/// 网络状态监听器
///
/// iOS 简化版本：默认视为始终在线（WiFi 连接）。
///
/// 单例模式，通过 GetIt 注册使用：
/// ```dart
/// // 注册
/// getIt.registerSingleton<NetworkMonitor>(NetworkMonitor());
///
/// // 监听网络状态
/// final monitor = getIt<NetworkMonitor>();
/// monitor.isOnline.listen((online) {
///   if (!online) showOfflineToast();
/// });
/// ```
class NetworkMonitor {
  /// 创建网络状态监听器
  NetworkMonitor();

  /// 网络状态变化控制器
  StreamController<bool>? _onlineController;

  /// 当前是否在线（iOS 默认在线）
  bool _isOnline = true;

  /// 当前连接类型（iOS 默认 WiFi）
  ConnectionType _connectionType = ConnectionType.wifi;

  /// 当前是否在线
  bool get isOnlineSync => _isOnline;

  /// 当前连接类型
  ConnectionType get connectionType => _connectionType;

  /// 网络在线状态流
  ///
  /// true 表示有网络连接，false 表示无网络连接
  Stream<bool> get isOnline {
    _onlineController ??= StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _onlineController!.stream;
  }

  /// 初始化网络状态（iOS 直接视为在线）
  Future<void> initialize() async {
    _isOnline = true;
    _connectionType = ConnectionType.wifi;
    AppLogger.info('网络状态初始化: 在线, 类型: $_connectionType (iOS 默认)');
  }

  /// 手动检查当前网络状态（iOS 始终返回 true）
  Future<bool> checkOnline() async {
    return _isOnline;
  }

  /// 开始监听（iOS 无需实际监听）
  void _startListening() {
    // iOS 简化：无需实际监听，默认在线
  }

  /// 停止监听
  void _stopListening() {
    // iOS 简化：无需实际监听
  }

  /// 释放资源
  void dispose() {
    _onlineController?.close();
    _onlineController = null;
  }
}
