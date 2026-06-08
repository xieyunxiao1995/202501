import 'dart:math';

/// 数学工具类
///
/// 提供随机数生成、数值钳制、线性插值、概率判定、伤害公式辅助等常用数学操作。
class MathUtils {
  MathUtils._();

  static final Random _random = Random();

  // ==================== 随机数 ====================

  /// 生成指定范围内的随机整数 [min, max]
  ///
  /// 包含 min 和 max
  static int randomInt(int min, int max) {
    if (min > max) {
      final temp = min;
      min = max;
      max = temp;
    }
    return min + _random.nextInt(max - min + 1);
  }

  /// 生成指定范围内的随机浮点数 [min, max)
  static double randomDouble(double min, double max) {
    if (min > max) {
      final temp = min;
      min = max;
      max = temp;
    }
    return min + _random.nextDouble() * (max - min);
  }

  /// 生成 0.0 到 1.0 之间的随机浮点数
  static double randomPercent() => _random.nextDouble();

  // ==================== 概率判定 ====================

  /// 概率判定
  ///
  /// [probability] 概率值，范围 0.0 ~ 1.0
  /// 返回 true 表示命中
  ///
  /// 示例：
  /// - probabilityCheck(0.3) → 30%概率返回 true
  /// - probabilityCheck(1.0) → 必定返回 true
  /// - probabilityCheck(0.0) → 必定返回 false
  static bool probabilityCheck(double probability) {
    if (probability <= 0.0) return false;
    if (probability >= 1.0) return true;
    return _random.nextDouble() < probability;
  }

  /// 千分比概率判定
  ///
  /// [permil] 千分比值，范围 0 ~ 1000
  /// 返回 true 表示命中
  ///
  /// 示例：permilCheck(300) → 30%概率返回 true
  static bool permilCheck(int permil) {
    if (permil <= 0) return false;
    if (permil >= 1000) return true;
    return _random.nextInt(1000) < permil;
  }

  /// 万分比概率判定
  ///
  /// [basisPoint] 万分比值，范围 0 ~ 10000
  /// 返回 true 表示命中
  ///
  /// 示例：basisPointCheck(3000) → 30%概率返回 true
  static bool basisPointCheck(int basisPoint) {
    if (basisPoint <= 0) return false;
    if (basisPoint >= 10000) return true;
    return _random.nextInt(10000) < basisPoint;
  }

  // ==================== 数值钳制与插值 ====================

  /// 将值限制在 [min, max] 范围内
  static num clamp(num value, num min, num max) {
    return value.clamp(min, max);
  }

  /// 将整数值限制在 [min, max] 范围内
  static int clampInt(int value, int min, int max) {
    return value.clamp(min, max);
  }

  /// 将浮点值限制在 [min, max] 范围内
  static double clampDouble(double value, double min, double max) {
    return value.clamp(min, max);
  }

  /// 线性插值
  ///
  /// [a] 起始值
  /// [b] 结束值
  /// [t] 插值因子，0.0 ~ 1.0
  static double lerp(double a, double b, double t) {
    return a + (b - a) * clampDouble(t, 0.0, 1.0);
  }

  /// 反线性插值（求插值因子）
  ///
  /// 返回 (value - a) / (b - a)，范围 0.0 ~ 1.0
  static double inverseLerp(double a, double b, double value) {
    if (a == b) return 0.0;
    return clampDouble((value - a) / (b - a), 0.0, 1.0);
  }

  /// 重映射：将 [inMin, inMax] 映射到 [outMin, outMax]
  static double remap(double value, double inMin, double inMax, double outMin, double outMax) {
    final t = inverseLerp(inMin, inMax, value);
    return lerp(outMin, outMax, t);
  }

  // ==================== 伤害公式辅助 ====================

  /// 计算基础伤害
  ///
  /// 伤害 = 攻击力 * 技能倍率 - 防御力 * 防御系数
  /// 最低伤害为 [minDamage]
  static int calcBaseDamage({
    required int attack,
    required int defense,
    required double skillMultiplier,
    double defenseFactor = 0.5,
    int minDamage = 1,
  }) {
    final rawDamage = attack * skillMultiplier - defense * defenseFactor;
    return max(minDamage, rawDamage.round());
  }

  /// 计算暴击伤害
  ///
  /// [baseDamage] 基础伤害
  /// [critMultiplier] 暴击倍率，默认2.0
  /// [critRate] 暴击率，0.0 ~ 1.0
  /// 返回 (是否暴击, 最终伤害)
  static (bool, int) calcCritDamage({
    required int baseDamage,
    double critRate = 0.15,
    double critMultiplier = 2.0,
  }) {
    final isCrit = probabilityCheck(critRate);
    final damage = isCrit ? (baseDamage * critMultiplier).round() : baseDamage;
    return (isCrit, damage);
  }

  /// 计算浮动伤害（在基础伤害上增加随机波动）
  ///
  /// [baseDamage] 基础伤害
  /// [fluctuation] 波动范围，默认 0.1（即 ±10%）
  static int calcFluctuationDamage(int baseDamage, {double fluctuation = 0.1}) {
    final factor = randomDouble(1.0 - fluctuation, 1.0 + fluctuation);
    return (baseDamage * factor).round();
  }

  /// 计算最终伤害（含暴击、浮动、免伤等）
  ///
  /// [attack] 攻击力
  /// [defense] 防御力
  /// [skillMultiplier] 技能倍率
  /// [critRate] 暴击率
  /// [critMultiplier] 暴击倍率
  /// [damageReduction] 免伤率，0.0 ~ 1.0
  /// [fluctuation] 伤害波动范围
  /// 返回 (是否暴击, 最终伤害)
  static (bool, int) calcFinalDamage({
    required int attack,
    required int defense,
    required double skillMultiplier,
    double critRate = 0.15,
    double critMultiplier = 2.0,
    double damageReduction = 0.0,
    double fluctuation = 0.1,
  }) {
    final baseDamage = calcBaseDamage(
      attack: attack,
      defense: defense,
      skillMultiplier: skillMultiplier,
    );
    final (isCrit, critDamage) = calcCritDamage(
      baseDamage: baseDamage,
      critRate: critRate,
      critMultiplier: critMultiplier,
    );
    var finalDamage = calcFluctuationDamage(critDamage, fluctuation: fluctuation);
    // 应用免伤
    finalDamage = (finalDamage * (1.0 - clampDouble(damageReduction, 0.0, 0.9))).round();
    return (isCrit, max(1, finalDamage));
  }

  // ==================== 其他数学工具 ====================

  /// 计算百分比
  ///
  /// 返回 [value] 占 [total] 的百分比，0.0 ~ 100.0
  static double percent(num value, num total) {
    if (total == 0) return 0.0;
    return (value / total * 100).clamp(0.0, 100.0);
  }

  /// 安全除法，避免除以零
  static double safeDivide(num numerator, num denominator, {double defaultValue = 0.0}) {
    if (denominator == 0) return defaultValue;
    return numerator / denominator;
  }

  /// 判断值是否在范围内 [min, max]
  static bool inRange(num value, num min, num max) {
    return value >= min && value <= max;
  }
}
