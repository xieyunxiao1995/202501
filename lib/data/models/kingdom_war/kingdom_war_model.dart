import 'package:freezed_annotation/freezed_annotation.dart';

part 'kingdom_war_model.freezed.dart';
part 'kingdom_war_model.g.dart';

/// 国战数据模型（DTO）
///
/// 表示国战活动的整体状态，包含赛季、阶段和阵营积分。
@freezed
@JsonSerializable()
class KingdomWarModel with _$KingdomWarModel {
  const factory KingdomWarModel({
    /// 国战唯一标识
    required String id,

    /// 赛季编号
    required int season,

    /// 当前阶段（preparation/battle/settlement）
    @Default('preparation') String phase,

    /// 魏国积分
    @Default(0) int weiScore,

    /// 蜀国积分
    @Default(0) int shuScore,

    /// 吴国积分
    @Default(0) int wuScore,

    /// 开始时间戳（毫秒）
    @Default(0) int startTime,

    /// 结束时间戳（毫秒）
    @Default(0) int endTime,
  }) = _KingdomWarModel;

  factory KingdomWarModel.fromJson(Map<String, dynamic> json) =>
      _$KingdomWarModelFromJson(json);
}
