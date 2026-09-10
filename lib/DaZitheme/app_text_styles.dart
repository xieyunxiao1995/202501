import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 深色霓虹主题文字样式
/// 高对比度设计，适配深色背景
class AppTextStyles {
  // ==========================================
  // 标题样式 - Headlines
  // ==========================================

  /// 大标题 - 页面主标题
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// 中标题 - 区块标题
  static const TextStyle headline2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  /// 小标题 - 卡片标题
  static const TextStyle headline3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 导航标题
  static const TextStyle navTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // ==========================================
  // 正文样式 - Body
  // ==========================================

  /// 大正文
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 中正文 - 默认正文
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// 小正文
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ==========================================
  // 标签样式 - Labels
  // ==========================================

  /// 大标签 - 列表项标题
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  /// 中标签 - 辅助标签
  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  /// 小标签 - 微标签
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
    letterSpacing: 0.2,
  );

  // ==========================================
  // 按钮样式 - Buttons
  // ==========================================

  /// 主按钮
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  /// 小按钮
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  // ==========================================
  // 辅助文字 - Captions
  // ==========================================

  /// 说明文字
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.4,
  );

  /// 最淡文字 - 时间戳等
  static const TextStyle captionMuted = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // ==========================================
  // 特殊样式 - Special
  // ==========================================

  /// 渐变文字样式 - 需要配合 ShaderMask 使用
  static TextStyle gradientText({
    required LinearGradient gradient,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: Colors.white, // 占位色，实际由 ShaderMask 控制
      height: 1.2,
    );
  }

  /// 霓虹发光文字
  static TextStyle neonText({
    Color color = AppColors.primary,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.2,
      shadows: [
        Shadow(
          color: color.withAlpha(128),
          blurRadius: 8,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }
}
