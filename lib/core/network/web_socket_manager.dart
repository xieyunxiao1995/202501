import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/env_config.dart';
import '../utils/logger.dart';
import 'web_socket_channel.dart';

/// WebSocket 连接状态
enum WsConnectionState {
  /// 正在连接中
  connecting,

  /// 已连接
  connected,

  /// 已断开
  disconnected,
}

/// WebSocket 长连接管理器
///
/// 管理 WebSocket 连接的生命周期，包括：
/// - 连接/断开/重连逻辑
/// - 心跳保活（每30秒发送 ping）
/// - 断线自动重连（指数退避）
/// - 按 channel 名管理多个连接
/// - 状态监听（连接中/已连接/已断开）
///
/// 单例模式，通过 GetIt 注册使用：
/// ```dart
/// // 注册
/// getIt.registerSingleton<WebSocketManager>(
///   WebSocketManager(envConfig: envConfig),
/// );
///
/// // 连接
/// final manager = getIt<WebSocketManager>();
/// await manager.connect(WsChannelName.chat);
///
/// // 监听消息
/// manager.getChannel(WsChannelName.chat)?.messages.listen((msg) {
///   print('收到消息: ${msg.data}');
/// });
///
/// // 发送消息
/// final channel = manager.getChannel(WsChannelName.chat);
/// channel?.sendEvent('send_message', {'content': '你好！'});
/// ```
class WebSocketManager {
  /// 创建 WebSocket 管理器
  ///
  /// [envConfig] 环境配置，提供 WebSocket 基础地址
  /// [maxReconnectAttempts] 最大重连次数，默认 10 次
  /// [heartbeatInterval] 心跳间隔，默认 30 秒
  /// [baseBackoffDelay] 基础退避延迟，默认 1 秒
  /// [maxBackoffDelay] 最大退避延迟，默认 60 秒
  WebSocketManager({
    required EnvConfig envConfig,
    this.maxReconnectAttempts = 10,
    this.heartbeatInterval = const Duration(seconds: 30),
    this.baseBackoffDelay = const Duration(seconds: 1),
    this.maxBackoffDelay = const Duration(seconds: 60),
  }) : _envConfig = envConfig;

  /// 环境配置，提供 WebSocket 基础地址
  final EnvConfig _envConfig;

  /// WebSocket 连接映射表，按通道名区分
  final Map<WsChannelName, WebSocketChannel> _channels = {};

  /// WsChannel 实例映射表
  final Map<WsChannelName, WsChannel> _wsChannels = {};

  /// 连接状态映射表
  final Map<WsChannelName, WsConnectionState> _connectionStates = {};

  /// 连接状态变化控制器
  final StreamController<MapEntry<WsChannelName, WsConnectionState>>
      _stateController =
      StreamController<MapEntry<WsChannelName, WsConnectionState>>.broadcast();

  /// 心跳定时器映射表
  final Map<WsChannelName, Timer> _heartbeatTimers = {};

  /// 重连定时器映射表
  final Map<WsChannelName, Timer> _reconnectTimers = {};

  /// 重连次数映射表
  final Map<WsChannelName, int> _reconnectCounts = {};

  /// 消息订阅映射表
  final Map<WsChannelName, StreamSubscription> _subscriptions = {};

  /// 最大重连次数
  final int maxReconnectAttempts;

  /// 心跳间隔
  final Duration heartbeatInterval;

  /// 最大退避延迟
  final Duration maxBackoffDelay;

  /// 基础退避延迟
  final Duration baseBackoffDelay;

  /// 获取连接状态流
  ///
  /// 返回所有通道状态变化的 Stream
  Stream<MapEntry<WsChannelName, WsConnectionState>> get stateChanges =>
      _stateController.stream;

  /// 获取指定通道的连接状态
  WsConnectionState getState(WsChannelName channelName) {
    return _connectionStates[channelName] ?? WsConnectionState.disconnected;
  }

  /// 获取指定通道的 WsChannel 实例
  WsChannel? getChannel(WsChannelName channelName) {
    return _wsChannels[channelName];
  }

  /// 连接到指定通道
  ///
  /// [channelName] 通道名称
  /// [url] 可选的自定义 WebSocket URL，默认使用 EnvConfig 中的配置
  Future<void> connect(WsChannelName channelName, {String? url}) async {
    // 如果已连接，先断开
    if (_connectionStates[channelName] == WsConnectionState.connected ||
        _connectionStates[channelName] == WsConnectionState.connecting) {
      await disconnect(channelName);
    }

    final wsUrl = url ?? _buildWebSocketUrl(channelName);
    _updateState(channelName, WsConnectionState.connecting);

    try {
      // 创建 WebSocket 连接
      final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channels[channelName] = channel;

      // 创建 WsChannel 实例
      final wsChannel = WsChannel(channelName);
      wsChannel.setSendCallback((message) => _send(channelName, message));
      _wsChannels[channelName] = wsChannel;

      // 监听消息
      _subscriptions[channelName] = channel.stream.listen(
        (data) => _onMessage(channelName, data),
        onError: (error) => _onError(channelName, error),
        onDone: () => _onDone(channelName),
      );

      // 启动心跳
      _startHeartbeat(channelName);

      // 重置重连计数
      _reconnectCounts[channelName] = 0;

      _updateState(channelName, WsConnectionState.connected);
      AppLogger.info('WebSocket 通道 ${channelName.value} 连接成功');
    } catch (e) {
      AppLogger.error('WebSocket 通道 ${channelName.value} 连接失败', e);
      _updateState(channelName, WsConnectionState.disconnected);
      _scheduleReconnect(channelName);
    }
  }

  /// 断开指定通道
  ///
  /// [channelName] 通道名称
  Future<void> disconnect(WsChannelName channelName) async {
    // 停止心跳
    _stopHeartbeat(channelName);

    // 取消重连
    _cancelReconnect(channelName);

    // 取消消息订阅
    await _subscriptions[channelName]?.cancel();
    _subscriptions.remove(channelName);

    // 关闭 WebSocket 连接
    await _channels[channelName]?.sink.close();
    _channels.remove(channelName);

    // 关闭 WsChannel
    await _wsChannels[channelName]?.close();
    _wsChannels.remove(channelName);

    _updateState(channelName, WsConnectionState.disconnected);
    AppLogger.info('WebSocket 通道 ${channelName.value} 已断开');
  }

  /// 断开所有通道
  Future<void> disconnectAll() async {
    for (final channelName in WsChannelName.values) {
      if (_channels.containsKey(channelName)) {
        await disconnect(channelName);
      }
    }
  }

  /// 发送消息到指定通道
  void _send(WsChannelName channelName, WsMessage message) {
    final channel = _channels[channelName];
    if (channel == null) {
      AppLogger.warning('WebSocket 通道 ${channelName.value} 不存在，无法发送消息');
      return;
    }

    if (_connectionStates[channelName] != WsConnectionState.connected) {
      AppLogger.warning('WebSocket 通道 ${channelName.value} 未连接，无法发送消息');
      return;
    }

    try {
      channel.sink.add(message.encode());
      AppLogger.debug('WebSocket 发送消息 → ${channelName.value}: ${message.event}');
    } catch (e) {
      AppLogger.error('WebSocket 发送消息失败: ${channelName.value}', e);
    }
  }

  /// 处理收到的消息
  void _onMessage(WsChannelName channelName, dynamic data) {
    try {
      final jsonStr = data is String ? data : jsonEncode(data);
      final message = WsMessage.decode(jsonStr);

      AppLogger.debug(
        'WebSocket 收到消息 ← ${channelName.value}: ${message.event}',
      );

      // 分发到对应的 WsChannel
      _wsChannels[channelName]?.onMessage(message);
    } catch (e) {
      AppLogger.error('WebSocket 消息处理失败: ${channelName.value}', e);
    }
  }

  /// 处理连接错误
  void _onError(WsChannelName channelName, dynamic error) {
    AppLogger.error('WebSocket 通道 ${channelName.value} 错误', error);
    _updateState(channelName, WsConnectionState.disconnected);
    _scheduleReconnect(channelName);
  }

  /// 处理连接关闭
  void _onDone(WsChannelName channelName) {
    AppLogger.info('WebSocket 通道 ${channelName.value} 连接已关闭');
    _updateState(channelName, WsConnectionState.disconnected);
    _scheduleReconnect(channelName);
  }

  /// 启动心跳保活
  void _startHeartbeat(WsChannelName channelName) {
    _stopHeartbeat(channelName);

    _heartbeatTimers[channelName] = Timer.periodic(
      heartbeatInterval,
      (_) => _sendPing(channelName),
    );
  }

  /// 停止心跳保活
  void _stopHeartbeat(WsChannelName channelName) {
    _heartbeatTimers[channelName]?.cancel();
    _heartbeatTimers.remove(channelName);
  }

  /// 发送心跳 ping
  void _sendPing(WsChannelName channelName) {
    final channel = _channels[channelName];
    if (channel == null ||
        _connectionStates[channelName] != WsConnectionState.connected) {
      return;
    }

    try {
      final pingMessage = WsMessage(
        channel: channelName.value,
        event: 'ping',
        data: {},
      );
      channel.sink.add(pingMessage.encode());
      AppLogger.debug('WebSocket 心跳 ping → ${channelName.value}');
    } catch (e) {
      AppLogger.error('WebSocket 心跳发送失败: ${channelName.value}', e);
    }
  }

  /// 安排重连（指数退避）
  void _scheduleReconnect(WsChannelName channelName) {
    _cancelReconnect(channelName);

    final count = _reconnectCounts[channelName] ?? 0;
    if (count >= maxReconnectAttempts) {
      AppLogger.warning(
        'WebSocket 通道 ${channelName.value} 已达最大重连次数 ($maxReconnectAttempts)，停止重连',
      );
      return;
    }

    // 指数退避延迟：baseDelay * 2^count
    final delay = baseBackoffDelay * (1 << count);
    final actualDelay = delay > maxBackoffDelay ? maxBackoffDelay : delay;

    AppLogger.info(
      'WebSocket 通道 ${channelName.value} 将在 ${actualDelay.inSeconds} 秒后进行第 ${count + 1} 次重连',
    );

    _reconnectTimers[channelName] = Timer(actualDelay, () async {
      _reconnectCounts[channelName] = count + 1;
      await connect(channelName);
    });
  }

  /// 取消重连
  void _cancelReconnect(WsChannelName channelName) {
    _reconnectTimers[channelName]?.cancel();
    _reconnectTimers.remove(channelName);
  }

  /// 构建 WebSocket URL
  String _buildWebSocketUrl(WsChannelName channelName) {
    final baseUrl = _envConfig.wsUrl;
    return '$baseUrl/ws/${channelName.value}';
  }

  /// 更新连接状态并通知监听者
  void _updateState(WsChannelName channelName, WsConnectionState state) {
    _connectionStates[channelName] = state;
    if (!_stateController.isClosed) {
      _stateController.add(MapEntry(channelName, state));
    }
  }

  /// 释放所有资源
  Future<void> dispose() async {
    await disconnectAll();
    await _stateController.close();
  }
}
