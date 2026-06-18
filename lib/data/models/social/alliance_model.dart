/// 联盟数据模型（DTO）
///
/// 表示联盟（公会）信息，包含联盟名称、等级和成员列表。
class AllianceModel {
  /// 联盟唯一标识
  final String id;

  /// 联盟名称
  final String name;

  /// 联盟等级
  final int level;

  /// 联盟公告
  final String? announcement;

  /// 会长 ID
  final String leaderId;

  /// 成员 ID 列表
  final List<String> memberIds;

  /// 最大成员数
  final int maxMembers;

  /// 联盟战力
  final int totalPower;

  const AllianceModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.announcement,
    required this.leaderId,
    this.memberIds = const [],
    this.maxMembers = 30,
    this.totalPower = 0,
  });

  factory AllianceModel.fromJson(Map<String, dynamic> json) {
    return AllianceModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      announcement: json['announcement'] as String?,
      leaderId: json['leader_id'] as String? ?? json['leaderId'] as String? ?? '',
      memberIds: (json['member_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxMembers: (json['max_members'] as num?)?.toInt() ?? (json['maxMembers'] as num?)?.toInt() ?? 30,
      totalPower: (json['total_power'] as num?)?.toInt() ?? (json['totalPower'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        if (announcement != null) 'announcement': announcement,
        'leader_id': leaderId,
        'member_ids': memberIds,
        'max_members': maxMembers,
        'total_power': totalPower,
      };

  AllianceModel copyWith({
    String? id,
    String? name,
    int? level,
    String? announcement,
    String? leaderId,
    List<String>? memberIds,
    int? maxMembers,
    int? totalPower,
  }) {
    return AllianceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      announcement: announcement ?? this.announcement,
      leaderId: leaderId ?? this.leaderId,
      memberIds: memberIds ?? this.memberIds,
      maxMembers: maxMembers ?? this.maxMembers,
      totalPower: totalPower ?? this.totalPower,
    );
  }
}
