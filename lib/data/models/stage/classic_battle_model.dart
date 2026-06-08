import 'package:freezed_annotation/freezed_annotation.dart';

part 'classic_battle_model.freezed.dart';
part 'classic_battle_model.g.dart';

/// 经典战役数据模型（DTO）
///
/// 表示历史上的经典战役关卡，包含战役背景、参战武将和星级评价。
@freezed
@JsonSerializable()
class ClassicBattleModel with _$ClassicBattleModel {
  const factory ClassicBattleModel({
    /// 战役唯一标识
    required String id,

    /// 战役名称
    required String name,

    /// 战役背景描述
    String? background,

    /// 敌方武将 ID 列表
    @Default([]) List<String> enemyGeneralIds,

    /// 推荐战力
    @Default(0) int recommendedPower,

    /// 获得星数（0-3）
    @Default(0) int stars,

    /// 首次通关奖励
    @Default({}) Map<String, int> firstClearRewards,

    /// 是否已通关
    @Default(false) bool cleared,
  }) = _ClassicBattleModel;

  factory ClassicBattleModel.fromJson(Map<String, dynamic> json) =>
      _$ClassicBattleModelFromJson(json);
}
