import 'package:freezed_annotation/freezed_annotation.dart';

part 'battle_result_model.freezed.dart';
part 'battle_result_model.g.dart';

/// 战斗结果数据模型（DTO）
///
/// 表示战斗结束后的结算数据，包含胜负、奖励、MVP武将和伤害统计。
@freezed
@JsonSerializable()
class BattleResultModel with _$BattleResultModel {
  const factory BattleResultModel({
    /// 战斗 ID
    required String battleId,

    /// 是否胜利
    required bool isVictory,

    /// 奖励列表（键值对：物品ID -> 数量）
    @Default({}) Map<String, int> rewards,

    /// MVP 武将 ID
    String? mvpGeneralId,

    /// 总伤害值
    @Default(0) int damageDealt,
  }) = _BattleResultModel;

  factory BattleResultModel.fromJson(Map<String, dynamic> json) =>
      _$BattleResultModelFromJson(json);
}
