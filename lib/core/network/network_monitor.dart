import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

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
/// 使用 connectivity_plus 监听网络连接状态变化，
/// 提供 Stream 方式监听网络在线/离线状态。
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
  ///
  /// [connectivity] 可选注入 Connectivity 实例，便于测试
  NetworkMonitor({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// connectivity_plus 实例
  final Connectivity _connectivity;

  /// 网络状态变化控制器
  StreamController<bool>? _onlineController;

  /// 当前是否在线
  bool _isOnline = true;

  /// 当前连接类型
  ConnectionType _connectionType = ConnectionType.unknown;

  /// 订阅
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

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

  /// 初始化网络状态
  ///
  /// 在应用启动时调用，获取初始网络状态
  Future<void> initialize() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateState(results);
      AppLogger.info('网络状态初始化: ${_isOnline ? "在线" : "离线"}, 类型: $_connectionType');
    } catch (e) {
      AppLogger.warning('网络状态初始化失败，默认视为在线', e);
      _isOnline = true;
      _connectionType = ConnectionType.unknown;
    }
  }

  /// 手动检查当前网络状态
  ///
  /// 返回当前是否在线
  Future<bool> checkOnline() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateState(results);
      return _isOnline;
    } catch (e) {
      AppLogger.warning('网络状态检查失败', e);
      return _isOnline;
    }
  }

  /// 开始监听网络状态变化
  void _startListening() {
    _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _updateState(results);
      },
      onError: (error) {
        AppLogger.error('网络状态监听错误', error);
      },
    );
  }

  /// 停止监听网络状态变化
  void _stopListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// 根据连接结果更新内部状态
  void _updateState(List<ConnectivityResult> results) {
    final previousOnline = _isOnline;
    final previousType = _connectionType;

    // 判断是否有可用连接
    final hasConnection = results.any((r) => r != ConnectivityResult.none);

    _isOnline = hasConnection;
    _connectionType = _mapConnectivityResult(results);

    // 状态变化时通知监听者
    if (previousOnline != _isOnline) {
      _onlineController?.add(_isOnline);
      AppLogger.info(
        '网络状态变化: ${previousOnline ? "在线" : "离线"} → ${_isOnline ? "在线" : "离线"}',
      );
    }

    if (previousType != _connectionType) {
      AppLogger.info('网络类型变化: $previousType → $_connectionType');
    }
  }

  /// 将 ConnectivityResult 映射为 ConnectionType
  ConnectionType _mapConnectivityResult(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectionType.none;
    }

    // 优先返回 WiFi
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectionType.wifi;
    }

    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectionType.mobile;
    }

    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectionType.ethernet;
    }

    if (results.contains(ConnectivityResult.vpn)) {
      // VPN 连接时，如果有其他连接类型，使用该类型
      if (results.contains(ConnectivityResult.wifi)) {
        return ConnectionType.wifi;
      }
      if (results.contains(ConnectivityResult.mobile)) {
        return ConnectionType.mobile;
      }
      return ConnectionType.unknown;
    }

    return ConnectionType.unknown;
  }

  /// 释放资源
  void dispose() {
    _stopListening();
    _onlineController?.close();
    _onlineController = null;
  }
}
