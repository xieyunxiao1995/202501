import 'package:freezed_annotation/freezed_annotation.dart';

part 'alliance_member_model.freezed.dart';
part 'alliance_member_model.g.dart';

/// 联盟成员数据模型（DTO）
///
/// 表示联盟中的成员信息，包含成员角色、贡献度和加入时间。
@freezed
@JsonSerializable()
class AllianceMemberModel with _$AllianceMemberModel {
  const factory AllianceMemberModel({
    /// 成员用户 ID
    required String userId,

    /// 成员昵称
    required String nickname,

    /// 联盟角色（leader/viceLeader/elder/member）
    @Default('member') String role,

    /// 贡献度
    @Default(0) int contribution,

    /// 加入时间戳（毫秒）
    @Default(0) int joinedAt,

    /// 等级
    @Default(1) int level,

    /// 战力
    @Default(0) int power,
  }) = _AllianceMemberModel;

  factory AllianceMemberModel.fromJson(Map<String, dynamic> json) =>
      _$AllianceMemberModelFromJson(json);
}
