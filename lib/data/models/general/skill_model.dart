import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_model.freezed.dart';
part 'skill_model.g.dart';

/// 技能数据模型（DTO）
///
/// 表示武将技能的配置数据，包含技能类型、描述、伤害倍率、怒气消耗和目标数量等。
@freezed
@JsonSerializable()
class SkillModel with _$SkillModel {
  const factory SkillModel({
    /// 技能唯一标识
    required String id,

    /// 技能名称
    required String name,

    /// 技能类型标识（normal/active/ultimate/passive）
    required String type,

    /// 技能描述
    String? description,

    /// 伤害倍率（百分比）
    @Default(0) double damageMultiplier,

    /// 怒气消耗
    @Default(0) int rageCost,

    /// 目标数量
    @Default(1) int targetCount,

    /// 技能等级
    @Default(1) int level,
  }) = _SkillModel;

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);
}
