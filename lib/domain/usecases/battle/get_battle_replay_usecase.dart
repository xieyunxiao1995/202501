import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 获取战斗回放用例
///
/// 获取已结束战斗的回放数据，用于复盘分析。
/// 回放数据包含每回合的战斗行动和伤害记录。
@injectable
class GetBattleReplayUseCase {
  final IBattleRepository _repository;

  /// 创建获取战斗回放用例实例
  GetBattleReplayUseCase(this._repository);

  /// 执行获取战斗回放操作
  ///
  /// [battleId] 战斗 ID
  /// 返回包含回放数据的 [ApiResult]
  Future<ApiResult<Battle>> call(String battleId) =>
      throw UnimplementedError();
}
