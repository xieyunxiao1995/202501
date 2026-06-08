import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/battle.dart';
import '../../domain/repositories/i_battle_repository.dart';
import '../datasources/local/replay_local_data_source.dart';
import '../datasources/remote/battle_api.dart';
import '../mappers/battle_mapper.dart';

/// 战斗仓库实现
///
/// 实现战斗相关业务逻辑，协调远程 API 和本地数据源，
/// 处理开始战斗、结束战斗和战斗回放等操作。
@LazySingleton(as: IBattleRepository)
class BattleRepositoryImpl implements IBattleRepository {
  final BattleApi _battleApi;
  final ReplayLocalDataSource _replayLocalDataSource;
  final BattleMapper _battleMapper;

  BattleRepositoryImpl(
    this._battleApi,
    this._replayLocalDataSource,
    this._battleMapper,
  );

  @override
  Future<ApiResult<Battle>> startBattle(String lineupId, String enemyLineupId) async {
    // TODO: 调用 _battleApi.createBattle，通过 _battleMapper 转换为 Battle 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Battle>> endBattle(String battleId) async {
    // TODO: 调用 _battleApi.settleBattle，通过 _battleMapper 转换为 Battle 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Battle>> getReplay(String battleId) async {
    // TODO: 优先从 _replayLocalDataSource 读取回放，未命中则调用 API 获取
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> saveReplay(String battleId) async {
    // TODO: 调用 API 获取回放数据，保存到 _replayLocalDataSource
    throw UnimplementedError();
  }
}
