/// 联盟成员数据模型（DTO）
///
/// 表示联盟中的成员信息，包含成员角色、贡献度和加入时间。
class AllianceMemberModel {
  /// 成员用户 ID
  final String userId;

  /// 成员昵称
  final String nickname;

  /// 联盟角色（leader/viceLeader/elder/member）
  final String role;

  /// 贡献度
  final int contribution;

  /// 加入时间戳（毫秒）
  final int joinedAt;

  /// 等级
  final int level;

  /// 战力
  final int power;

  const AllianceMemberModel({
    required this.userId,
    required this.nickname,
    this.role = 'member',
    this.contribution = 0,
    this.joinedAt = 0,
    this.level = 1,
    this.power = 0,
  });

  factory AllianceMemberModel.fromJson(Map<String, dynamic> json) {
    return AllianceMemberModel(
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      role: json['role'] as String? ?? 'member',
      contribution: (json['contribution'] as num?)?.toInt() ?? 0,
      joinedAt: (json['joined_at'] as num?)?.toInt() ?? (json['joinedAt'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      power: (json['power'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'nickname': nickname,
        'role': role,
        'contribution': contribution,
        'joined_at': joinedAt,
        'level': level,
        'power': power,
      };

  AllianceMemberModel copyWith({
    String? userId,
    String? nickname,
    String? role,
    int? contribution,
    int? joinedAt,
    int? level,
    int? power,
  }) {
    return AllianceMemberModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      role: role ?? this.role,
      contribution: contribution ?? this.contribution,
      joinedAt: joinedAt ?? this.joinedAt,
      level: level ?? this.level,
      power: power ?? this.power,
    );
  }
}
