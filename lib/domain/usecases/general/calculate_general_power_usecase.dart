import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_general_repository.dart';

/// 计算武将战力用例
///
/// 根据武将的综合属性、装备、星级等因素计算武将战力值。
/// 战力值用于排行榜和阵容推荐等场景。
@injectable
class CalculateGeneralPowerUseCase {
  final IGeneralRepository _repository;

  /// 创建计算武将战力用例实例
  CalculateGeneralPowerUseCase(this._repository);

  /// 执行计算武将战力操作
  ///
  /// [generalId] 武将唯一标识
  /// 返回包含战力值的 [ApiResult]
  Future<ApiResult<int>> call(String generalId) =>
      throw UnimplementedError();
}
