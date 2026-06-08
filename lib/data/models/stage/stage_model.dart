import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage_model.freezed.dart';
part 'stage_model.g.dart';

/// 关卡数据模型（DTO）
///
/// 表示游戏中的单个关卡配置，包含关卡名称、难度、敌人和奖励等信息。
@freezed
@JsonSerializable()
class StageModel with _$StageModel {
  const factory StageModel({
    /// 关卡唯一标识
    required String id,

    /// 所属章节 ID
    required String chapterId,

    /// 关卡名称
    required String name,

    /// 难度等级
    @Default(1) int difficulty,

    /// 敌方武将 ID 列表
    @Default([]) List<String> enemyGeneralIds,

    /// 推荐战力
    @Default(0) int recommendedPower,

    /// 通关奖励（物品ID -> 数量）
    @Default({}) Map<String, int> rewards,

    /// 是否已通关
    @Default(false) bool cleared,

    /// 是否已三星通关
    @Default(false) bool threeStarred,
  }) = _StageModel;

  factory StageModel.fromJson(Map<String, dynamic> json) =>
      _$StageModelFromJson(json);
}
