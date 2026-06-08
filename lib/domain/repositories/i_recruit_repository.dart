import '../../core/network/api_result.dart';
import '../entities/general.dart';

/// 招募仓库接口
///
/// 提供武将招募相关操作，包括卡池查询、单抽、十连和保底信息。
abstract class IRecruitRepository {
  /// 获取卡池信息
  ///
  /// 获取当前可用的招募卡池列表及各卡池的规则和概率。
  Future<ApiResult<List<Map<String, dynamic>>>> getPool();

  /// 单次招募
  ///
  /// 在指定 [poolId] 卡池中进行一次招募。
  Future<ApiResult<General>> singleRecruit(String poolId);

  /// 十连招募
  ///
  /// 在指定 [poolId] 卡池中进行十连招募，保底至少获得稀有武将。
  Future<ApiResult<List<General>>> tenRecruit(String poolId);

  /// 获取招募历史
  ///
  /// 获取指定 [poolId] 卡池的招募历史记录。
  Future<ApiResult<List<Map<String, dynamic>>>> getHistory(String poolId);

  /// 获取保底信息
  ///
  /// 获取指定 [poolId] 卡池的保底计数和距离下次保底的抽数。
  Future<ApiResult<Map<String, dynamic>>> getPityInfo(String poolId);
}
