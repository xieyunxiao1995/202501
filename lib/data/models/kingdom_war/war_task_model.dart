import 'package:freezed_annotation/freezed_annotation.dart';

part 'war_task_model.freezed.dart';
part 'war_task_model.g.dart';

/// 国战任务数据模型（DTO）
///
/// 表示国战中的任务配置，包含任务目标、进度和奖励。
@freezed
@JsonSerializable()
class WarTaskModel with _$WarTaskModel {
  const factory WarTaskModel({
    /// 任务唯一标识
    required String id,

    /// 任务名称
    required String name,

    /// 任务描述
    String? description,

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
  }) = _WarTaskModel;

  factory WarTaskModel.fromJson(Map<String, dynamic> json) =>
      _$WarTaskModelFromJson(json);
}
