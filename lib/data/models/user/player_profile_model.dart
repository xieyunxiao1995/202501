/// 玩家档案模型（DTO）
///
/// 用于展示玩家个人档案信息，包含用户ID、昵称、等级、VIP、爵位和阵营。
class PlayerProfileModel {
  /// 用户 ID
  final String userId;

  /// 昵称
  final String nickname;

  /// 等级
  final int level;

  /// VIP 等级
  final int vip;

  /// 爵位标识
  final String title;

  /// 所属阵营标识
  final String? kingdom;

  const PlayerProfileModel({
    required this.userId,
    required this.nickname,
    this.level = 1,
    this.vip = 0,
    this.title = 'commoner',
    this.kingdom,
  });

  factory PlayerProfileModel.fromJson(Map<String, dynamic> json) {
    return PlayerProfileModel(
      userId: json['user_id'] as String? ?? (json['userId'] as String? ?? ''),
      nickname: json['nickname'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      vip: (json['vip'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'commoner',
      kingdom: json['kingdom'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'nickname': nickname,
        'level': level,
        'vip': vip,
        'title': title,
        if (kingdom != null) 'kingdom': kingdom,
      };

  PlayerProfileModel copyWith({
    String? userId,
    String? nickname,
    int? level,
    int? vip,
    String? title,
    String? kingdom,
  }) {
    return PlayerProfileModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      level: level ?? this.level,
      vip: vip ?? this.vip,
      title: title ?? this.title,
      kingdom: kingdom ?? this.kingdom,
    );
  }
}
