import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/kingdom_war.dart';
import '../../domain/repositories/i_kingdom_war_repository.dart';
import '../datasources/remote/kingdom_war_api.dart';

/// 国战仓库实现
///
/// 实现国战相关业务逻辑，协调远程 API，
/// 处理地图查询、攻城、守城、任务和奖励等操作。
@LazySingleton(as: IKingdomWarRepository)
class KingdomWarRepositoryImpl implements IKingdomWarRepository {
  final KingdomWarApi _kingdomWarApi;

  KingdomWarRepositoryImpl(this._kingdomWarApi);

  @override
  Future<ApiResult<KingdomWar>> getMap() async {
    // TODO: 调用 _kingdomWarApi.getWarMap，转换为 KingdomWar 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<KingdomWar>> attackCity(String cityId) async {
    // TODO: 调用 _kingdomWarApi.attackCity，更新城池状态，转换为 KingdomWar 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<KingdomWar>> defendCity(String cityId) async {
    // TODO: 调用 _kingdomWarApi.defendCity，更新城池状态，转换为 KingdomWar 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getTasks() async {
    // TODO: 调用 _kingdomWarApi.getWarTasks，返回任务列表
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, int>>> getRewards(String taskId) async {
    // TODO: 调用 _kingdomWarApi.claimWarTaskReward，返回奖励内容
    throw UnimplementedError();
  }
}
