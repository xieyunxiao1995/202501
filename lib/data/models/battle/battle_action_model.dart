import 'package:freezed_annotation/freezed_annotation.dart';

part 'battle_action_model.freezed.dart';
part 'battle_action_model.g.dart';

/// 战斗行动数据模型（DTO）
///
/// 表示战斗中一个武将的单次行动，包含行动类型、目标、伤害和使用的技能/计谋。
@freezed
@JsonSerializable()
class BattleActionModel with _$BattleActionModel {
  const factory BattleActionModel({
    /// 执行行动的武将 ID
    required String generalId,

    /// 行动类型（attack/skill/tactic/buff/debuff）
    required String actionType,

    /// 目标武将 ID 列表
    @Default([]) List<String> targetIds,

    /// 造成伤害值
    @Default(0) int damage,

    /// 使用的技能 ID
    String? skillId,

    /// 使用的计谋 ID
    String? tacticId,
  }) = _BattleActionModel;

  factory BattleActionModel.fromJson(Map<String, dynamic> json) =>
      _$BattleActionModelFromJson(json);
}
