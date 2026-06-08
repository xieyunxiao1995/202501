import '../../core/network/api_result.dart';
import '../entities/lineup.dart';
import '../entities/formation.dart';

/// 阵容仓库接口
///
/// 提供阵容管理相关操作，包括阵容的查询、保存、阵法设置和验证。
abstract class ILineupRepository {
  /// 获取阵容列表
  ///
  /// 获取当前玩家保存的所有阵容配置。
  Future<ApiResult<List<Lineup>>> getList();

  /// 保存阵容
  ///
  /// 保存阵容配置，[lineup] 为需要保存的阵容数据。
  Future<ApiResult<Lineup>> save(Lineup lineup);

  /// 设置阵法
  ///
  /// 为指定 [lineupId] 的阵容设置 [formationId] 阵法。
  Future<ApiResult<Lineup>> setFormation(String lineupId, String formationId);

  /// 验证阵容
  ///
  /// 验证指定 [lineupId] 的阵容是否合法（武将数量、位置等）。
  Future<ApiResult<bool>> validate(String lineupId);

  /// 获取推荐阵容
  ///
  /// 根据当前拥有的武将，获取系统推荐的阵容搭配。
  Future<ApiResult<List<Lineup>>> getRecommended();

  /// 获取可用阵法列表
  ///
  /// 获取当前玩家已解锁的阵法列表。
  Future<ApiResult<List<Formation>>> getFormations();
}
