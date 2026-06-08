import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_pvp_repository.dart';

/// 匹配 PVP 用例
///
/// 根据战力范围匹配 PVP 对手，匹配成功后进入对战准备。
/// 匹配采用 ELO 评分机制，尽量匹配实力相近的对手。
@injectable
class MatchPvpUseCase {
  final IPvpRepository _repository;

  /// 创建匹配 PVP 用例实例
  MatchPvpUseCase(this._repository);

  /// 执行匹配 PVP 操作
  ///
  /// 返回包含匹配结果的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call() =>
      throw UnimplementedError();
}
