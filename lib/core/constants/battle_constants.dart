/// 战斗系统常量
///
/// 包含战斗回合、怒气系统、暴击、兵种克制等战斗核心参数。
/// 与 [GameConfig] 中的可配置参数对应，此处为常量形式供静态引用。
class BattleConstants {
  BattleConstants._();

  // ==================== 回合 ====================

  /// 最大回合数
  static const int maxBattleRounds = 30;

  /// 每回合行动数
  static const int actionsPerRound = 1;

  // ==================== 怒气系统 ====================

  /// 怒气上限
  static const int maxRage = 100;

  /// 初始怒气
  static const int initialRage = 0;

  /// 普攻怒气增加
  static const int attackRageGain = 20;

  /// 受击怒气增加
  static const int hitRageGain = 10;

  /// 暴击额外怒气增加
  static const int criticalRageBonus = 5;

  /// 击杀额外怒气增加
  static const int killRageBonus = 15;

  /// 战法释放后怒气值
  static const int rageAfterSkill = 0;

  // ==================== 伤害 ====================

  /// 暴击倍率
  static const double criticalMultiplier = 1.5;

  /// 暴击率（基础）
  static const double baseCriticalRate = 0.15;

  /// 闪避率（基础）
  static const double baseDodgeRate = 0.05;

  /// 格挡减伤比例
  static const double blockDamageReduction = 0.3;

  /// 最低伤害比例（避免零伤害）
  static const double minDamageRatio = 0.1;

  // ==================== 兵种克制 ====================

  /// 兵种克制加成（克制对方时伤害 +30%）
  static const double troopCounterBonus = 0.3;

  /// 兵种被克减免（被克制时伤害 -20%）
  static const double troopCounterPenalty = 0.2;

  // ==================== 兵种类型 ====================

  /// 步兵
  static const String troopInfantry = 'infantry';

  /// 骑兵
  static const String troopCavalry = 'cavalry';

  /// 弓兵
  static const String troopArcher = 'archer';

  /// 谋士
  static const String troopStrategist = 'strategist';

  /// 兵种克制关系：骑兵 > 步兵 > 弓兵 > 骑兵，谋士互克
  static const Map<String, List<String>> troopCounterRelations = {
    troopCavalry: [troopInfantry],
    troopInfantry: [troopArcher],
    troopArcher: [troopCavalry],
    troopStrategist: [troopStrategist],
  };

  // ==================== 战斗状态 ====================

  /// 战斗状态：准备中
  static const String statePreparing = 'preparing';

  /// 战斗状态：进行中
  static const String stateInProgress = 'in_progress';

  /// 战斗状态：已结束
  static const String stateFinished = 'finished';

  /// 战斗状态：已暂停
  static const String statePaused = 'paused';

  // ==================== 战斗类型 ====================

  /// 战斗类型：PVE 普通
  static const String typePve = 'pve';

  /// 战斗类型：PVP
  static const String typePvp = 'pvp';

  /// 战斗类型：国战
  static const String typeNational = 'national';

  /// 战斗类型：竞技场
  static const String typeArena = 'arena';

  /// 战斗类型：远征
  static const String typeExpedition = 'expedition';

  // ==================== 阵容 ====================

  /// 阵容最大武将数
  static const int maxFormationSize = 3;

  /// 阵容行数
  static const int formationRows = 3;

  /// 阵容列数
  static const int formationCols = 3;

  // ==================== 动画 ====================

  /// 自动战斗延迟（毫秒）
  static const int autoBattleDelay = 1000;

  /// 战斗动画速度倍率
  static const double animationSpeed = 1.0;

  /// 快速战斗速度倍率
  static const double fastAnimationSpeed = 2.0;
}
