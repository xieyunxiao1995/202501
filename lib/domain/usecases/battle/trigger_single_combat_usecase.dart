import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 触发单挑用例
///
/// 战斗中满足特定条件时触发武将单挑事件。
/// 单挑为1v1对决，胜负影响战斗全局士气。
@injectable
class TriggerSingleCombatUseCase {
  final IBattleRepository _repository;

  /// 创建触发单挑用例实例
  TriggerSingleCombatUseCase(this._repository);

  /// 执行触发单挑操作
  ///
  /// [battleId] 战斗 ID
  /// [challengerId] 挑战方武将 ID
  /// [defenderId] 应战方武将 ID
  /// 返回包含更新后战斗状态的 [ApiResult]
  Future<ApiResult<Battle>> call({
    required String battleId,
    required String challengerId,
    required String defenderId,
  }) =>
      throw UnimplementedError();
}
