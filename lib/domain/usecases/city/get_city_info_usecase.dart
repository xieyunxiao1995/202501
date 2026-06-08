import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/city.dart';
import '../../repositories/i_city_repository.dart';

/// 获取主城信息用例
///
/// 获取当前玩家主城的完整信息，包括所有建筑状态和资源产出情况。
@injectable
class GetCityInfoUseCase {
  final ICityRepository _repository;

  /// 创建获取主城信息用例实例
  GetCityInfoUseCase(this._repository);

  /// 执行获取主城信息操作
  ///
  /// 返回包含主城信息的 [ApiResult]
  Future<ApiResult<City>> call() => throw UnimplementedError();
}
