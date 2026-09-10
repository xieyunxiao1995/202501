import 'package:flutter/material.dart';

/// 深色霓虹渐变主题色彩系统
/// 参考风格：深色背景 + 霓虹渐变强调色 + 卡片悬浮效果
class AppColors {
  // ==========================================
  // 深色背景系统 - Deep Dark Background
  // ==========================================
  static const Color background = Color(0xFF0D0D15); // 主背景 - 极深紫黑
  static const Color backgroundSecondary = Color(0xFF12121F); // 次级背景
  static const Color surface = Color(0xFF1A1A2E); // 卡片表面 - 深紫灰
  static const Color surfaceLight = Color(0xFF252540); // 浅色表面
  static const Color surfaceElevated = Color(0xFF2D2D4A); // 悬浮卡片

  // ==========================================
  // 霓虹渐变强调色 - Neon Accent Gradients
  // ==========================================
  // 粉紫渐变 - 主要强调色
  static const Color pinkStart = Color(0xFFFF6B9D);
  static const Color pinkEnd = Color(0xFFFF8FB3);

  // 紫粉渐变 - 梦幻感
  static const Color purpleStart = Color(0xFF9B59FF);
  static const Color purpleEnd = Color(0xFFE056FD);

  // 青绿渐变 - 清新感
  static const Color cyanStart = Color(0xFF00D4FF);
  static const Color cyanEnd = Color(0xFF00F5A8);

  // 橙黄渐变 - 活力感
  static const Color orangeStart = Color(0xFFFFA726);
  static const Color orangeEnd = Color(0xFFFF7043);

  // 蓝紫渐变 - 科技感
  static const Color blueStart = Color(0xFF667EEA);
  static const Color blueEnd = Color(0xFF764BA2);

  // 日落渐变 - 温暖感
  static const Color sunsetStart = Color(0xFFF093FB);
  static const Color sunsetEnd = Color(0xFFF5576C);

  // 海洋渐变 - 清凉感
  static const Color oceanStart = Color(0xFF4FACFE);
  static const Color oceanEnd = Color(0xFF00F2FE);

  // ==========================================
  // 主色调映射
  // ==========================================
  static const Color primary = Color(0xFFFF6B9D); // 主色 - 霓虹粉
  static const Color primaryLight = Color(0xFFFF8FB3);
  static const Color primaryDark = Color(0xFFE85A8C);

  static const Color accentGold = Color(0xFFFFB347);
  static const Color accentGoldLight = Color(0xFFFFD700);
  static const Color accentGoldDark = Color(0xFFFF8C42);

  // ==========================================
  // 文字系统 - 高对比度深色模式
  // ==========================================
  static const Color textPrimary = Color(0xFFFFFFFF); // 主文字 - 纯白
  static const Color textSecondary = Color(0xFFB8B8D0); // 次级文字 - 灰紫
  static const Color textLight = Color(0xFF6B6B8A); // 辅助文字 - 深灰紫
  static const Color textMuted = Color(0xFF4A4A6A); // 最淡文字
  static const Color textWhite = Color(0xFFFFFFFF);

  // ==========================================
  // 状态色
  // ==========================================
  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);

  // ==========================================
  // 发光效果色
  // ==========================================
  static const Color glowPink = Color(0x40FF6B9D); // 粉色光晕
  static const Color glowPurple = Color(0x409B59FF); // 紫色光晕
  static const Color glowCyan = Color(0x4000D4FF); // 青色光晕
  static const Color glowGold = Color(0x40FFB347); // 金色光晕

  // ==========================================
  // 渐变定义 - 霓虹风格
  // ==========================================

  /// 金色渐变
  static const LinearGradient goldGradient = LinearGradient(
    colors: [accentGoldLight, accentGold, accentGoldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 表面渐变 - 深色卡片用
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, surfaceLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 主渐变 - 霓虹粉
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 霓虹粉渐变
  static const LinearGradient pinkGradient = LinearGradient(
    colors: [pinkStart, pinkEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 霓虹紫渐变
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purpleStart, purpleEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 霓虹青渐变
  static const LinearGradient cyanGradient = LinearGradient(
    colors: [cyanStart, cyanEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 霓虹橙渐变
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orangeStart, orangeEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 暖色渐变
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 冷色渐变 - 蓝紫
  static const LinearGradient coolGradient = LinearGradient(
    colors: [blueStart, blueEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 日落渐变
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [sunsetStart, sunsetEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 海洋渐变
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [oceanStart, oceanEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 按钮渐变 - 紫粉
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF9B59FF), Color(0xFFFF6B9D)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// 按钮渐变 - 粉橙
  static const LinearGradient buttonGradientAlt = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFFFA726)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ==========================================
  // 辅助方法
  // ==========================================

  /// 获取渐变色列表
  static List<LinearGradient> get gradientList => [
    pinkGradient,
    purpleGradient,
    cyanGradient,
    orangeGradient,
    warmGradient,
    coolGradient,
    sunsetGradient,
    oceanGradient,
  ];

  /// 根据索引获取渐变
  static LinearGradient getGradientByIndex(int index) {
    return gradientList[index % gradientList.length];
  }
}
