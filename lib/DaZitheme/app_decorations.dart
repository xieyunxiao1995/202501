import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 深色霓虹主题装饰组件
/// 卡片悬浮效果 + 弥散光 + 胶囊形状
class AppDecorations {
  // ==========================================
  // 卡片装饰 - 悬浮卡片效果
  // ==========================================

  /// 标准卡片 - 深色悬浮效果
  static BoxDecoration card({
    Color? color,
    double radius = 20,
    bool hasGlow = false,
    Color? glowColor,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        // 主阴影 - 悬浮感
        BoxShadow(
          color: Colors.black.withAlpha(77),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -5,
        ),
        // 弥散光效果
        if (hasGlow)
          BoxShadow(
            color: (glowColor ?? AppColors.primary).withAlpha(51),
            blurRadius: 30,
            offset: const Offset(0, 4),
            spreadRadius: -10,
          ),
      ],
    );
  }

  /// 渐变卡片 - 带有渐变背景的卡片
  static BoxDecoration gradientCard({
    required LinearGradient gradient,
    double radius = 20,
    bool hasGlow = true,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: gradient.colors.first.withAlpha(77),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -5,
        ),
        if (hasGlow)
          BoxShadow(
            color: gradient.colors.last.withAlpha(40),
            blurRadius: 30,
            offset: const Offset(0, 4),
            spreadRadius: -10,
          ),
      ],
    );
  }

  /// 玻璃拟态卡片 - 半透明效果
  static BoxDecoration glassCard({double radius = 20, Color? color}) {
    return BoxDecoration(
      color: (color ?? AppColors.surface).withAlpha(230),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withAlpha(20), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(77),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // ==========================================
  // 按钮装饰 - 胶囊形状 + 发光
  // ==========================================

  /// 主按钮 - 胶囊形状渐变
  static BoxDecoration primaryButton({
    LinearGradient? gradient,
    bool isDisabled = false,
    double radius = 28,
  }) {
    final buttonGradient = gradient ?? AppColors.buttonGradient;

    return BoxDecoration(
      gradient: isDisabled ? null : buttonGradient,
      color: isDisabled ? AppColors.textMuted : null,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isDisabled
          ? null
          : [
              // 按钮发光效果
              BoxShadow(
                color: buttonGradient.colors.first.withAlpha(128),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -4,
              ),
              // 弥散光
              BoxShadow(
                color: buttonGradient.colors.last.withAlpha(51),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
    );
  }

  /// 小按钮 - 胶囊形状
  static BoxDecoration smallButton({
    LinearGradient? gradient,
    bool isDisabled = false,
  }) {
    return primaryButton(
      gradient: gradient,
      isDisabled: isDisabled,
      radius: 20,
    );
  }

  /// 金色按钮
  static BoxDecoration goldButton() {
    return BoxDecoration(
      gradient: AppColors.goldGradient,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: AppColors.accentGold.withAlpha(128),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: AppColors.accentGold.withAlpha(51),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// 轮廓按钮 - 带边框
  static BoxDecoration outlineButton({
    Color borderColor = AppColors.primary,
    double radius = 28,
  }) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor.withAlpha(128), width: 1.5),
    );
  }

  // ==========================================
  // 输入框装饰
  // ==========================================

  /// 深色输入框
  static InputDecoration inputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textLight),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  // ==========================================
  // 聊天气泡装饰
  // ==========================================

  /// 用户气泡 - 渐变背景
  static BoxDecoration userBubble() {
    return BoxDecoration(
      gradient: AppColors.pinkGradient,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(4),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.pinkStart.withAlpha(77),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// AI气泡 - 深色背景带边框
  static BoxDecoration aiBubble() {
    return BoxDecoration(
      color: AppColors.surfaceLight,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(20),
      ),
      border: Border.all(color: AppColors.primary.withAlpha(51), width: 1),
    );
  }

  // ==========================================
  // 头像装饰
  // ==========================================

  /// 头像容器 - 带发光边框
  static BoxDecoration avatar({
    double size = 60,
    LinearGradient? borderGradient,
  }) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: borderGradient ?? AppColors.pinkGradient,
      boxShadow: [
        BoxShadow(
          color: (borderGradient?.colors.first ?? AppColors.pinkStart)
              .withAlpha(77),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// 头像内圈
  static BoxDecoration avatarInner({double padding = 3}) {
    return BoxDecoration(shape: BoxShape.circle, color: AppColors.background);
  }

  // ==========================================
  // 标签装饰
  // ==========================================

  /// 渐变标签 - 胶囊形状
  static BoxDecoration tag({
    LinearGradient? gradient,
    Color? color,
    double radius = 12,
  }) {
    if (gradient != null) {
      return BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      );
    }
    return BoxDecoration(
      color: color ?? AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// 微标签 - 小尺寸
  static BoxDecoration microTag({LinearGradient? gradient, Color? color}) {
    return tag(gradient: gradient, color: color, radius: 8);
  }

  // ==========================================
  // 底部导航装饰
  // ==========================================

  /// 底部导航栏背景
  static BoxDecoration bottomNavBackground() {
    return BoxDecoration(
      color: AppColors.backgroundSecondary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(128),
          blurRadius: 20,
          offset: const Offset(0, -5),
        ),
      ],
    );
  }

  /// 导航项选中状态
  static BoxDecoration navItemActive({required LinearGradient gradient}) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: gradient.colors.first.withAlpha(128),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ==========================================
  // 分割线装饰
  // ==========================================

  /// 渐变分割线
  static BoxDecoration gradientDivider({LinearGradient? gradient}) {
    return BoxDecoration(gradient: gradient ?? AppColors.pinkGradient);
  }

  /// 金色分割线
  static BoxDecoration goldDivider() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.accentGold,
          AppColors.accentGold,
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  // ==========================================
  // 特殊效果装饰
  // ==========================================

  /// 霓虹发光效果
  static List<BoxShadow> neonGlow({
    Color color = AppColors.primary,
    double blurRadius = 20,
    double spreadRadius = -5,
  }) {
    return [
      BoxShadow(
        color: color.withAlpha(128),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: color.withAlpha(51),
        blurRadius: blurRadius * 1.5,
        spreadRadius: spreadRadius * 2,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// 悬浮阴影
  static List<BoxShadow> elevation({int level = 1}) {
    final shadows = [
      // Level 1
      [
        BoxShadow(
          color: Colors.black.withAlpha(26),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      // Level 2
      [
        BoxShadow(
          color: Colors.black.withAlpha(51),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      // Level 3
      [
        BoxShadow(
          color: Colors.black.withAlpha(77),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -5,
        ),
      ],
    ];
    return shadows[level.clamp(0, shadows.length - 1)];
  }
}
