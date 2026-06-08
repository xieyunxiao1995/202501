import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/building.dart';
import '../../repositories/i_city_repository.dart';

/// 加速建筑用例
///
/// 消耗加速道具或元宝，立即完成建筑的升级进程。
/// 加速后建筑立即生效，无需等待建造时间。
@injectable
class SpeedUpBuildingUseCase {
  final ICityRepository _repository;

  /// 创建加速建筑用例实例
  SpeedUpBuildingUseCase(this._repository);

  /// 执行加速建筑操作
  ///
  /// [buildingId] 建筑 ID
  /// 返回包含加速后建筑的 [ApiResult]
  Future<ApiResult<Building>> call(String buildingId) =>
      throw UnimplementedError();
}
