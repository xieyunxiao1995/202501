import '../../shared/enums/title.dart' as enums;

/// 用户实体
///
/// 表示当前登录用户的基本信息，包括等级、爵位、战力等。
class User {
  /// 用户唯一标识
  final String id;

  /// 用户昵称
  final String name;

  /// 用户等级，默认 1
  final int level;

  /// VIP 等级，默认 0
  final int vipLevel;

  /// 爵位，默认白身
  final enums.Title title;

  /// 头像路径
  final String? avatar;

  /// 经验值，默认 0
  final int exp;

  /// 战力值，默认 0
  final int power;

  const User({
    required this.id,
    required this.name,
    this.level = 1,
    this.vipLevel = 0,
    this.title = enums.Title.commoner,
    this.avatar,
    this.exp = 0,
    this.power = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      level: (json['level'] as num?)?.toInt() ?? 1,
      vipLevel: (json['vipLevel'] as num? ?? json['vip_level'] as num?)?.toInt() ?? 0,
      title: json['title'] != null
          ? enums.Title.fromJson(json['title'] as String)
          : enums.Title.commoner,
      avatar: json['avatar'] as String?,
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      power: (json['power'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'vipLevel': vipLevel,
        'title': title.toJson(),
        'avatar': avatar,
        'exp': exp,
        'power': power,
      };

  User copyWith({
    String? id,
    String? name,
    int? level,
    int? vipLevel,
    enums.Title? title,
    String? avatar,
    int? exp,
    int? power,
  }) {
    return User(
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
