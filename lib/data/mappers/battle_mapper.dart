import '../../domain/entities/battle.dart' as entity;
import '../../shared/enums/battle_status.dart';
import '../models/battle/battle_model.dart';
import '../models/battle/lineup_model.dart';

/// 战斗数据转换器
///
/// 负责在战斗数据模型（DTO）和领域实体之间进行双向转换。
/// Model 面向 API 契约使用字符串标识枚举，Entity 使用强类型枚举。
class BattleMapper {
  /// 将战斗数据模型转换为领域实体
  ///
  /// [model] 战斗数据传输对象
  /// 返回对应的战斗领域实体
  entity.Battle toEntity(BattleModel model) {
    return entity.Battle(
      id: model.id,
      lineupId: model.lineup.id,
      enemyLineupId: model.enemyLineup.id,
      currentRound: model.currentRound,
      maxRounds: model.maxRounds,
      status: BattleStatus.fromJson(model.status),
    );
  }

  /// 将战斗领域实体转换为数据模型
  ///
  /// [battle] 战斗领域实体
  /// 返回对应的数据传输对象
  /// 注意：转换时需要补充 LineupModel 数据，此处使用最小化构造
  BattleModel toModel(entity.Battle battle) {
    return BattleModel(
      id: battle.id,
      lineup: LineupModel(
        id: battle.lineupId,
        name: '',
        generalIds: [],
      ),
      enemyLineup: LineupModel(
        id: battle.enemyLineupId,
        name: '',
        generalIds: [],
      ),
      currentRound: battle.currentRound,
      maxRounds: battle.maxRounds,
      status: battle.status.toJson(),
    );
  }
}
