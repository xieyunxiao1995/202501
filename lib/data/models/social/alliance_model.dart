import 'package:freezed_annotation/freezed_annotation.dart';

part 'alliance_model.freezed.dart';
part 'alliance_model.g.dart';

/// 联盟数据模型（DTO）
///
/// 表示联盟（公会）信息，包含联盟名称、等级和成员列表。
@freezed
@JsonSerializable()
class AllianceModel with _$AllianceModel {
  const factory AllianceModel({
    /// 联盟唯一标识
    required String id,

    /// 联盟名称
    required String name,

    /// 联盟等级
    @Default(1) int level,

    /// 联盟公告
    String? announcement,

    /// 会长 ID
    required String leaderId,

    /// 成员 ID 列表
    @Default([]) List<String> memberIds,

    /// 最大成员数
    @Default(30) int maxMembers,

    /// 联盟战力
    @Default(0) int totalPower,
  }) = _AllianceModel;

  factory AllianceModel.fromJson(Map<String, dynamic> json) =>
      _$AllianceModelFromJson(json);
}
