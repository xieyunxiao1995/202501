import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

/// 成就数据模型（DTO）
///
/// 表示游戏成就配置，包含成就目标、阶段和奖励。
@freezed
@JsonSerializable()
class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    /// 成就唯一标识
    required String id,

    /// 成就名称
    required String name,

    /// 成就描述
    String? description,

    /// 成就分类
    required String category,

    /// 当前阶段（1-N）
    @Default(1) int stage,

    /// 最大阶段
    @Default(1) int maxStage,

    /// 各阶段目标值列表
    @Default([]) List<int> stageTargets,

    /// 当前进度
    @Default(0) int currentProgress,

    /// 奖励列表（物品ID -> 数量）
    @Default({}) Map<String, int> rewards,

    /// 是否已完成全部阶段
    @Default(false) bool completed,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}
