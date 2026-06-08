import 'package:freezed_annotation/freezed_annotation.dart';

part 'battle_state_model.freezed.dart';
part 'battle_state_model.g.dart';

/// 战斗状态数据模型（DTO）
///
/// 表示战斗中某一回合的状态快照，包含武将状态、活跃增益和羁绊效果。
@freezed
@JsonSerializable()
class BattleStateModel with _$BattleStateModel {
  const factory BattleStateModel({
    /// 当前回合数
    required int round,

    /// 武将状态列表（武将ID -> 状态数据）
    @Default({}) Map<String, dynamic> generalStates,

    /// 活跃增益效果列表
    @Default([]) List<String> activeBuffs,

    /// 活跃羁绊效果列表
    @Default([]) List<String> activeBonds,
  }) = _BattleStateModel;

  factory BattleStateModel.fromJson(Map<String, dynamic> json) =>
      _$BattleStateModelFromJson(json);
}
