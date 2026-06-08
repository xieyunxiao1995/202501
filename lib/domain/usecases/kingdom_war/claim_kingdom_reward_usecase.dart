import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_kingdom_war_repository.dart';

/// 领取国战奖励用例
///
/// 领取已完成的国战任务奖励。
/// 奖励包括铜钱、元宝、武将碎片等。
@injectable
class ClaimKingdomRewardUseCase {
  final IKingdomWarRepository _repository;

  /// 创建领取国战奖励用例实例
  ClaimKingdomRewardUseCase(this._repository);

  /// 执行领取国战奖励操作
  ///
  /// [taskId] 任务 ID
  /// 返回包含奖励内容的 [ApiResult]（道具 ID 到数量的映射）
  Future<ApiResult<Map<String, int>>> call(String taskId) =>
      throw UnimplementedError();
}
