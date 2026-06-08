/// 国战税收计算服务
///
/// 计算国战中城市占领带来的税收收益，以及国家整体经济状况。
class KingdomTaxCalculator {
  /// 计算城市税收
  ///
  /// [cityId] 城市 ID
  /// [cityLevel] 城市等级
  /// [occupyingKingdom] 占领国家
  /// [prosperity] 城市繁荣度
  ///
  /// 税收 = 基础税收 * 城市等级系数 * 繁荣度系数
  /// 城市等级越高、繁荣度越高，税收越多。
  double calculateCityTax({
    required String cityId,
    required int cityLevel,
    required String occupyingKingdom,
    required double prosperity,
  }) {
    // TODO: 实现城市税收计算
    throw UnimplementedError();
  }

  /// 计算国家总税收
  ///
  /// [cities] 国家占领的城市列表
  ///
  /// 国家总税收为所有占领城市税收之和。
  double calculateKingdomTotalTax(List<Map<String, dynamic>> cities) {
    // TODO: 实现国家总税收计算
    throw UnimplementedError();
  }

  /// 计算个人税收分配
  ///
  /// [totalTax] 国家总税收
  /// [contribution] 个人贡献值
  /// [totalContribution] 国家总贡献值
  ///
  /// 个人税收 = 总税收 * (个人贡献 / 总贡献)
  /// 最低保底为总税收的 1%。
  double calculatePersonalTaxShare({
    required double totalTax,
    required int contribution,
    required int totalContribution,
  }) {
    // TODO: 实现个人税收分配计算
    throw UnimplementedError();
  }

  /// 计算繁荣度变化
  ///
  /// [currentProsperity] 当前繁荣度
  /// [isAtWar] 是否处于战争状态
  /// [daysOccupied] 占领天数
  ///
  /// 和平时期繁荣度逐渐增长，战争期间繁荣度下降。
  /// 占领时间越长，繁荣度恢复越快。
  double calculateProsperityChange({
    required double currentProsperity,
    required bool isAtWar,
    required int daysOccupied,
  }) {
    // TODO: 实现繁荣度变化计算
    throw UnimplementedError();
  }
}
