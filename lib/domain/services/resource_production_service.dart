/// 资源产出计算服务
///
/// 计算主城建筑的资源产出，包括产出速率、存储上限和加速效果。
class ResourceProductionService {
  /// 计算建筑产出速率
  ///
  /// [buildingType] 建筑类型
  /// [buildingLevel] 建筑等级
  /// [bonusRate] 额外加成比例（科技、国战等加成）
  ///
  /// 产出速率 = 基础速率 * 等级系数 * (1 + 额外加成)
  double calculateProductionRate({
    required String buildingType,
    required int buildingLevel,
    double bonusRate = 0,
  }) {
    // TODO: 实现建筑产出速率计算
    throw UnimplementedError();
  }

  /// 计算资源存储上限
  ///
  /// [buildingType] 建筑类型
  /// [buildingLevel] 建筑等级
  ///
  /// 建筑等级越高，存储上限越大。
  /// 资源超出上限后不再增长，需及时收取。
  int calculateStorageLimit({
    required String buildingType,
    required int buildingLevel,
  }) {
    // TODO: 实现存储上限计算
    throw UnimplementedError();
  }

  /// 计算可收取的资源数量
  ///
  /// [productionRate] 产出速率（每小时）
  /// [lastCollectTime] 上次收取时间
  /// [currentTime] 当前时间
  /// [storageLimit] 存储上限
  /// [currentStored] 当前已存储数量
  ///
  /// 可收取量 = 产出速率 * 经过时间，但不超过存储上限。
  int calculateCollectableAmount({
    required double productionRate,
    required DateTime lastCollectTime,
    required DateTime currentTime,
    required int storageLimit,
    required int currentStored,
  }) {
    // TODO: 实现可收取资源计算
    throw UnimplementedError();
  }

  /// 计算加速后的完成时间
  ///
  /// [remainingTime] 剩余建造时间
  /// [speedUpDuration] 加速时长
  ///
  /// 返回加速后的剩余时间，最小为 0（立即完成）。
  Duration calculateSpeedUpTime({
    required Duration remainingTime,
    required Duration speedUpDuration,
  }) {
    final accelerated = remainingTime - speedUpDuration;
    return accelerated.isNegative ? Duration.zero : accelerated;
  }
}
