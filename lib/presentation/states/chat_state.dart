import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

/// 聊天状态
///
/// 管理聊天系统的状态，包括消息列表和频道信息。
@freezed
class ChatState with _$ChatState {
  /// 数据已加载
  const factory ChatState.loaded({
    /// 消息列表
    required List<ChatMessage> messages,

    /// 频道列表
    required List<ChatChannel> channels,

    /// 当前选中频道ID
    String? activeChannelId,
  }) = _ChatLoaded;

  /// 加载失败
  const factory ChatState.error({
    required String message,
  }) = _ChatError;
}

/// 聊天消息
class ChatMessage {
  /// 消息ID
  final String id;

  /// 发送者名称
  final String senderName;

  /// 消息内容
  final String content;

  /// 发送时间
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.content,
    required this.timestamp,
  });
}

/// 聊天频道
class ChatChannel {
  /// 频道ID
  final String id;

  /// 频道名称
  final String name;

  const ChatChannel({
    required this.id,
    required this.name,
  });
}
