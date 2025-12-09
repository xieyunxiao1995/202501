import 'package:flutter/material.dart';
import 'constants.dart';

/// App Theme Configuration
class AppTheme {
  // Private constructor
  AppTheme._();

  /// Main theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.accentColor,
        surface: AppConstants.secondaryColor,
        error: Colors.red[700]!,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppConstants.secondaryColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.secondaryColor,
        foregroundColor: AppConstants.primaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppConstants.primaryColor,
          fontSize: AppConstants.fontSizeHeading2,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing24,
            vertical: AppConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          elevation: AppConstants.elevationMedium,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: BorderSide(color: Colors.grey[300]!),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing24,
            vertical: AppConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppConstants.primaryColor),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusRound),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing16,
          vertical: AppConstants.spacing12,
        ),
      ),

      // Text Theme
      textTheme: _textTheme,
    );
  }

  /// Text Theme
  static TextTheme get _textTheme {
    return TextTheme(
      // Headings
      displayLarge: TextStyle(
        fontSize: AppConstants.fontSizeHeading1,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: AppConstants.fontSizeHeading2,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: AppConstants.fontSizeHeading3,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),

      // Body Text
      bodyLarge: TextStyle(
        fontSize: AppConstants.fontSizeLarge,
        color: AppConstants.neutralColor,
      ),
      bodyMedium: TextStyle(
        fontSize: AppConstants.fontSizeMedium,
        color: AppConstants.neutralColor,
      ),
      bodySmall: TextStyle(
        fontSize: AppConstants.fontSizeSmall,
        color: AppConstants.neutralColor,
      ),

      // Labels
      labelLarge: TextStyle(
        fontSize: AppConstants.fontSizeMedium,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontSize: AppConstants.fontSizeSmall,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        fontSize: AppConstants.fontSizeCaption,
        color: Colors.grey[600],
      ),
    );
  }
}
