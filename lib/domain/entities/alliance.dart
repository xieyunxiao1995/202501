import 'package:freezed_annotation/freezed_annotation.dart';

part 'alliance.freezed.dart';
part 'alliance.g.dart';

/// 联盟实体
///
/// 表示游戏中的玩家联盟（公会），包含联盟基本信息和成员管理。
/// 玩家可加入联盟参与国战等联盟活动。
@freezed
class Alliance with _$Alliance {
  const factory Alliance({
    /// 联盟唯一标识
    required String id,

    /// 联盟名称
    required String name,

    /// 联盟等级
    @Default(1) int level,

    /// 盟主用户 ID
    required String leaderId,

    /// 当前成员数量
    @Default(1) int memberCount,

    /// 最大成员数量
    @Default(30) int maxMembers,

    /// 联盟描述
    @Default('') String description,

    /// 联盟公告
    @Default('') String notice,
  }) = _Alliance;

  factory Alliance.fromJson(Map<String, dynamic> json) =>
      _$AllianceFromJson(json);
}
