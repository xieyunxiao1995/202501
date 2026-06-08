/// 奖励计算服务
///
/// 计算各种场景下的奖励内容，包括关卡奖励、活动奖励、国战奖励等。
class RewardCalculator {
  /// 计算关卡奖励
  ///
  /// [stageId] 关卡 ID
  /// [starCount] 通关星级（0-3）
  /// [isFirstClear] 是否首次通关
  ///
  /// 首次通关获得全部奖励，重复通关获得部分奖励。
  /// 三星通关额外获得宝箱奖励。
  Map<String, int> calculateStageReward({
    required String stageId,
    required int starCount,
    required bool isFirstClear,
  }) {
    // TODO: 实现关卡奖励计算
    throw UnimplementedError();
  }

  /// 计算竞技场奖励
  ///
  /// [rank] 当前排名
  /// [isSeasonEnd] 是否赛季结算
  ///
  /// 竞技场每日根据排名发放奖励，赛季结算时发放赛季奖励。
  Map<String, int> calculateArenaReward({
    required int rank,
    required bool isSeasonEnd,
  }) {
    // TODO: 实现竞技场奖励计算
    throw UnimplementedError();
  }

  /// 计算国战奖励
  ///
  /// [cityCount] 占领城市数
  /// [contribution] 个人贡献值
  /// [isVictory] 是否胜利方
  ///
  /// 国战奖励根据城市占领数和个人贡献综合计算。
  Map<String, int> calculateKingdomWarReward({
    required int cityCount,
    required int contribution,
    required bool isVictory,
  }) {
    // TODO: 实现国战奖励计算
    throw UnimplementedError();
  }

  /// 合并多个奖励
  ///
  /// [rewards] 需要合并的奖励列表
  ///
  /// 将多个奖励字典合并为一个，相同道具 ID 的数量累加。
  Map<String, int> mergeRewards(List<Map<String, int>> rewards) {
    final merged = <String, int>{};
    for (final reward in rewards) {
      for (final entry in reward.entries) {
        merged[entry.key] = (merged[entry.key] ?? 0) + entry.value;
      }
    }
    return merged;
  }
}
