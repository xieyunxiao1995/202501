import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/skill_type.dart' as enums;
import '../../shared/enums/buff_type.dart' as enums;

part 'skill.freezed.dart';
part 'skill.g.dart';

/// 技能实体
///
/// 表示武将所拥有的技能，包括普攻、战法、大招和被动技能。
/// 技能可附带 Buff 效果，并具有伤害倍率、怒气消耗等属性。
@freezed
class Skill with _$Skill {
  const factory Skill({
    /// 技能唯一标识
    required String id,

    /// 技能名称
    required String name,

    /// 技能类型（普攻/战法/大招/被动）
    required enums.SkillType type,

    /// 技能描述
    @Default('') String description,

    /// 伤害倍率
    @Default(0.0) double damageMultiplier,

    /// 怒气消耗
    @Default(0) int rageCost,

    /// 目标数量
    @Default(1) int targetCount,

    /// 附带 Buff 类型，可为空
    enums.BuffType? buffType,

    /// Buff 持续回合数
    @Default(0) int buffDuration,

    /// 技能等级
    @Default(1) int level,

    /// 技能最大等级
    @Default(10) int maxLevel,
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}
