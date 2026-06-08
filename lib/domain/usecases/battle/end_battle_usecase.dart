import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 结束战斗用例
///
/// 结束指定战斗，结算战斗结果并发放奖励。
/// 战斗可能因一方全灭、达到最大回合数或玩家主动退出而结束。
@injectable
class EndBattleUseCase {
  final IBattleRepository _repository;

  /// 创建结束战斗用例实例
  EndBattleUseCase(this._repository);

  /// 执行结束战斗操作
  ///
  /// [battleId] 战斗 ID
  /// 返回包含结算结果的 [ApiResult]
  Future<ApiResult<Battle>> call(String battleId) =>
      throw UnimplementedError();
}
