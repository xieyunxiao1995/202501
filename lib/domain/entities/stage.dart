import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage.freezed.dart';
part 'stage.g.dart';

/// 关卡实体
///
/// 表示游戏中的闯关关卡，隶属于某一章节。
/// 关卡包含难度、等级要求、敌方阵容、通关奖励和星级评价等信息。
@freezed
class Stage with _$Stage {
  const factory Stage({
    /// 关卡唯一标识
    required String id,

    /// 所属章节 ID
    required String chapterId,

    /// 关卡名称
    required String name,

    /// 难度等级
    @Default(1) int difficulty,

    /// 通关所需等级
    @Default(1) int requiredLevel,

    /// 敌方阵容配置（武将 ID 列表）
    @Default([]) List<String> enemyLineup,

    /// 通关奖励（道具 ID 到数量的映射）
    @Default({}) Map<String, int> rewards,

    /// 是否已通关
    @Default(false) bool isCleared,

    /// 星级评价（0-3）
    @Default(0) int starCount,
  }) = _Stage;

  factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);
}
