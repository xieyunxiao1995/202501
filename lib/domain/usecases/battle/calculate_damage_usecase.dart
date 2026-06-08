import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/battle.dart';
import '../../repositories/i_battle_repository.dart';

/// 计算伤害用例
///
/// 根据攻击方和防御方的属性、技能倍率、兵种克制等因素计算伤害值。
/// 用于战斗预览和伤害日志记录。
@injectable
class CalculateDamageUseCase {
  final IBattleRepository _repository;

  /// 创建计算伤害用例实例
  CalculateDamageUseCase(this._repository);

  /// 执行计算伤害操作
  ///
  /// [attackerId] 攻击方武将 ID
  /// [defenderId] 防御方武将 ID
  /// [skillId] 使用的技能 ID（可选，为空则为普攻）
  /// 返回包含伤害计算结果的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call({
    required String attackerId,
    required String defenderId,
    String? skillId,
  }) =>
      throw UnimplementedError();
}
