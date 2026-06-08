import '../../core/network/api_result.dart';

/// 邮件仓库接口
///
/// 提供邮件相关操作，包括查询、阅读、领取奖励和删除。
abstract class IMailRepository {
  /// 获取邮件列表
  ///
  /// 获取当前玩家的邮件列表，按时间倒序排列。
  Future<ApiResult<List<Map<String, dynamic>>>> getList();

  /// 阅读邮件
  ///
  /// 标记指定 [mailId] 的邮件为已读。
  Future<ApiResult<void>> read(String mailId);

  /// 领取邮件奖励
  ///
  /// 领取指定 [mailId] 邮件中附带的奖励。
  Future<ApiResult<Map<String, int>>> claimReward(String mailId);

  /// 删除邮件
  ///
  /// 删除指定 [mailId] 的邮件，已领取奖励的邮件才可删除。
  Future<ApiResult<void>> delete(String mailId);
}
