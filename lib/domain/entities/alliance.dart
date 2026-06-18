/// 联盟实体
///
/// 表示游戏中的玩家联盟（公会），包含联盟基本信息和成员管理。
/// 玩家可加入联盟参与国战等联盟活动。
class Alliance {
  /// 联盟唯一标识
  final String id;

  /// 联盟名称
  final String name;

  /// 联盟等级
  final int level;

  /// 盟主用户 ID
  final String leaderId;

  /// 当前成员数量
  final int memberCount;

  /// 最大成员数量
  final int maxMembers;

  /// 联盟描述
  final String description;

  /// 联盟公告
  final String notice;

  const Alliance({
    required this.id,
    required this.name,
    this.level = 1,
    required this.leaderId,
    this.memberCount = 1,
    this.maxMembers = 30,
    this.description = '',
    this.notice = '',
  });

  factory Alliance.fromJson(Map<String, dynamic> json) {
    return Alliance(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      leaderId: json['leader_id'] as String? ?? (json['leaderId'] as String? ?? ''),
      memberCount: (json['member_count'] as num?)?.toInt() ?? (json['memberCount'] as num?)?.toInt() ?? 1,
      maxMembers: (json['max_members'] as num?)?.toInt() ?? (json['maxMembers'] as num?)?.toInt() ?? 30,
      description: json['description'] as String? ?? '',
      notice: json['notice'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'leader_id': leaderId,
        'member_count': memberCount,
        'max_members': maxMembers,
        'description': description,
        'notice': notice,
      };

  Alliance copyWith({
    String? id,
    String? name,
    int? level,
    String? leaderId,
    int? memberCount,
    int? maxMembers,
    String? description,
    String? notice,
  }) {
    return Alliance(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      leaderId: leaderId ?? this.leaderId,
      memberCount: memberCount ?? this.memberCount,
      maxMembers: maxMembers ?? this.maxMembers,
      description: description ?? this.description,
      notice: notice ?? this.notice,
    );
  }
}
