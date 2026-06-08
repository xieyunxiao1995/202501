import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_lineup_repository.dart';

/// 验证阵容用例
///
/// 验证阵容配置是否合法，包括武将数量、重复武将检查等。
/// 非法阵容无法用于战斗。
@injectable
class ValidateLineupUseCase {
  final ILineupRepository _repository;

  /// 创建验证阵容用例实例
  ValidateLineupUseCase(this._repository);

  /// 执行验证阵容操作
  ///
  /// [lineupId] 阵容 ID
  /// 返回包含验证结果的 [ApiResult]，true 表示合法
  Future<ApiResult<bool>> call(String lineupId) =>
      throw UnimplementedError();
}
