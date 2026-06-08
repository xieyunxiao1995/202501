import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/title.dart' as enums;

part 'user.freezed.dart';
part 'user.g.dart';

/// 用户实体
///
/// 表示当前登录用户的基本信息，包括等级、爵位、战力等。
@freezed
class User with _$User {
  const factory User({
    /// 用户唯一标识
    required String id,

    /// 用户昵称
    required String name,

    /// 用户等级，默认 1
    @Default(1) int level,

    /// VIP 等级，默认 0
    @Default(0) int vipLevel,

    /// 爵位，默认白身
    @Default(enums.Title.commoner) enums.Title title,

    /// 头像路径
    String? avatar,

    /// 经验值，默认 0
    @Default(0) int exp,

    /// 战力值，默认 0
    @Default(0) int power,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
