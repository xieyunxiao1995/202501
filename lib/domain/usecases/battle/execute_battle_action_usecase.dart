import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 执行战斗行动用例
///
/// 在战斗中执行一个行动，包括普攻、战法释放、大招释放等。
/// 行动执行后更新战斗状态，计算伤害并推进回合。
@injectable
class ExecuteBattleActionUseCase {
  final IBattleRepository _repository;

  /// 创建执行战斗行动用例实例
  ExecuteBattleActionUseCase(this._repository);

  /// 执行战斗行动操作
  ///
  /// [battleId] 战斗 ID
  /// [action] 行动类型（attack / skill / ultimate）
  /// [targetId] 目标武将 ID
  /// 返回包含更新后战斗状态的 [ApiResult]
  Future<ApiResult<Battle>> call({
    required String battleId,
    required String action,
    String? targetId,
  }) =>
      throw UnimplementedError();
}
