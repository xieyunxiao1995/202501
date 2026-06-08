/// 国风文字样式
///
/// 定义应用中所有文字样式，涵盖：
/// - 标题样式：大号书法体风格，粗体大字号
/// - 副标题样式：中号，用于章节标题等
/// - 正文样式：楷体风格，适合长文阅读
/// - 说明/提示样式：小号灰色
/// - 稀有度文字样式：带对应颜色的武将/装备名称
/// - 战斗数字样式：伤害/治疗等数值
/// - 货币数字样式：金币/元宝等资源数值
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 应用文字样式常量
///
/// 所有文字样式集中定义，统一管理字号、字重、颜色等属性。
/// 使用方式：`AppTextStyles.headlineLarge` 而非硬编码 TextStyle。
class AppTextStyles {
  AppTextStyles._();

  // ==================== 标题样式 ====================

  /// 超大标题 - 用于闪屏、开场的场景标题
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 2.0,
    height: 1.3,
  );

  /// 大标题 - 用于页面主标题，如"武将列表"
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
    height: 1.3,
  );

  /// 标题 - 用于对话框标题、卡片标题
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
    height: 1.4,
  );

  /// 小标题 - 用于区域标题
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// 迷你标题 - 用于列表项标题
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.0,
    height: 1.4,
  );

  // ==================== 副标题样式 ====================

  /// 副标题1 - 用于章节标题、面板名称
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// 副标题2 - 用于列表项、标签
  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.5,
  );

  /// 副标题3 - 用于小标签、按钮文字
  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // ==================== 正文样式 ====================

  /// 正文大号 - 用于重要内容段落
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.6,
  );

  /// 正文 - 默认正文样式，楷体风格
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.6,
  );

  /// 正文小号 - 用于辅助信息
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.5,
  );

  // ==================== 说明/提示样式 ====================

  /// 说明文字 - 用于描述、注释
  static const TextStyle labelLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// 提示文字 - 用于占位符、辅助说明
  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// 迷你提示 - 用于角标、时间戳
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    letterSpacing: 0.5,
    height: 1.3,
  );

  // ==================== 稀有度文字样式 ====================

  /// 普通(N)文字样式
  static const TextStyle rarityN = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.rarityN,
    letterSpacing: 0.5,
  );

  /// 稀有(R)文字样式
  static const TextStyle rarityR = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.rarityR,
    letterSpacing: 0.5,
  );

  /// 史诗(SR)文字样式
  static const TextStyle raritySR = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.raritySR,
    letterSpacing: 0.5,
  );

  /// 传说(SSR)文字样式
  static const TextStyle raritySSR = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.raritySSR,
    letterSpacing: 0.5,
  );

  /// 至尊(UR)文字样式
  static const TextStyle rarityUR = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    color: AppColors.rarityUR,
    letterSpacing: 0.5,
  );

  /// 绝世(Legendary)文字样式
  static const TextStyle rarityLegendary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    color: AppColors.rarityLegendary,
    letterSpacing: 0.5,
  );

  /// 根据稀有度获取对应文字样式
  ///
  /// [rarity] 稀有度标识，如 'N', 'R', 'SR', 'SSR', 'UR', 'L'
  /// [fontSize] 可选自定义字号
  static TextStyle getRarityStyle(String rarity, {double? fontSize}) {
    final baseStyle = switch (rarity.toUpperCase()) {
      'N' => rarityN,
      'R' => rarityR,
      'SR' => raritySR,
      'SSR' => raritySSR,
      'UR' => rarityUR,
      'L' || 'LEGENDARY' => rarityLegendary,
      _ => rarityN,
    };
    if (fontSize != null) {
      return baseStyle.copyWith(fontSize: fontSize);
    }
    return baseStyle;
  }

  // ==================== 伤害数字样式 ====================

  /// 普通伤害数字
  static const TextStyle damageNormal = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 1.0,
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(1, 1),
        blurRadius: 2,
      ),
    ],
  );

  /// 暴击伤害数字
  static const TextStyle damageCritical = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.accent,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(2, 2),
        blurRadius: 3,
      ),
      Shadow(
        color: AppColors.primary,
        offset: Offset(0, 0),
        blurRadius: 8,
      ),
    ],
  );

  /// 治疗数字
  static const TextStyle damageHeal = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.success,
    letterSpacing: 1.0,
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(1, 1),
        blurRadius: 2,
      ),
    ],
  );

  /// 护盾数字
  static const TextStyle damageShield = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.lightBlue,
    letterSpacing: 1.0,
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(1, 1),
        blurRadius: 2,
      ),
    ],
  );

  /// 减伤数字
  static const TextStyle damageReduce = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.grey,
    letterSpacing: 0.5,
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(1, 1),
        blurRadius: 2,
      ),
    ],
  );

  // ==================== 货币数字样式 ====================

  /// 金币数字
  static const TextStyle currencyGold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
    letterSpacing: 0.5,
  );

  /// 元宝数字
  static const TextStyle currencyPremium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Color(0xFFFFD54F),
    letterSpacing: 0.5,
    shadows: [
      Shadow(
        color: Color(0xFFFF8F00),
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
  );

  /// 体力数字
  static const TextStyle currencyStamina = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    letterSpacing: 0.5,
  );

  /// 经验数字
  static const TextStyle currencyExp = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.info,
    letterSpacing: 0.5,
  );

  // ==================== 阵营名称样式 ====================

  /// 魏国文字样式
  static const TextStyle kingdomWei = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.wei,
    letterSpacing: 1.0,
  );

  /// 蜀国文字样式
  static const TextStyle kingdomShu = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.shu,
    letterSpacing: 1.0,
  );

  /// 吴国文字样式
  static const TextStyle kingdomWu = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.wu,
    letterSpacing: 1.0,
  );

  /// 群雄文字样式
  static const TextStyle kingdomQun = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.qun,
    letterSpacing: 1.0,
  );

  /// 晋国文字样式
  static const TextStyle kingdomJin = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.jin,
    letterSpacing: 1.0,
  );

  /// 女将文字样式
  static const TextStyle kingdomFemale = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.female,
    letterSpacing: 1.0,
  );

  /// 根据阵营获取对应文字样式
  ///
  /// [kingdom] 阵营标识，如 'wei', 'shu', 'wu', 'qun', 'jin', 'female'
  /// [fontSize] 可选自定义字号
  static TextStyle getKingdomStyle(String kingdom, {double? fontSize}) {
    final baseStyle = switch (kingdom.toLowerCase()) {
      'wei' => kingdomWei,
      'shu' => kingdomShu,
      'wu' => kingdomWu,
      'qun' => kingdomQun,
      'jin' => kingdomJin,
      'female' => kingdomFemale,
      _ => bodyMedium,
    };
    if (fontSize != null) {
      return baseStyle.copyWith(fontSize: fontSize);
    }
    return baseStyle;
  }
}
