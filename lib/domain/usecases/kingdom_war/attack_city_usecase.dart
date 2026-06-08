import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/kingdom_war.dart';
import '../../repositories/i_kingdom_war_repository.dart';

/// 攻城用例
///
/// 向指定城市发起攻击，争夺城市控制权。
/// 攻城需消耗行军令，成功占领后城市归属我方国家。
@injectable
class AttackCityUseCase {
  final IKingdomWarRepository _repository;

  /// 创建攻城用例实例
  AttackCityUseCase(this._repository);

  /// 执行攻城操作
  ///
  /// [cityId] 城市 ID
  /// 返回包含国战状态的 [ApiResult]
  Future<ApiResult<KingdomWar>> call(String cityId) =>
      throw UnimplementedError();
}
