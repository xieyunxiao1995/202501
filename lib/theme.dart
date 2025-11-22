import 'package:flutter/material.dart';

class AppColors {
  // --- 主题色 ---
  /// app整体背景色
  static const Color primaryColor = Color.fromRGBO(7, 6, 12, 1);

  /// 其他背景色 (白色带透明度)
  static const Color backgroundWhite6 = Color.fromRGBO(255, 255, 255, 0.06);
  static const Color backgroundWhite8 = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color backgroundWhite10 = Color.fromRGBO(255, 255, 255, 0.10);
  static const Color backgroundWhite15 = Color.fromRGBO(255, 255, 255, 0.15);

  /// 弹窗背景色
  static const Color dialogBackground = Color.fromRGBO(37, 36, 41, 1);

  // --- 文字颜色 ---
  /// 主要文字颜色 (白色)
  static const Color textPrimary = Color.fromRGBO(255, 255, 255, 1);

  /// 次要文字颜色 (白色 40% 透明度)
  static const Color textSecondary = Color.fromRGBO(255, 255, 255, 0.4);

  // --- 渐变色 ---
  /// 金色渐变 - 起始色
  static const Color goldGradientStart = Color.fromRGBO(241, 184, 115, 1);

  /// 金色渐变 - 结束色
  static const Color goldGradientEnd = Color.fromRGBO(242, 219, 168, 1);

  // --- 功能/状态颜色 ---
  /// 粉色 (特殊文本)
  static const Color accentPink = Color.fromRGBO(248, 80, 137, 1);

  /// 绿色 (特殊文本)
  static const Color accentGreen = Color.fromRGBO(31, 224, 166, 1);

  /// 在线状态绿
  static const Color statusOnline = Color.fromRGBO(13, 255, 81, 1);

  /// 蓝色 (特殊文本)
  static const Color accentBlue = Color.fromRGBO(56, 207, 255, 1);

  static const Color red = Color(0xFFFF0048);
  static const Color lightRed = Color(0xFFFF4545);

  /// VIP 金色
  static const Color vipGold = Color.fromRGBO(52, 47, 46, 1);

  /// 深蓝底部渐变起始色
  static const Color footerGradientStart = Color(0xFF1E2533);

  /// 深蓝底部渐变结束色
  static const Color footerGradientEnd = Color.fromRGBO(30, 37, 51, 0.2);

  // 按钮黑
  static const Color btnText = Color.fromRGBO(27, 27, 37, 1);

  /// 阴影颜色
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.1);

  /// 输入框背景色
  static const Color textFieldBackground = Color(0xFF252429);

  /// 输入框提示文字/前缀颜色
  static const Color textFieldHint = Color(0xFF949496);

  static const Color userInfoGrayColor = Color(0xFFA09FA1);

  /// TabBar 背景色
  static const Color tabBarBackground = Color(0xFF151419);

  // image boreder颜色
  static const Color borderColor = Color(0xFF757576);

  static const Color upgradeToVipColor = Color(0xFFF8DDC4);

  static const Color containerBlackColor = Color(0xFF212121);

  static const Color invateScreenColor = Color(0xFF222222);
  static const Color pickUtilsColor = Color(0xFF1C1B20);

  static const Color diamondSelectBorder = Color(0xFF799EFC);

  /// TabBar 未选中颜色
  static const Color tabBarNormal = Color(0xFF89888b);

  /// TabBar 选中颜色
  static const Color tabBarSelected = Colors.white;

  // --- 渐变色 (原始颜色) ---
  /// 登录/注册按钮渐变色 - 起始色
  static const Color secondaryGradientStart = Color(0xFFF1B873);

  /// 登录/注册按钮渐变色 - 结束色
  static const Color secondaryGradientEnd = Color(0xFFF2DBA8);
}

ThemeData primaryTheme = ThemeData(
  // seed
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),

  // scaffold color
  scaffoldBackgroundColor: AppColors.primaryColor,

  // app bar theme colors
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),

  textTheme: const TextTheme(
    // 你仍然可以在这里定义一些全局的、包含字号的样式，供特定场景使用
    // 但我们的 StyledText 将不再直接依赖它们
  ),
  tabBarTheme: const TabBarThemeData(
    labelStyle: TextStyle(
      fontSize: 16, // 32.sp in flutter screenutil
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 13, // 26.sp in flutter screenutil
    ),
    labelColor: AppColors.textPrimary,
    unselectedLabelColor: AppColors.textSecondary,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: Colors.transparent,
    indicatorColor: Colors.transparent,
  ),
  // TextButton 主题
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.textPrimary, // TextButton 文本颜色
    ),
  ),
  // loading颜色
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.secondaryGradientEnd,
    linearMinHeight: 6, // 增加厚度以获得更好的视觉效果
  ),
);

/// --- 文本基础样式 (不含字号) ---

/// 主要文字样式 (白色, 普通字重)
const TextStyle textStylePrimary = TextStyle(
  color: AppColors.textPrimary,
  letterSpacing: 1,
);

/// 次要文字样式 (灰色, 普通字重)
const TextStyle textStyleSecondary = TextStyle(
  color: AppColors.textSecondary,
  letterSpacing: 1,
);

/// 主要文字样式 (白色, 粗体)
const TextStyle textStylePrimaryBold = TextStyle(
  color: AppColors.textPrimary,
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
);

/// 按钮文字样式 (黑色, 粗体)
const TextStyle textStyleInButton = TextStyle(
  color: AppColors.tabBarBackground,
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
);

class AppGradients {
  /// 主渐变色 (金色)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.goldGradientStart, AppColors.goldGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// 登录/注册按钮渐变色
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.secondaryGradientStart, AppColors.secondaryGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// 底部模块渐变
  static const LinearGradient footerGradient = LinearGradient(
    colors: [AppColors.footerGradientStart, AppColors.footerGradientEnd],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  // 淡淡的金色
  static const LinearGradient paleGoldGradient = LinearGradient(
    colors: [Color(0xFFFFEDBA), Color(0xFFFFDD87)],
  );
}
