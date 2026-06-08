import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/building.dart';
import '../../repositories/i_city_repository.dart';

/// 建造建筑用例
///
/// 在主城中建造指定类型的新建筑。
/// 建造需消耗资源，且有建造时间，可使用加速道具缩短。
@injectable
class BuildBuildingUseCase {
  final ICityRepository _repository;

  /// 创建建造建筑用例实例
  BuildBuildingUseCase(this._repository);

  /// 执行建造建筑操作
  ///
  /// [buildingType] 建筑类型
  /// 返回包含新建建筑的 [ApiResult]
  Future<ApiResult<Building>> call(String buildingType) =>
      throw UnimplementedError();
}
