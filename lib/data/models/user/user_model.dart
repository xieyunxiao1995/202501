import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 用户数据模型（DTO）
///
/// 对应 [User] 实体，面向 API 契约的用户数据传输对象。
/// 包含用户基本信息：ID、昵称、等级、VIP等级、爵位、头像、经验值、战力。
@freezed
@JsonSerializable()
class UserModel with _$UserModel {
  const factory UserModel({
    /// 用户唯一标识
    required String id,

    /// 用户昵称
    required String name,

    /// 用户等级
    @Default(1) int level,

    /// VIP 等级
    @Default(0) int vipLevel,

    /// 爵位标识
    @Default('commoner') String title,

    /// 头像路径
    String? avatar,

    /// 经验值
    @Default(0) int exp,

    /// 战力值
    @Default(0) int power,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
