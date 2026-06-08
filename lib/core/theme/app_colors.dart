/// 国风颜色规范
///
/// 定义三国游戏所需的全部颜色常量，包括：
/// - 主色系：朱红、青绿、金黄
/// - 基础色：墨黑背景、表面色、卡片色
/// - 文字色：主/次/提示三级
/// - 功能色：错误、成功、警告、信息
/// - 稀有度色：N/R/SR/SSR/UR/绝世
/// - 阵营色：魏/蜀/吴/群/晋/女将
library;

import 'package:flutter/material.dart';

/// 应用颜色常量
///
/// 所有颜色集中定义，全局统一引用，便于主题切换和颜色调整。
/// 使用方式：`AppColors.primary` 而非硬编码色值。
class AppColors {
  AppColors._();

  // ==================== 主色 ====================

  /// 朱红 - 主色调，代表蜀汉之红、战场热血
  static const Color primary = Color(0xFFC62828);

  /// 青绿 - 辅助色，代表山川草木、吴国之风
  static const Color secondary = Color(0xFF1B5E20);

  /// 金黄 - 强调色，代表帝王权柄、至高荣耀
  static const Color accent = Color(0xFFFFB300);

  // ==================== 基础色 ====================

  /// 墨黑背景 - 主背景色，深沉如墨
  static const Color background = Color(0xFF1A1A1A);

  /// 表面色 - 卡片、对话框等浮层底色
  static const Color surface = Color(0xFF2D2D2D);

  /// 卡片背景 - 深褐色，模拟古卷/竹简质感
  static const Color cardBackground = Color(0xFF3E2723);

  // ==================== 文字色 ====================

  /// 主文字 - 白灰色，保证深色背景下的可读性
  static const Color textPrimary = Color(0xFFF5F5F5);

  /// 次文字 - 浅灰色，用于次要信息
  static const Color textSecondary = Color(0xFFBDBDBD);

  /// 提示文字 - 深灰色，用于占位符、禁用态
  static const Color textHint = Color(0xFF757575);

  // ==================== 功能色 ====================

  /// 错误/危险 - 红色
  static const Color error = Color(0xFFD32F2F);

  /// 成功/确认 - 绿色
  static const Color success = Color(0xFF388E3C);

  /// 警告/注意 - 橙色
  static const Color warning = Color(0xFFF57C00);

  /// 信息/提示 - 蓝色
  static const Color info = Color(0xFF1976D2);

  // ==================== 稀有度色 ====================

  /// 普通(N) - 灰色
  static const Color rarityN = Color(0xFF9E9E9E);

  /// 稀有(R) - 蓝色
  static const Color rarityR = Color(0xFF42A5F5);

  /// 史诗(SR) - 紫色
  static const Color raritySR = Color(0xFFAB47BC);

  /// 传说(SSR) - 金色
  static const Color raritySSR = Color(0xFFFFB300);

  /// 至尊(UR) - 橙金色
  static const Color rarityUR = Color(0xFFFF6F00);

  /// 绝世(Legendary) - 红色
  static const Color rarityLegendary = Color(0xFFF44336);

  // ==================== 阵营色 ====================

  /// 魏 - 蓝色，代表曹操的雄才大略、北方之水
  static const Color wei = Color(0xFF1565C0);

  /// 蜀 - 红色，代表刘备的仁义忠勇、蜀汉正统
  static const Color shu = Color(0xFFC62828);

  /// 吴 - 绿色，代表孙权的英武、江东之翠
  static const Color wu = Color(0xFF2E7D32);

  /// 群 - 紫色，代表群雄割据、王霸之气
  static const Color qun = Color(0xFF6A1B9A);

  /// 晋 - 灰蓝色，代表司马氏的深谋远虑、统一之势
  static const Color jin = Color(0xFF37474F);

  /// 女将 - 粉红色，代表巾帼不让须眉
  static const Color female = Color(0xFFAD1457);

  // ==================== 便捷方法 ====================

  /// 根据稀有度等级获取对应颜色
  ///
  /// [rarity] 稀有度标识，如 'N', 'R', 'SR', 'SSR', 'UR', 'L'
  static Color getRarityColor(String rarity) {
    switch (rarity.toUpperCase()) {
      case 'N':
        return rarityN;
      case 'R':
        return rarityR;
      case 'SR':
        return raritySR;
      case 'SSR':
        return raritySSR;
      case 'UR':
        return rarityUR;
      case 'L':
      case 'LEGENDARY':
        return rarityLegendary;
      default:
        return rarityN;
    }
  }

  /// 根据阵营标识获取对应颜色
  ///
  /// [kingdom] 阵营标识，如 'wei', 'shu', 'wu', 'qun', 'jin', 'female'
  static Color getKingdomColor(String kingdom) {
    switch (kingdom.toLowerCase()) {
      case 'wei':
        return wei;
      case 'shu':
        return shu;
      case 'wu':
        return wu;
      case 'qun':
        return qun;
      case 'jin':
        return jin;
      case 'female':
        return female;
      default:
        return textSecondary;
    }
  }
}
