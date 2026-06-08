import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/tactic_type.dart' as enums;

part 'tactic.freezed.dart';
part 'tactic.g.dart';

/// 计谋实体
///
/// 表示武将可使用的计谋，如火攻、水攻、空城计等。
/// 计谋在战斗中由特定条件触发，产生持续性效果。
@freezed
class Tactic with _$Tactic {
  const factory Tactic({
    /// 计谋唯一标识
    required String id,

    /// 计谋名称
    required String name,

    /// 计谋类型（火攻/水攻/空城计/离间计/苦肉计/借刀杀人/诱敌深入/声东击西）
    required enums.TacticType type,

    /// 计谋描述
    @Default('') String description,

    /// 触发条件
    @Default('') String triggerCondition,

    /// 效果数值
    @Default(0.0) double effectValue,

    /// 持续回合数
    @Default(0) int duration,

    /// 冷却回合数
    @Default(0) int cooldown,

    /// 计谋等级
    @Default(1) int level,
  }) = _Tactic;

  factory Tactic.fromJson(Map<String, dynamic> json) => _$TacticFromJson(json);
}
