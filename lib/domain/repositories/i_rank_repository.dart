import '../../core/network/api_result.dart';

/// 排行榜仓库接口
///
/// 提供排行榜查询相关操作，支持按不同类型查询排名。
abstract class IRankRepository {
  /// 获取排行榜
  ///
  /// 根据 [type] 获取对应类型的排行榜数据。
  /// 类型包括：战力榜、等级榜、竞技场榜等。
  Future<ApiResult<List<Map<String, dynamic>>>> getRankings(String type);
}
