import 'package:flutter/material.dart';

abstract final class AppColors {
  static const lavender = Color(0xFF8E68D9);
  static const deepLavender = Color(0xFF6040B3);
  static const ink = Color(0xFF28252D);
  static const surface = Color(0xFFFFFBFE);
}

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.lavender,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFFF8FB),
      fontFamily: 'PingFang SC',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(decoration: TextDecoration.none),
        bodyMedium: TextStyle(decoration: TextDecoration.none),
        bodySmall: TextStyle(decoration: TextDecoration.none),
        labelLarge: TextStyle(decoration: TextDecoration.none),
        labelMedium: TextStyle(decoration: TextDecoration.none),
        labelSmall: TextStyle(decoration: TextDecoration.none),
        titleLarge: TextStyle(decoration: TextDecoration.none),
        titleMedium: TextStyle(decoration: TextDecoration.none),
        titleSmall: TextStyle(decoration: TextDecoration.none),
      ),
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: .96),
        indicatorColor: AppColors.lavender.withValues(alpha: .14),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.deepLavender,
              decoration: TextDecoration.none,
            );
          }
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            decoration: TextDecoration.none,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lavender,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFF8F3FF),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
          decoration: TextDecoration.none,
        ),
        side: const BorderSide(color: Color(0xFFF0EAF1)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
