import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/stage.dart';
import '../../repositories/i_stage_repository.dart';

/// 扫荡关卡用例
///
/// 快速通关已三星通关的关卡，直接获得奖励。
/// 扫荡需消耗扫荡令或元宝，且有每日次数限制。
@injectable
class SweepStageUseCase {
  final IStageRepository _repository;

  /// 创建扫荡关卡用例实例
  SweepStageUseCase(this._repository);

  /// 执行扫荡关卡操作
  ///
  /// [stageId] 关卡 ID
  /// 返回包含扫荡结果的 [ApiResult]
  Future<ApiResult<Stage>> call(String stageId) =>
      throw UnimplementedError();
}
