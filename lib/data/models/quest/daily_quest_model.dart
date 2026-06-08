import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_quest_model.freezed.dart';
part 'daily_quest_model.g.dart';

/// 日常任务数据模型（DTO）
///
/// 表示每日刷新的任务，包含活跃度进度和宝箱奖励。
@freezed
@JsonSerializable()
class DailyQuestModel with _$DailyQuestModel {
  const factory DailyQuestModel({
    /// 日常任务唯一标识
    required String id,

    /// 任务名称
    required String name,

    /// 任务描述
    String? description,

    /// 任务目标值
    required int targetValue,

    /// 当前进度
    @Default(0) int currentProgress,

    /// 活跃度奖励
    @Default(0) int activityReward,

    /// 是否已完成
    @Default(false) bool completed,

    /// 是否已领取奖励
    @Default(false) bool claimed,

    /// 每日重置时间戳（毫秒）
    @Default(0) int resetAt,
  }) = _DailyQuestModel;

  factory DailyQuestModel.fromJson(Map<String, dynamic> json) =>
      _$DailyQuestModelFromJson(json);
}
