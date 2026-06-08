import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/kingdom_war.dart';
import '../../repositories/i_kingdom_war_repository.dart';

/// 守城用例
///
/// 参与己方城市的防守，抵御敌方国家的进攻。
/// 守城成功可保住城市控制权并获得守城奖励。
@injectable
class DefendCityUseCase {
  final IKingdomWarRepository _repository;

  /// 创建守城用例实例
  DefendCityUseCase(this._repository);

  /// 执行守城操作
  ///
  /// [cityId] 城市 ID
  /// 返回包含国战状态的 [ApiResult]
  Future<ApiResult<KingdomWar>> call(String cityId) =>
      throw UnimplementedError();
}
