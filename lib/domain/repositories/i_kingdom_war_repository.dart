import '../../core/network/api_result.dart';
import '../entities/kingdom_war.dart';

/// 国战仓库接口
///
/// 提供国战相关操作，包括地图查询、攻城、守城、任务和奖励。
abstract class IKingdomWarRepository {
  /// 获取国战地图
  ///
  /// 获取国战战场地图信息，包括各城市的状态和控制方。
  Future<ApiResult<KingdomWar>> getMap();

  /// 攻击城市
  ///
  /// 向指定 [cityId] 的城市发起攻击，争夺控制权。
  Future<ApiResult<KingdomWar>> attackCity(String cityId);

  /// 防守城市
  ///
  /// 参与指定 [cityId] 城市的防守，抵御敌方进攻。
  Future<ApiResult<KingdomWar>> defendCity(String cityId);

  /// 获取国战任务
  ///
  /// 获取当前国战中的可接取任务列表。
  Future<ApiResult<List<Map<String, dynamic>>>> getTasks();

  /// 领取国战奖励
  ///
  /// 领取指定 [taskId] 的国战任务奖励。
  Future<ApiResult<Map<String, int>>> getRewards(String taskId);
}
