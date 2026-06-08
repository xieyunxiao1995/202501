import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_stage_repository.dart';

/// 进入经典战役用例
///
/// 进入经典战役模式，挑战历史名将的经典战役。
/// 经典战役有独立的难度和奖励体系。
@injectable
class EnterClassicBattleUseCase {
  final IStageRepository _repository;

  /// 创建进入经典战役用例实例
  EnterClassicBattleUseCase(this._repository);

  /// 执行进入经典战役操作
  ///
  /// 返回包含经典战役信息的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call() =>
      throw UnimplementedError();
}
