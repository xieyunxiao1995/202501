/// 邮件数据模型（DTO）
///
/// 表示玩家收到的邮件，包含邮件标题、内容、附件和读取状态。
class MailModel {
  /// 邮件唯一标识
  final String id;

  /// 邮件标题
  final String title;

  /// 邮件内容
  final String content;

  /// 发送者名称
  final String sender;

  /// 是否已读
  final bool read;

  /// 是否已领取附件
  final bool claimed;

  /// 附件列表（物品ID -> 数量）
  final Map<String, int> attachments;

  /// 发送时间戳（毫秒）
  final int sentAt;

  /// 过期时间戳（毫秒）
  final int expireAt;

  const MailModel({
    required this.id,
    required this.title,
    required this.content,
    this.sender = '系统',
    this.read = false,
    this.claimed = false,
    this.attachments = const {},
    this.sentAt = 0,
    this.expireAt = 0,
  });

  factory MailModel.fromJson(Map<String, dynamic> json) {
    return MailModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      sender: json['sender'] as String? ?? '系统',
      read: json['read'] as bool? ?? false,
      claimed: json['claimed'] as bool? ?? false,
      attachments: (json['attachments'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      sentAt: (json['sent_at'] as num?)?.toInt() ?? (json['sentAt'] as num?)?.toInt() ?? 0,
      expireAt: (json['expire_at'] as num?)?.toInt() ?? (json['expireAt'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'sender': sender,
        'read': read,
        'claimed': claimed,
        'attachments': attachments,
        'sent_at': sentAt,
        'expire_at': expireAt,
      };

  MailModel copyWith({
    String? id,
    String? title,
    String? content,
    String? sender,
    bool? read,
    bool? claimed,
    Map<String, int>? attachments,
    int? sentAt,
    int? expireAt,
  }) {
    return MailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      read: read ?? this.read,
      claimed: claimed ?? this.claimed,
      attachments: attachments ?? this.attachments,
      sentAt: sentAt ?? this.sentAt,
      expireAt: expireAt ?? this.expireAt,
    );
  }
}
