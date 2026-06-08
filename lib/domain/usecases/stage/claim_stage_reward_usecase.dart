import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_stage_repository.dart';

/// 领取关卡奖励用例
///
/// 领取首次通关或星级评价奖励。
/// 三星通关可领取额外宝箱奖励。
@injectable
class ClaimStageRewardUseCase {
  final IStageRepository _repository;

  /// 创建领取关卡奖励用例实例
  ClaimStageRewardUseCase(this._repository);

  /// 执行领取关卡奖励操作
  ///
  /// [stageId] 关卡 ID
  /// 返回包含奖励内容的 [ApiResult]（道具 ID 到数量的映射）
  Future<ApiResult<Map<String, int>>> call(String stageId) =>
      throw UnimplementedError();
}
