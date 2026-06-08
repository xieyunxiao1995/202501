/// 玩法常量
///
/// 包含 PVP、副本、体力、招贤、保底等玩法系统的核心数值常量。
class GameplayConstants {
  GameplayConstants._();

  // ==================== 体力系统 ====================

  /// 体力上限
  static const int maxStamina = 120;

  /// 体力恢复间隔（分钟/点）
  static const int staminaRecoveryMinutes = 6;

  /// 体力恢复间隔（秒）
  static const int staminaRecoverySeconds = staminaRecoveryMinutes * 60;

  /// 每日体力购买次数上限
  static const int maxStaminaPurchasePerDay = 3;

  /// 每次购买体力数量
  static const int staminaPurchaseAmount = 60;

  // ==================== PVP ====================

  /// PVP 每日免费次数
  static const int pvpDailyFreeAttempts = 5;

  /// PVP 每日最大购买次数
  static const int pvpMaxPurchaseAttempts = 5;

  /// PVP 购买次数消耗元宝
  static const int pvpPurchaseCost = 50;

  /// 竞技场每日挑战次数
  static const int arenaDailyAttempts = 10;

  // ==================== 副本 ====================

  /// 普通副本每日重置次数
  static const int normalDungeonDailyResets = 2;

  /// 精英副本每日挑战次数
  static const int eliteDungeonDailyAttempts = 3;

  /// 困难副本每日挑战次数
  static const int hardDungeonDailyAttempts = 2;

  /// 副本扫荡所需星数
  static const int dungeonSweepStarRequirement = 3;

  // ==================== 招贤（抽卡）系统 ====================

  /// 单抽消耗
  static const int singleRecruitCost = 1;

  /// 十连抽消耗
  static const int tenRecruitCost = 10;

  /// SSR 保底次数
  static const int ssrGuaranteeCount = 90;

  /// SR 保底次数（十连内必有 SR）
  static const int srGuaranteeCount = 10;

  /// SSR UP 保底次数
  static const int ssrUpGuaranteeCount = 180;

  /// 保底计数重置触发稀有度
  static const String guaranteeRarity = 'SSR';

  // ==================== 远征系统 ====================

  /// 远征每日免费次数
  static const int expeditionDailyFreeAttempts = 2;

  /// 远征最大同时进行数
  static const int maxConcurrentExpeditions = 3;

  /// 远征基础时长（分钟）
  static const int expeditionBaseDurationMinutes = 60;

  // ==================== 国战系统 ====================

  /// 国战报名开始时间（时）
  static const int nationalWarSignupStartHour = 10;

  /// 国战报名结束时间（时）
  static const int nationalWarSignupEndHour = 18;

  /// 国战开始时间（时）
  static const int nationalWarStartHour = 20;

  /// 国战持续时间（分钟）
  static const int nationalWarDurationMinutes = 60;

  /// 国战每日参战次数
  static const int nationalWarDailyAttempts = 3;

  // ==================== 任务系统 ====================

  /// 每日任务数量
  static const int dailyQuestCount = 8;

  /// 每日任务活跃度上限
  static const int dailyActivityMax = 100;

  /// 周常任务数量
  static const int weeklyQuestCount = 10;

  /// 成就任务刷新间隔（天）
  static const int achievementRefreshDays = 7;

  // ==================== 商店系统 ====================

  /// 普通商店每日刷新次数
  static const int normalShopDailyRefresh = 1;

  /// 竞技场商店每日刷新次数
  static const int arenaShopDailyRefresh = 1;

  /// 黑市随机出现概率
  static const double blackMarketAppearanceRate = 0.2;

  // ==================== 联盟系统 ====================

  /// 联盟最小人数
  static const int allianceMinMembers = 1;

  /// 联盟最大人数
  static const int allianceMaxMembers = 50;

  /// 联盟名称最大长度
  static const int allianceNameMaxLength = 8;

  /// 联盟创建消耗元宝
  static const int allianceCreateCost = 500;

  // ==================== 邮件系统 ====================

  /// 邮件最大保存天数
  static const int mailMaxRetentionDays = 30;

  /// 邮件附件领取期限（天）
  static const int mailAttachmentExpireDays = 7;

  /// 邮件最大存储数量
  static const int mailMaxCount = 100;
}
