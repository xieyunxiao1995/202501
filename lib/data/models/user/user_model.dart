/// 用户数据模型（DTO）
///
/// 对应 [User] 实体，面向 API 契约的用户数据传输对象。
/// 包含用户基本信息：ID、昵称、等级、VIP等级、爵位、头像、经验值、战力。
class UserModel {
  /// 用户唯一标识
  final String id;

  /// 用户昵称
  final String name;

  /// 用户等级
  final int level;

  /// VIP 等级
  final int vipLevel;

  /// 爵位标识
  final String title;

  /// 头像路径
  final String? avatar;

  /// 经验值
  final int exp;

  /// 战力值
  final int power;

  const UserModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.vipLevel = 0,
    this.title = 'commoner',
    this.avatar,
    this.exp = 0,
    this.power = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      vipLevel: (json['vip_level'] as num?)?.toInt() ?? (json['vipLevel'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'commoner',
      avatar: json['avatar'] as String?,
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      power: (json['power'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'vip_level': vipLevel,
        'title': title,
        if (avatar != null) 'avatar': avatar,
        'exp': exp,
        'power': power,
      };

  UserModel copyWith({
    String? id,
    String? name,
    int? level,
    int? vipLevel,
    String? title,
    String? avatar,
    int? exp,
    int? power,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      vipLevel: vipLevel ?? this.vipLevel,
      title: title ?? this.title,
      avatar: avatar ?? this.avatar,
      exp: exp ?? this.exp,
      power: power ?? this.power,
    );
  }
}
