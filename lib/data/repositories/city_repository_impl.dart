import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/i_city_repository.dart';
import '../datasources/remote/city_api.dart';

/// 主城仓库实现
///
/// 实现主城管理相关业务逻辑，协调远程 API，
/// 处理主城信息查询、建筑建造升级、资源收集和加速等操作。
@LazySingleton(as: ICityRepository)
class CityRepositoryImpl implements ICityRepository {
  final CityApi _cityApi;

  CityRepositoryImpl(this._cityApi);

  @override
  Future<ApiResult<City>> getCityInfo() async {
    // TODO: 调用 _cityApi.getCity，转换为 City 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Building>> buildBuilding(String buildingType) async {
    // TODO: 调用 API 建造指定类型的建筑，转换为 Building 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Building>> upgradeBuilding(String buildingId) async {
    // TODO: 调用 _cityApi.upgradeBuilding，转换为 Building 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, int>>> collectResource(String buildingId) async {
    // TODO: 调用 _cityApi.collectResources，返回收集的资源数量
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Building>> speedUp(String buildingId) async {
    // TODO: 调用 _cityApi.speedUpUpgrade，转换为 Building 实体
    throw UnimplementedError();
  }
}
