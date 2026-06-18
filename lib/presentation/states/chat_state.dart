/// 聊天状态
///
/// 管理聊天系统的状态，包括消息列表和频道信息。
sealed class ChatState {
  const ChatState();
  const factory ChatState.loaded({required List<ChatMessage> messages, required List<ChatChannel> channels, String? activeChannelId}) = ChatLoaded;
  const factory ChatState.error({required String message}) = ChatError;
}

final class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final List<ChatChannel> channels;
  final String? activeChannelId;
  const ChatLoaded({required this.messages, required this.channels, this.activeChannelId});
}

final class ChatError extends ChatState {
  final String message;
  const ChatError({required this.message});
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
