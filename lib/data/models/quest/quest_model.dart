import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_model.freezed.dart';
part 'quest_model.g.dart';

/// 任务数据模型（DTO）
///
/// 表示游戏中的任务配置，包含任务目标、进度和奖励。
@freezed
@JsonSerializable()
class QuestModel with _$QuestModel {
  const factory QuestModel({
    /// 任务唯一标识
    required String id,

    /// 任务名称
    required String name,

    /// 任务描述
    String? description,

    /// 任务类型标识
    required String type,

    /// 任务目标值
    required int targetValue,

    /// 当前进度
    @Default(0) int currentProgress,

    /// 奖励列表（物品ID -> 数量）
    @Default({}) Map<String, int> rewards,

    /// 是否已完成
    @Default(false) bool completed,

    /// 是否已领取奖励
    @Default(false) bool claimed,
  }) = _QuestModel;

  factory QuestModel.fromJson(Map<String, dynamic> json) =>
      _$QuestModelFromJson(json);
}
