import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 开始战斗用例
///
/// 以我方阵容对战敌方阵容，创建并返回新的战斗实例。
/// 战斗创建后进入准备阶段，等待玩家执行操作。
@injectable
class StartBattleUseCase {
  final IBattleRepository _repository;

  /// 创建开始战斗用例实例
  StartBattleUseCase(this._repository);

  /// 执行开始战斗操作
  ///
  /// [lineupId] 我方阵容 ID
  /// [enemyLineupId] 敌方阵容 ID
  /// 返回包含战斗实例的 [ApiResult]
  Future<ApiResult<Battle>> call(String lineupId, String enemyLineupId) =>
      throw UnimplementedError();
}
