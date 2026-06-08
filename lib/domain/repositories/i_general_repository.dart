import '../../core/network/api_result.dart';
import '../entities/general.dart';

/// 武将仓库接口
///
/// 提供武将管理相关操作，包括查询、升级、进阶、觉醒、升星和战力计算。
abstract class IGeneralRepository {
  /// 获取武将列表
  ///
  /// 获取当前玩家拥有的所有武将信息。
  Future<ApiResult<List<General>>> getList();

  /// 获取武将详情
  ///
  /// 根据武将 ID [generalId] 获取武将的详细信息。
  Future<ApiResult<General>> getDetail(String generalId);

  /// 升级武将
  ///
  /// 消耗经验书等道具提升武将等级。
  /// [generalId] 为目标武将 ID。
  Future<ApiResult<General>> upgrade(String generalId);

  /// 进阶武将
  ///
  /// 消耗进阶石等道具提升武将品质。
  /// [generalId] 为目标武将 ID。
  Future<ApiResult<General>> evolve(String generalId);

  /// 觉醒武将
  ///
  /// 消耗觉醒石等道具觉醒武将，解锁额外能力。
  /// [generalId] 为目标武将 ID。
  Future<ApiResult<General>> awake(String generalId);

  /// 武将升星
  ///
  /// 消耗武将碎片提升武将星级（1-7）。
  /// [generalId] 为目标武将 ID。
  Future<ApiResult<General>> starUp(String generalId);

  /// 计算武将战力
  ///
  /// 根据武将属性、装备、羁绊等综合计算战力值。
  /// [generalId] 为目标武将 ID。
  Future<ApiResult<int>> calculatePower(String generalId);
}
