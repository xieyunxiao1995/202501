import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_shop_repository.dart';

/// 获取战令进度用例
///
/// 获取当前赛季战令的进度信息，包括等级、奖励解锁状态和任务完成情况。
/// 战令通过完成日常和周常任务获取经验升级，解锁对应等级奖励。
@injectable
class GetBattlePassProgressUseCase {
  final IShopRepository _repository;

  /// 创建获取战令进度用例实例
  GetBattlePassProgressUseCase(this._repository);

  /// 执行获取战令进度操作
  ///
  /// 返回包含战令进度的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call() =>
      throw UnimplementedError();
}
