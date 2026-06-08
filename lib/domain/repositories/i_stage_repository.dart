import '../../core/network/api_result.dart';
import '../entities/stage.dart';

/// 关卡仓库接口
///
/// 提供关卡相关操作，包括章节查询、关卡进入、扫荡和奖励领取。
abstract class IStageRepository {
  /// 获取章节列表
  ///
  /// 获取所有章节信息，包括已解锁和未解锁的章节。
  Future<ApiResult<List<Map<String, dynamic>>>> getChapters();

  /// 获取关卡列表
  ///
  /// 获取指定章节 [chapterId] 下的所有关卡信息。
  Future<ApiResult<List<Stage>>> getStages(String chapterId);

  /// 进入关卡
  ///
  /// 进入指定 [stageId] 的关卡，开始战斗。
  Future<ApiResult<Stage>> enterStage(String stageId);

  /// 扫荡关卡
  ///
  /// 快速通关已三星通关的 [stageId] 关卡，直接获得奖励。
  Future<ApiResult<Stage>> sweepStage(String stageId);

  /// 领取关卡奖励
  ///
  /// 领取指定 [stageId] 的首次通关或星级奖励。
  Future<ApiResult<Map<String, int>>> claimReward(String stageId);

  /// 进入经典战役
  ///
  /// 进入经典战役模式，挑战历史名将。
  Future<ApiResult<Map<String, dynamic>>> enterClassicBattle();

  /// 进入爬塔
  ///
  /// 进入逐层挑战的爬塔模式。
  Future<ApiResult<Map<String, dynamic>>> enterTower();
}
