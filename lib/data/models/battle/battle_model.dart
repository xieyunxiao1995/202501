import 'package:freezed_annotation/freezed_annotation.dart';
import 'lineup_model.dart';

part 'battle_model.freezed.dart';
part 'battle_model.g.dart';

/// 战斗数据模型（DTO）
///
/// 表示一场战斗的完整数据，包含双方阵容、回合信息和战斗状态。
@freezed
@JsonSerializable()
class BattleModel with _$BattleModel {
  const factory BattleModel({
    /// 战斗唯一标识
    required String id,

    /// 己方阵容
    required LineupModel lineup,

    /// 敌方阵容
    required LineupModel enemyLineup,

    /// 当前回合数
    @Default(0) int currentRound,

    /// 最大回合数
    @Default(10) int maxRounds,

    /// 战斗状态标识（idle/preparing/inProgress/paused/ended）
    @Default('idle') String status,
  }) = _BattleModel;

  factory BattleModel.fromJson(Map<String, dynamic> json) =>
      _$BattleModelFromJson(json);
}
