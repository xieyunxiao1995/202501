import 'package:flutter/material.dart';

/// App-wide constants for 实遇记
/// Following "Forest Breath" design language
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = '实遇记';
  static const String appTagline = 'Glamping Community & Tools';

  // Colors - Forest Breath Theme
  static const Color primaryColor = Color(0xFF1A3C34); // Deep Pine
  static const Color secondaryColor = Color(0xFFF2F0EB); // Warm Stone
  static const Color accentColor = Color(0xFFD97D54); // Ember Orange
  static const Color neutralColor = Color(0xFF333333); // Basalt Grey
  static const Color softGray = Color(0xFFE5E7EB);

  // Spacing System (multiples of 4)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 999.0;

  // Font Sizes
  static const double fontSizeCaption = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeHeading3 = 18.0;
  static const double fontSizeHeading2 = 24.0;
  static const double fontSizeHeading1 = 32.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 32.0;
  static const double iconSizeXXLarge = 48.0;

  // Component Sizes
  static const double bottomNavHeight = 88.0;
  static const double appBarHeight = 56.0;
  static const double fabSize = 56.0;
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 96.0;

  // Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Animation Duration
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get floatShadow => [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  // Categories
  static const List<String> feedCategories = ['精选', '野外生存', '豪华露营'];

  static const List<String> gearCategories = [
    '全部',
    '睡眠',
    '烹饪',
    '照明',
    '服装',
    '工具',
    '急救',
  ];

  // Placeholder Images
  static const String placeholderImageUrl =
      'https://via.placeholder.com/400x300/E5E7EB/94A3B8?text=Image';
}
