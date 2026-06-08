import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 触发羁绊用例
///
/// 当阵容中同时上阵满足羁绊条件的武将时，自动触发羁绊效果。
/// 羁绊效果可提供属性加成或特殊技能。
@injectable
class TriggerBondUseCase {
  final IBattleRepository _repository;

  /// 创建触发羁绊用例实例
  TriggerBondUseCase(this._repository);

  /// 执行触发羁绊操作
  ///
  /// [battleId] 战斗 ID
  /// [bondId] 羁绊 ID
  /// 返回包含更新后战斗状态的 [ApiResult]
  Future<ApiResult<Battle>> call({
    required String battleId,
    required String bondId,
  }) =>
      throw UnimplementedError();
}
