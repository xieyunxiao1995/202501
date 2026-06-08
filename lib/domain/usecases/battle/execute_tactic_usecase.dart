import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 执行计谋用例
///
/// 在战斗中释放计谋（如火攻、水攻、空城计等），产生持续效果。
/// 计谋需要满足触发条件，且有冷却回合限制。
@injectable
class ExecuteTacticUseCase {
  final IBattleRepository _repository;

  /// 创建执行计谋用例实例
  ExecuteTacticUseCase(this._repository);

  /// 执行计谋操作
  ///
  /// [battleId] 战斗 ID
  /// [tacticId] 计谋 ID
  /// [targetId] 目标 ID（可选，部分计谋为范围效果）
  /// 返回包含更新后战斗状态的 [ApiResult]
  Future<ApiResult<Battle>> call({
    required String battleId,
    required String tacticId,
    String? targetId,
  }) =>
      throw UnimplementedError();
}
