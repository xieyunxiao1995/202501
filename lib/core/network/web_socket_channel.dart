import 'dart:async';
import 'dart:convert';

import '../utils/logger.dart';

/// WebSocket 通道名称
///
/// 按业务隔离不同的 WebSocket 连接通道
enum WsChannelName {
  /// 国战实时数据
  kingdomWar('kingdomWar'),

  /// 聊天消息
  chat('chat'),

  /// PVP 对战
  pvp('pvp');

  /// 创建通道名称
  const WsChannelName(this.value);

  /// 通道名称字符串
  final String value;

  /// 从字符串创建 WsChannelName
  static WsChannelName fromString(String value) {
    return WsChannelName.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('未知的 WebSocket 通道: $value'),
    );
  }
}

/// WebSocket 消息
///
/// 统一的 WebSocket 消息格式，包含通道、事件类型和数据
class WsMessage {
  /// 创建 WebSocket 消息
  WsMessage({
    required this.channel,
    required this.event,
    required this.data,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  /// 从 JSON Map 创建 WsMessage
  factory WsMessage.fromJson(Map<String, dynamic> json) {
    return WsMessage(
      channel: json['channel'] as String? ?? '',
      event: json['event'] as String? ?? '',
      data: (json['data'] as Map<String, dynamic>?) ?? {},
      timestamp: json['timestamp'] as int? ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// 消息所属通道
  final String channel;

  /// 事件类型（如 "battle_start", "chat_message", "pvp_match"）
  final String event;

  /// 消息数据
  final Map<String, dynamic> data;

  /// 消息时间戳
  final int timestamp;

  /// 转换为 JSON Map
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'event': event,
      'data': data,
      'timestamp': timestamp,
    };
  }

  /// 序列化为 JSON 字符串
  String encode() => jsonEncode(toJson());

  /// 从 JSON 字符串反序列化
  static WsMessage decode(String jsonStr) {
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return WsMessage.fromJson(json);
    } catch (e) {
      AppLogger.error('WebSocket 消息反序列化失败', e);
      rethrow;
    }
  }

  @override
  String toString() => 'WsMessage(channel: $channel, event: $event, data: $data)';
}

/// WebSocket 通道抽象
///
/// 按业务隔离 WebSocket 通道，每个通道独立管理消息收发。
/// 支持多个监听者同时订阅同一通道的消息，通过 Stream 广播实现。
///
/// 通道类型：
/// - [WsChannelName.kingdomWar]：国战实时数据
/// - [WsChannelName.chat]：聊天消息
/// - [WsChannelName.pvp]：PVP 对战
///
/// 使用方式：
/// ```dart
/// final channel = WsChannel(WsChannelName.chat);
///
/// // 监听消息
/// channel.messages.listen((message) {
///   print('收到聊天消息: ${message.data}');
/// });
///
/// // 发送消息
/// channel.send(WsMessage(
///   channel: 'chat',
///   event: 'send_message',
///   data: {'content': '你好！'},
/// ));
/// ```
class WsChannel {
  /// 创建 WebSocket 通道
  WsChannel(this.name);

  /// 通道名称
  final WsChannelName name;

  /// 发送消息的回调（由 WebSocketManager 注入）
  void Function(WsMessage message)? _sendCallback;

  /// 消息广播控制器
  final StreamController<WsMessage> _messageController =
      StreamController<WsMessage>.broadcast();

  /// 特定事件的监听器
  final Map<String, StreamController<WsMessage>> _eventControllers = {};

  /// 设置发送消息的回调
  ///
  /// 由 [WebSocketManager] 在创建通道时注入，将消息转发到实际的 WebSocket 连接
  void setSendCallback(void Function(WsMessage message) callback) {
    _sendCallback = callback;
  }

  /// 获取通道消息流
  ///
  /// 返回该通道所有消息的广播 Stream，多个监听者可同时订阅
  Stream<WsMessage> get messages => _messageController.stream;

  /// 获取特定事件的消息流
  ///
  /// [event] 事件类型，如 "battle_start", "chat_message"
  /// 返回仅包含该事件类型的消息流
  Stream<WsMessage> onEvent(String event) {
    return _eventControllers.putIfAbsent(
      event,
      () => StreamController<WsMessage>.broadcast(),
    ).stream;
  }

  /// 发送消息
  ///
  /// 通过 WebSocketManager 将消息发送到服务端。
  /// 如果通道未连接或发送回调未设置，消息将被丢弃并记录警告。
  void send(WsMessage message) {
    if (_sendCallback == null) {
      AppLogger.warning('WebSocket 通道 ${name.value} 未连接，消息发送失败');
      return;
    }
    _sendCallback!(message);
  }

  /// 发送事件消息（便捷方法）
  ///
  /// [event] 事件类型
  /// [data] 消息数据
  void sendEvent(String event, Map<String, dynamic> data) {
    send(WsMessage(
      channel: name.value,
      event: event,
      data: data,
    ));
  }

  /// 接收消息（由 WebSocketManager 调用）
  ///
  /// 将收到的消息分发到消息流和对应事件的流中
  void onMessage(WsMessage message) {
    // 分发到通用消息流
    if (!_messageController.isClosed) {
      _messageController.add(message);
    }

    // 分发到特定事件流
    final eventController = _eventControllers[message.event];
    if (eventController != null && !eventController.isClosed) {
      eventController.add(message);
    }
  }

  /// 关闭通道，释放资源
  ///
  /// 关闭所有 Stream 控制器，移除发送回调
  Future<void> close() async {
    _sendCallback = null;

    await _messageController.close();

    for (final controller in _eventControllers.values) {
      await controller.close();
    }
    _eventControllers.clear();

    AppLogger.info('WebSocket 通道 ${name.value} 已关闭');
  }
}
