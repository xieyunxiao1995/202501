import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/stage.dart';
import '../../domain/repositories/i_stage_repository.dart';
import '../datasources/local/game_progress_local_data_source.dart';
import '../datasources/remote/stage_api.dart';
import '../mappers/stage_mapper.dart';

/// 关卡仓库实现
///
/// 实现关卡相关业务逻辑，协调远程 API 和本地数据源，
/// 处理章节查询、关卡进入、扫荡、奖励领取、经典战役和爬塔等操作。
@LazySingleton(as: IStageRepository)
class StageRepositoryImpl implements IStageRepository {
  final StageApi _stageApi;
  final GameProgressLocalDataSource _gameProgressLocalDataSource;
  final StageMapper _stageMapper;

  StageRepositoryImpl(
    this._stageApi,
    this._gameProgressLocalDataSource,
    this._stageMapper,
  );

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getChapters() async {
    // TODO: 调用 _stageApi.getChapters，返回章节列表
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<Stage>>> getStages(String chapterId) async {
    // TODO: 调用 _stageApi.getChapterDetail，通过 _stageMapper 批量转换为 Stage 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Stage>> enterStage(String stageId) async {
    // TODO: 调用 _stageApi.enterStage，通过 _stageMapper 转换为 Stage 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Stage>> sweepStage(String stageId) async {
    // TODO: 调用 API 扫荡关卡，通过 _stageMapper 转换为 Stage 实体，更新本地进度
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, int>>> claimReward(String stageId) async {
    // TODO: 调用 API 领取关卡奖励
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> enterClassicBattle() async {
    // TODO: 调用 _stageApi.getClassicBattles，返回经典战役数据
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> enterTower() async {
    // TODO: 调用 _stageApi.getTowerFloors，返回试炼之塔数据
    throw UnimplementedError();
  }
}
