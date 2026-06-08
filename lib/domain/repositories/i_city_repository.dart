import '../../core/network/api_result.dart';
import '../entities/city.dart';
import '../entities/building.dart';

/// 主城仓库接口
///
/// 提供主城管理相关操作，包括建筑建造、升级、资源收集和加速。
abstract class ICityRepository {
  /// 获取主城信息
  ///
  /// 获取当前玩家主城的完整信息，包括建筑和资源。
  Future<ApiResult<City>> getCityInfo();

  /// 建造建筑
  ///
  /// 在主城中建造指定 [buildingType] 类型的新建筑。
  Future<ApiResult<Building>> buildBuilding(String buildingType);

  /// 升级建筑
  ///
  /// 升级指定 [buildingId] 的建筑，消耗资源提升等级。
  Future<ApiResult<Building>> upgradeBuilding(String buildingId);

  /// 收集资源
  ///
  /// 收集指定 [buildingId] 建筑产出的资源。
  Future<ApiResult<Map<String, int>>> collectResource(String buildingId);

  /// 加速升级
  ///
  /// 消耗道具加速指定 [buildingId] 建筑的升级进程，立即完成升级。
  Future<ApiResult<Building>> speedUp(String buildingId);
}
