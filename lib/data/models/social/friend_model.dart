/// 好友数据模型（DTO）
///
/// 表示好友列表中的好友信息，包含好友基本信息和在线状态。
class FriendModel {
  /// 好友用户 ID
  final String userId;

  /// 好友昵称
  final String nickname;

  /// 好友等级
  final int level;

  /// 是否在线
  final bool online;

  /// 最后上线时间戳（毫秒）
  final int lastOnlineTime;

  /// 亲密度
  final int intimacy;

  /// 头像路径
  final String? avatar;

  const FriendModel({
    required this.userId,
    required this.nickname,
    this.level = 1,
    this.online = false,
    this.lastOnlineTime = 0,
    this.intimacy = 0,
    this.avatar,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      online: json['online'] as bool? ?? false,
      lastOnlineTime: (json['last_online_time'] as num?)?.toInt() ?? (json['lastOnlineTime'] as num?)?.toInt() ?? 0,
      intimacy: (json['intimacy'] as num?)?.toInt() ?? 0,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'nickname': nickname,
        'level': level,
        'online': online,
        'last_online_time': lastOnlineTime,
        'intimacy': intimacy,
        if (avatar != null) 'avatar': avatar,
      };

  FriendModel copyWith({
    String? userId,
    String? nickname,
    int? level,
    bool? online,
    int? lastOnlineTime,
    int? intimacy,
    String? avatar,
  }) {
    return FriendModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      level: level ?? this.level,
      online: online ?? this.online,
      lastOnlineTime: lastOnlineTime ?? this.lastOnlineTime,
      intimacy: intimacy ?? this.intimacy,
      avatar: avatar ?? this.avatar,
    );
  }
}
