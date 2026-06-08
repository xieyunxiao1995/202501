import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_pvp_repository.dart';

/// Ban/Pick 用例
///
/// 在 Ban/Pick 模式中进行武将禁用或选择操作。
/// 双方交替进行 Ban 和 Pick，最终确定出战阵容。
@injectable
class BanPickUseCase {
  final IPvpRepository _repository;

  /// 创建 Ban/Pick 用例实例
  BanPickUseCase(this._repository);

  /// 执行 Ban/Pick 操作
  ///
  /// [action] 操作类型（ban / pick）
  /// [generalId] 目标武将 ID
  /// 返回包含当前 Ban/Pick 状态的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call(
    String action,
    String generalId,
  ) =>
      throw UnimplementedError();
}
