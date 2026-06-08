/// 阴影样式定义
///
/// 提供应用中所需的各类阴影效果，包括：
/// - 卡片阴影：普通卡片和武将卡片的阴影
/// - 文字阴影：战斗UI中使用的文字阴影
/// - 发光效果：稀有度光效、按钮发光等
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 应用阴影样式
///
/// 所有阴影集中定义，统一管理偏移、模糊和颜色。
/// 使用方式：`AppShadows.card` 获取卡片阴影列表。
class AppShadows {
  AppShadows._();

  // ==================== 卡片阴影 ====================

  /// 普通卡片阴影 - 轻微抬升感
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  /// 悬浮卡片阴影 - 明显抬升感（hover/elevated 状态）
  static List<BoxShadow> get cardElevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          offset: const Offset(0, 4),
          blurRadius: 16,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  /// 对话框阴影 - 大范围柔和阴影
  static List<BoxShadow> get dialog => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];

  // ==================== 武将卡片阴影 ====================

  /// 武将卡片基础阴影
  static List<BoxShadow> get generalCard => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          offset: const Offset(0, 0),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  /// SSR武将卡片阴影 - 带金色光晕
  static List<BoxShadow> get generalCardSSR => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.3),
          offset: const Offset(0, 0),
          blurRadius: 24,
          spreadRadius: 4,
        ),
      ];

  /// UR武将卡片阴影 - 带橙金光晕
  static List<BoxShadow> get generalCardUR => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.rarityUR.withValues(alpha: 0.4),
          offset: const Offset(0, 0),
          blurRadius: 28,
          spreadRadius: 6,
        ),
      ];

  /// 绝世武将卡片阴影 - 带红色光晕
  static List<BoxShadow> get generalCardLegendary => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.rarityLegendary.withValues(alpha: 0.5),
          offset: const Offset(0, 0),
          blurRadius: 32,
          spreadRadius: 8,
        ),
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.2),
          offset: const Offset(0, 0),
          blurRadius: 48,
          spreadRadius: 2,
        ),
      ];

  /// 根据稀有度获取武将卡片阴影
  ///
  /// [rarity] 稀有度标识
  static List<BoxShadow> getGeneralCardShadow(String rarity) {
    return switch (rarity.toUpperCase()) {
      'SSR' => generalCardSSR,
      'UR' => generalCardUR,
      'L' || 'LEGENDARY' => generalCardLegendary,
      _ => generalCard,
    };
  }

  // ==================== 文字阴影 ====================

  /// 普通文字阴影 - 战斗UI中白色文字的描边效果
  static List<Shadow> get textOutline => [
        Shadow(
          color: Colors.black.withValues(alpha: 0.7),
          offset: const Offset(1, 1),
          blurRadius: 2,
        ),
      ];

  /// 强调文字阴影 - 重要数值的发光效果
  static List<Shadow> get textGlow => [
        Shadow(
          color: Colors.black.withValues(alpha: 0.8),
          offset: const Offset(1, 1),
          blurRadius: 3,
        ),
        Shadow(
          color: AppColors.accent.withValues(alpha: 0.5),
          offset: const Offset(0, 0),
          blurRadius: 8,
        ),
      ];

  /// 标题文字阴影 - 大号标题的深色描边
  static List<Shadow> get titleShadow => [
        Shadow(
          color: Colors.black.withValues(alpha: 0.6),
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
      ];

  /// 朱红文字发光 - 用于血条减少等红色效果
  static List<Shadow> get textGlowRed => [
        Shadow(
          color: Colors.black.withValues(alpha: 0.8),
          offset: const Offset(1, 1),
          blurRadius: 3,
        ),
        Shadow(
          color: AppColors.primary.withValues(alpha: 0.6),
          offset: const Offset(0, 0),
          blurRadius: 10,
        ),
      ];

  /// 绿色文字发光 - 用于治疗效果
  static List<Shadow> get textGlowGreen => [
        Shadow(
          color: Colors.black.withValues(alpha: 0.8),
          offset: const Offset(1, 1),
          blurRadius: 3,
        ),
        Shadow(
          color: AppColors.success.withValues(alpha: 0.6),
          offset: const Offset(0, 0),
          blurRadius: 10,
        ),
      ];

  // ==================== 发光效果 ====================

  /// 主色发光 - 朱红色光晕
  static List<BoxShadow> get glowPrimary => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.5),
          offset: const Offset(0, 0),
          blurRadius: 16,
          spreadRadius: 2,
        ),
      ];

  /// 金色发光 - 用于选中态、高亮态
  static List<BoxShadow> get glowGold => [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.5),
          offset: const Offset(0, 0),
          blurRadius: 16,
          spreadRadius: 2,
        ),
      ];

  /// 青绿发光 - 用于成功/激活态
  static List<BoxShadow> get glowSecondary => [
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: 0.5),
          offset: const Offset(0, 0),
          blurRadius: 16,
          spreadRadius: 2,
        ),
      ];

  /// 按钮按压发光 - 按下时的反馈光效
  static List<BoxShadow> get buttonPressed => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.6),
          offset: const Offset(0, 0),
          blurRadius: 12,
          spreadRadius: 4,
        ),
      ];

  /// 底部导航选中发光
  static List<BoxShadow> get navSelected => [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.4),
          offset: const Offset(0, -2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];
}
