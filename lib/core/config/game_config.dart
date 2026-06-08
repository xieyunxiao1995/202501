/// 游戏配置（战斗参数、动画速度、伤害公式系数等）
///
/// 包含战斗系统、怒气系统、兵种克制、动画速度等核心游戏参数。
/// 所有参数均有默认值，可根据运营需求调整。
///
/// 使用方式：
/// ```dart
/// const config = GameConfig();
/// print(config.maxBattleRounds); // 30
/// ```
class GameConfig {
  /// 创建游戏配置
  const GameConfig({
    this.maxBattleRounds = 30,
    this.maxRage = 100,
    this.initialRage = 0,
    this.attackRageGain = 20,
    this.hitRageGain = 10,
    this.criticalMultiplier = 1.5,
    this.troopCounterBonus = 0.3,
    this.troopCounterPenalty = 0.2,
    this.animationSpeed = 1.0,
    this.autoBattleDelay = 1000,
  });

  /// 最大回合数
  final int maxBattleRounds;

  /// 怒气上限
  final int maxRage;

  /// 初始怒气
  final int initialRage;

  /// 普攻怒气增加
  final int attackRageGain;

  /// 受击怒气增加
  final int hitRageGain;

  /// 暴击倍率
  final double criticalMultiplier;

  /// 兵种克制加成（克制对方时伤害增加比例）
  final double troopCounterBonus;

  /// 兵种被克减免（被克制时伤害减少比例）
  final double troopCounterPenalty;

  /// 动画速度倍率
  final double animationSpeed;

  /// 自动战斗延迟（毫秒）
  final int autoBattleDelay;

  /// 计算克制伤害加成
  ///
  /// [isCounter] 是否克制对方
  /// [isCountered] 是否被对方克制
  double calculateCounterMultiplier({
    required bool isCounter,
    required bool isCountered,
  }) {
    if (isCounter) {
      return 1.0 + troopCounterBonus;
    }
    if (isCountered) {
      return 1.0 - troopCounterPenalty;
    }
    return 1.0;
  }

  /// 计算暴击伤害
  ///
  /// [baseDamage] 基础伤害值
  double calculateCriticalDamage(double baseDamage) {
    return baseDamage * criticalMultiplier;
  }

  /// 计算普攻后怒气值
  ///
  /// [currentRage] 当前怒气值
  int calculateRageAfterAttack(int currentRage) {
    return (currentRage + attackRageGain).clamp(0, maxRage);
  }

  /// 计算受击后怒气值
  ///
  /// [currentRage] 当前怒气值
  int calculateRageAfterHit(int currentRage) {
    return (currentRage + hitRageGain).clamp(0, maxRage);
  }

  /// 判断是否达到怒气上限（可释放战法）
  ///
  /// [currentRage] 当前怒气值
  bool canCastSkill(int currentRage) => currentRage >= maxRage;

  /// 判断战斗是否超过最大回合数
  ///
  /// [currentRound] 当前回合数
  bool isBattleOver(int currentRound) => currentRound >= maxBattleRounds;

  @override
  String toString() =>
      'GameConfig(maxBattleRounds: $maxBattleRounds, maxRage: $maxRage, '
      'criticalMultiplier: $criticalMultiplier, animationSpeed: $animationSpeed)';
}
