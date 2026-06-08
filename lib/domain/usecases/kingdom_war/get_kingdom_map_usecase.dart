import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/kingdom_war.dart';
import '../../repositories/i_kingdom_war_repository.dart';

/// 获取国战地图用例
///
/// 获取国战战场地图信息，包括各城市的状态和控制方。
/// 地图实时更新，反映当前国战态势。
@injectable
class GetKingdomMapUseCase {
  final IKingdomWarRepository _repository;

  /// 创建获取国战地图用例实例
  GetKingdomMapUseCase(this._repository);

  /// 执行获取国战地图操作
  ///
  /// 返回包含国战地图信息的 [ApiResult]
  Future<ApiResult<KingdomWar>> call() => throw UnimplementedError();
}
