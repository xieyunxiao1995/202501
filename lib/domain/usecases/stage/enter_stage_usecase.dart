import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/stage.dart';
import '../../repositories/i_stage_repository.dart';

/// 进入关卡用例
///
/// 进入指定关卡开始战斗。需满足关卡解锁条件（前置关卡通关、等级要求等）。
@injectable
class EnterStageUseCase {
  final IStageRepository _repository;

  /// 创建进入关卡用例实例
  EnterStageUseCase(this._repository);

  /// 执行进入关卡操作
  ///
  /// [stageId] 关卡 ID
  /// 返回包含关卡战斗信息的 [ApiResult]
  Future<ApiResult<Stage>> call(String stageId) =>
      throw UnimplementedError();
}
