import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/building.dart';
import '../../repositories/i_city_repository.dart';

/// 升级建筑用例
///
/// 升级指定建筑，消耗资源提升建筑等级。
/// 建筑等级越高，产出资源和提供的功能越强。
@injectable
class UpgradeBuildingUseCase {
  final ICityRepository _repository;

  /// 创建升级建筑用例实例
  UpgradeBuildingUseCase(this._repository);

  /// 执行升级建筑操作
  ///
  /// [buildingId] 建筑 ID
  /// 返回包含升级后建筑的 [ApiResult]
  Future<ApiResult<Building>> call(String buildingId) =>
      throw UnimplementedError();
}
