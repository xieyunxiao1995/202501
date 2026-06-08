import '../../core/network/api_result.dart';

/// PVP 仓库接口
///
/// 提供玩家对战相关操作，包括竞技场、巅峰赛、匹配和 Ban/Pick。
abstract class IPvpRepository {
  /// 进入竞技场
  ///
  /// 获取竞技场信息和当前排名。
  Future<ApiResult<Map<String, dynamic>>> enterArena();

  /// 竞技场挑战
  ///
  /// 挑战指定 [opponentId] 的对手，[lineupId] 为出战阵容。
  Future<ApiResult<Map<String, dynamic>>> challengeArena(
    String opponentId,
    String lineupId,
  );

  /// 进入巅峰竞技场
  ///
  /// 获取巅峰竞技场信息和赛季排名。
  Future<ApiResult<Map<String, dynamic>>> enterPeakArena();

  /// 匹配对手
  ///
  /// 根据战力匹配 PVP 对手，返回匹配结果。
  Future<ApiResult<Map<String, dynamic>>> matchOpponent();

  /// Ban/Pick 选择
  ///
  /// 在 Ban/Pick 模式中进行选择操作。
  /// [action] 为操作类型（ban/pick），[generalId] 为目标武将 ID。
  Future<ApiResult<Map<String, dynamic>>> banPick(
    String action,
    String generalId,
  );
}
