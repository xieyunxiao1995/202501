import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late MediaQueryData _mediaQuery;
  static late double screenWidth;
  static late double screenHeight;
  static late double safeAreaTop;
  static late double safeAreaBottom;
  static late bool isSmallScreen;
  static late bool isMediumScreen;
  static late bool isLargeScreen;

  static void init(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    screenWidth = _mediaQuery.size.width;
    screenHeight = _mediaQuery.size.height;
    safeAreaTop = _mediaQuery.padding.top;
    safeAreaBottom = _mediaQuery.padding.bottom;
    isSmallScreen = screenHeight < 700;
    isMediumScreen = screenHeight >= 700 && screenHeight < 900;
    isLargeScreen = screenHeight >= 900;
  }

  static double getScaleFactor(BuildContext context) {
    init(context);
    final height = screenHeight;
    if (height < 700) {
      return 0.85;
    } else if (height < 800) {
      return 0.92;
    } else if (height < 900) {
      return 0.97;
    }
    return 1.0;
  }

  static double responsivePadding(BuildContext context) {
    init(context);
    if (isSmallScreen) return 16;
    return 24;
  }

  static double responsiveSpacing(BuildContext context, {double base = 24}) {
    init(context);
    if (isSmallScreen) return base * 0.75;
    if (isMediumScreen) return base * 0.9;
    return base;
  }

  static double responsiveFontSize(BuildContext context, double baseSize) {
    init(context);
    if (isSmallScreen) return baseSize * 0.85;
    if (isMediumScreen) return baseSize * 0.92;
    return baseSize;
  }

  static double responsiveIconSize(BuildContext context, double baseSize) {
    init(context);
    if (isSmallScreen) return baseSize * 0.85;
    if (isMediumScreen) return baseSize * 0.92;
    return baseSize;
  }

  static double responsiveHeight(BuildContext context, double baseHeight) {
    init(context);
    if (isSmallScreen) return baseHeight * 0.8;
    if (isMediumScreen) return baseHeight * 0.9;
    return baseHeight;
  }

  static double responsiveWidth(BuildContext context, double baseWidth) {
    init(context);
    if (isSmallScreen) return baseWidth * 0.85;
    if (isMediumScreen) return baseWidth * 0.92;
    return baseWidth;
  }

  static EdgeInsets responsiveEdgeInsets(
    BuildContext context, {
    double all = 24,
    double top = -1,
    double bottom = -1,
    double left = -1,
    double right = -1,
  }) {
    init(context);
    final factor = isSmallScreen ? 0.75 : (isMediumScreen ? 0.9 : 1.0);
    return EdgeInsets.only(
      top: top >= 0 ? top * factor : all * factor,
      bottom: bottom >= 0 ? bottom * factor : all * factor,
      left: left >= 0 ? left * factor : all * factor,
      right: right >= 0 ? right * factor : all * factor,
    );
  }
}
