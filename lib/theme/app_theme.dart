import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgPaper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.inkRed,
        surface: AppColors.bgPaper,
        onSurface: AppColors.inkBlack,
        primary: AppColors.inkRed,
        onPrimary: AppColors.bgPaper,
        secondary: AppColors.woodDark,
        onSecondary: AppColors.bgPaper,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.maShanZheng(
          fontSize: 56,
          color: AppColors.inkBlack,
        ),
        displayMedium: GoogleFonts.maShanZheng(
          fontSize: 48,
          color: AppColors.inkBlack,
        ),
        displaySmall: GoogleFonts.maShanZheng(
          fontSize: 36,
          color: AppColors.inkBlack,
        ),
        headlineLarge: GoogleFonts.notoSerifSc(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.inkBlack,
        ),
        headlineMedium: GoogleFonts.notoSerifSc(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.inkBlack,
        ),
        bodyLarge: GoogleFonts.notoSerifSc(
          fontSize: 18,
          color: AppColors.inkBlack,
        ),
        bodyMedium: GoogleFonts.notoSerifSc(
          fontSize: 16,
          color: AppColors.inkBlack,
        ),
        bodySmall: GoogleFonts.notoSerifSc(
          fontSize: 14,
          color: AppColors.woodDark,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.inkBlack,
      ),
    );
  }
}
