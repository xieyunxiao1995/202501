import 'package:freezed_annotation/freezed_annotation.dart';

part 'battle_pass_model.freezed.dart';
part 'battle_pass_model.g.dart';

/// 通行证数据模型（DTO）
///
/// 表示赛季通行证配置，包含等级、经验、免费/付费奖励。
@freezed
@JsonSerializable()
class BattlePassModel with _$BattlePassModel {
  const factory BattlePassModel({
    /// 通行证唯一标识
    required String id,

    /// 赛季名称
    required String seasonName,

    /// 当前等级
    @Default(0) int currentLevel,

    /// 最大等级
    @Default(50) int maxLevel,

    /// 当前经验值
    @Default(0) int currentExp,

    /// 每级所需经验
    @Default(1000) int expPerLevel,

    /// 是否已购买高级通行证
    @Default(false) bool premium,

    /// 赛季开始时间戳（毫秒）
    @Default(0) int startTime,

    /// 赛季结束时间戳（毫秒）
    @Default(0) int endTime,
  }) = _BattlePassModel;

  factory BattlePassModel.fromJson(Map<String, dynamic> json) =>
      _$BattlePassModelFromJson(json);
}
