/// 应用主题定义
///
/// 基于 Material 3 构建国风暗色主题，配合三国游戏的整体视觉风格。
/// 默认使用暗色主题（国风游戏更适合深色），同时保留亮色主题支持。
///
/// 主题中集成了 [KingdomTheme] 扩展，可通过
/// `Theme.of(context).extension<KingdomTheme>()` 获取阵营色。
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_shadows.dart';
import 'app_text_styles.dart';
import 'kingdom_theme.dart';

/// 应用主题
///
/// 提供 [lightTheme] 和 [darkTheme] 两套主题配置。
/// 默认使用 [darkTheme]，与国风游戏的深色视觉风格一致。
///
/// 使用方式：
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   themeMode: ThemeMode.dark,
/// )
/// ```
class AppTheme {
  AppTheme._();

  /// 亮色主题
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  /// 暗色主题（默认）
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  /// 构建主题
  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      // ==================== 颜色方案 ====================
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        error: AppColors.error,
        surface: isDark ? AppColors.surface : const Color(0xFFF5F5F5),
        onSurface: isDark ? AppColors.textPrimary : const Color(0xFF1A1A1A),
      ),

      // ==================== 脚手架 ====================
      scaffoldBackgroundColor:
          isDark ? AppColors.background : const Color(0xFFFAFAFA),

      // ==================== AppBar ====================
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.surface : Colors.white,
        foregroundColor: isDark ? AppColors.textPrimary : AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: isDark ? AppColors.textPrimary : AppColors.background,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),

      // ==================== 底部导航栏 ====================
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xE63E2723),
        indicatorColor: AppColors.accent.withValues(alpha: 0.3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // ==================== 卡片 ====================
      cardTheme: CardThemeData(
        color: isDark ? AppColors.cardBackground : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ==================== 对话框 ====================
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.surface : Colors.white,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: isDark ? AppColors.textPrimary : AppColors.background,
        ),
      ),

      // ==================== 底部弹窗 ====================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.surface : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ==================== 按钮 ====================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.titleMedium,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.textPrimary : AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: isDark
                ? AppColors.textSecondary.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.5),
          ),
          textStyle: AppTextStyles.titleMedium,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTextStyles.titleSmall,
        ),
      ),

      // ==================== 输入框 ====================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.surface.withValues(alpha: 0.8)
            : const Color(0xFFF5F5F5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.textHint.withValues(alpha: 0.3)
                : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // ==================== 分割线 ====================
      dividerTheme: DividerThemeData(
        color: isDark
            ? AppColors.textHint.withValues(alpha: 0.2)
            : Colors.grey.shade200,
        thickness: 1,
        space: 1,
      ),

      // ==================== Chip ====================
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.surface : Colors.grey.shade100,
        selectedColor: AppColors.accent.withValues(alpha: 0.2),
        labelStyle: AppTextStyles.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
      ),

      // ==================== Tab ====================
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.accent,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.accent,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AppTextStyles.titleSmall,
        unselectedLabelStyle: AppTextStyles.bodySmall,
      ),

      // ==================== Switch ====================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return isDark ? AppColors.textHint : Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withValues(alpha: 0.5);
          }
          return isDark
              ? AppColors.textHint.withValues(alpha: 0.3)
              : Colors.grey.shade300;
        }),
      ),

      // ==================== Slider ====================
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor:
            isDark ? AppColors.textHint.withValues(alpha: 0.3) : Colors.grey.shade300,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accent.withValues(alpha: 0.12),
      ),

      // ==================== ProgressIndicator ====================
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor:
            isDark ? AppColors.textHint.withValues(alpha: 0.3) : Colors.grey.shade300,
      ),

      // ==================== FloatingActionBar ====================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ==================== SnackBar ====================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.surface : const Color(0xFF333333),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ==================== BottomNavigationBar (legacy) ====================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.surface : Colors.white,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ==================== ListTile ====================
      listTileTheme: ListTileThemeData(
        textColor: isDark ? AppColors.textPrimary : AppColors.background,
        iconColor: isDark ? AppColors.textSecondary : AppColors.textHint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),

      // ==================== PopupMenu ====================
      popupMenuTheme: PopupMenuThemeData(
        color: isDark ? AppColors.surface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.textPrimary : AppColors.background,
        ),
      ),

      // ==================== Tooltip ====================
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : const Color(0xFF333333),
          borderRadius: BorderRadius.circular(4),
          boxShadow: AppShadows.dialog,
        ),
        textStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
        ),
      ),

      // ==================== 文字主题 ====================
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // ==================== 主题扩展 ====================
      extensions: const <ThemeExtension<dynamic>>[
        KingdomTheme(
          weiColor: AppColors.wei,
          shuColor: AppColors.shu,
          wuColor: AppColors.wu,
          qunColor: AppColors.qun,
          jinColor: AppColors.jin,
          femaleColor: AppColors.female,
        ),
      ],
    );
  }
}
