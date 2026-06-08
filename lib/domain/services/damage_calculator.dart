/// 伤害计算服务
///
/// 提供战斗中伤害相关的计算逻辑，包括基础伤害、兵种克制、暴击和最终伤害计算。
/// 计算公式：伤害 = 攻击力 * (1 + 攻击加成%) - 防御力 * (1 + 防御加成%) * 0.5
class DamageCalculator {
  /// 计算基础伤害
  ///
  /// [atk] 攻击力
  /// [def] 防御力
  /// [atkBonus] 攻击加成比例（如 0.3 表示 +30%）
  /// [defBonus] 防御加成比例（如 0.2 表示 +20%）
  ///
  /// 公式：伤害 = 攻击力 * (1 + 攻击加成%) - 防御力 * (1 + 防御加成%) * 0.5
  /// 最低伤害为 1，确保不会出现零伤害或负伤害。
  double calculateBaseDamage({
    required int atk,
    required int def,
    double atkBonus = 0,
    double defBonus = 0,
  }) {
    final attack = atk * (1 + atkBonus);
    final defense = def * (1 + defBonus) * 0.5;
    return (attack - defense).clamp(1, double.infinity);
  }

  /// 应用兵种克制
  ///
  /// [baseDamage] 基础伤害值
  /// [isCounter] 是否克制对方，克制时伤害 +30%
  /// [isCountered] 是否被对方克制，被克制时伤害 -20%
  ///
  /// 克制和被克制不会同时生效，优先判定克制。
  double applyTroopCounter(
    double baseDamage,
    bool isCounter,
    bool isCountered,
  ) {
    if (isCounter) return baseDamage * 1.3;
    if (isCountered) return baseDamage * 0.8;
    return baseDamage;
  }

  /// 应用暴击效果
  ///
  /// [baseDamage] 基础伤害值
  /// [multiplier] 暴击倍率，默认 1.5 倍
  ///
  /// 暴击时伤害按倍率放大，不同武将可能有不同暴击倍率。
  double applyCritical(double baseDamage, {double multiplier = 1.5}) =>
      baseDamage * multiplier;

  /// 计算最终伤害（含浮动 ±5%）
  ///
  /// [baseDamage] 经过所有加成后的伤害值
  ///
  /// 在基础伤害上加入 ±5% 的随机浮动，使战斗结果更具变化。
  /// TODO: 加入随机浮动
  double calculateFinalDamage(double baseDamage) {
    // TODO: 加入随机浮动 ±5%
    return baseDamage;
  }
}
