import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_city_repository.dart';

/// 收集资源用例
///
/// 收集指定建筑产出的资源，如铜钱、粮草、铁矿等。
/// 资源产出随时间累积，有存储上限，需及时收取。
@injectable
class CollectResourceUseCase {
  final ICityRepository _repository;

  /// 创建收集资源用例实例
  CollectResourceUseCase(this._repository);

  /// 执行收集资源操作
  ///
  /// [buildingId] 建筑 ID
  /// 返回包含收取资源数量的 [ApiResult]（资源类型到数量的映射）
  Future<ApiResult<Map<String, int>>> call(String buildingId) =>
      throw UnimplementedError();
}
