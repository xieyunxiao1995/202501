import '../../core/network/api_result.dart';
import '../entities/battle.dart';

/// 战斗仓库接口
///
/// 提供战斗相关操作，包括开始战斗、结束战斗和战斗回放。
abstract class IBattleRepository {
  /// 开始战斗
  ///
  /// 以我方阵容 [lineupId] 对战敌方阵容 [enemyLineupId]，
  /// 创建并返回新的战斗实例。
  Future<ApiResult<Battle>> startBattle(String lineupId, String enemyLineupId);

  /// 结束战斗
  ///
  /// 结束指定 [battleId] 的战斗，结算战斗结果。
  Future<ApiResult<Battle>> endBattle(String battleId);

  /// 获取战斗回放
  ///
  /// 获取指定 [battleId] 的战斗回放数据。
  Future<ApiResult<Battle>> getReplay(String battleId);

  /// 保存战斗回放
  ///
  /// 保存指定 [battleId] 的战斗回放，供后续查看。
  Future<ApiResult<void>> saveReplay(String battleId);
}
