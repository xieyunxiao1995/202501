/// 聊天消息数据模型（DTO）
///
/// 表示聊天频道中的单条消息，包含发送者、内容和时间戳。
class ChatMessageModel {
  /// 消息唯一标识
  final String id;

  /// 发送者 ID
  final String senderId;

  /// 发送者昵称
  final String senderName;

  /// 消息内容
  final String content;

  /// 频道类型（world/alliance/private/system）
  final String channel;

  /// 发送时间戳（毫秒）
  final int timestamp;

  /// 发送者头像
  final String? senderAvatar;

  const ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.channel,
    this.timestamp = 0,
    this.senderAvatar,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String? ?? json['senderId'] as String? ?? '',
      senderName: json['sender_name'] as String? ?? json['senderName'] as String? ?? '',
      content: json['content'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
      senderAvatar: json['sender_avatar'] as String? ?? json['senderAvatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_id': senderId,
        'sender_name': senderName,
        'content': content,
        'channel': channel,
        'timestamp': timestamp,
        if (senderAvatar != null) 'sender_avatar': senderAvatar,
      };

  ChatMessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? content,
    String? channel,
    int? timestamp,
    String? senderAvatar,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      channel: channel ?? this.channel,
      timestamp: timestamp ?? this.timestamp,
      senderAvatar: senderAvatar ?? this.senderAvatar,
    );
  }
}
