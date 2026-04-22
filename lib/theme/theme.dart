import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF19E6B3);
  static const Color primaryDark = Color(0xFF14B88F);

  static const Color backgroundLight = Color(0xFFF8F6FF);

  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color oatmeal = Color(0xFFEBE3D5);

  static const Color textMain = Color(0xFF1A1A2E);
  static const Color textSub = Color(0xFF4E9785);

  static const Color moodHappy = Color(0xFFFFF9C4);
  static const Color moodSad = Color(0xFFE1F5FE);
  static const Color moodExcited = Color(0xFFFFEBEE);
  static const Color moodChill = Color(0xFFE8F5E9);

  static const Color gradientPinkStart = Color(0xFFFF6B9D);
  static const Color gradientPinkEnd = Color(0xFFFF8E53);

  static const Color gradientPurpleStart = Color(0xFFA855F7);
  static const Color gradientPurpleEnd = Color(0xFF6366F1);

  static const Color gradientTealStart = Color(0xFF06B6D4);
  static const Color gradientTealEnd = Color(0xFF10B981);

  static const Color gradientOrangeStart = Color(0xFFF97316);
  static const Color gradientOrangeEnd = Color(0xFFEC4899);

  static const Color gradientRoseStart = Color(0xFFF43F5E);
  static const Color gradientRoseEnd = Color(0xFFFB7185);

  static const Color cardShadow = Color(0x1A000000);
  static const Color cardBorder = Color(0x0D000000);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
      surface: AppColors.surfaceLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: ThemeData.light().textTheme.apply(bodyColor: AppColors.textMain, displayColor: AppColors.textMain),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      centerTitle: false,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textMain,
    ),
  );
}
