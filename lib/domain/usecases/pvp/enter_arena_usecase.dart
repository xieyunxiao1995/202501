import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_pvp_repository.dart';

/// 进入竞技场用例
///
/// 进入竞技场界面，获取当前排名、挑战次数和对手列表。
/// 竞技场排名决定每日奖励数额。
@injectable
class EnterArenaUseCase {
  final IPvpRepository _repository;

  /// 创建进入竞技场用例实例
  EnterArenaUseCase(this._repository);

  /// 执行进入竞技场操作
  ///
  /// 返回包含竞技场信息的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call() =>
      throw UnimplementedError();
}
