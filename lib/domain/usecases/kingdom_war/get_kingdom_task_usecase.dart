import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_kingdom_war_repository.dart';

/// 获取国战任务用例
///
/// 获取当前国战中的可接取任务列表。
/// 国战任务包括攻占指定城市、击杀敌方武将等，完成后可获得奖励。
@injectable
class GetKingdomTaskUseCase {
  final IKingdomWarRepository _repository;

  /// 创建获取国战任务用例实例
  GetKingdomTaskUseCase(this._repository);

  /// 执行获取国战任务操作
  ///
  /// 返回包含任务列表的 [ApiResult]
  Future<ApiResult<List<Map<String, dynamic>>>> call() =>
      throw UnimplementedError();
}
