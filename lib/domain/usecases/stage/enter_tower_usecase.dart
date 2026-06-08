import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_stage_repository.dart';

/// 进入爬塔用例
///
/// 进入逐层挑战的爬塔模式，每层难度递增。
/// 爬塔奖励丰厚，每层首次通关可获得额外奖励。
@injectable
class EnterTowerUseCase {
  final IStageRepository _repository;

  /// 创建进入爬塔用例实例
  EnterTowerUseCase(this._repository);

  /// 执行进入爬塔操作
  ///
  /// 返回包含爬塔信息的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call() =>
      throw UnimplementedError();
}
