import 'package:flutter/material.dart';

class AppColors {
  static const Color bgPaper = Color(0xFFEADDCF);
  static const Color inkBlack = Color(0xFF0A0A0A);
  static const Color inkRed = Color(0xFF8A1C1C);
  static const Color woodDark = Color(0xFF3E2723);
  static const Color woodLight = Color(0xFF5D4037);
  static const Color stoneDark = Color(0xFF1A1A1A);
  static const Color stoneLight = Color(0xFFCCCCCC);
  static const Color gold = Color(0xFFD4AF37);

  static const Color elementMetal = Color(0xFFE0E0E0); // Gold/White
  static const Color elementWood = Color(0xFF4CAF50); // Green
  static const Color elementWater = Color(0xFF2980B9); // Blue
  static const Color elementFire = Color(0xFFC0392B); // Red
  static const Color elementEarth = Color(0xFF795548); // Brown

  static Color getPowerColor(int power) {
    if (power < 20) return Colors.grey;
    if (power < 50) return Colors.green;
    if (power < 100) return Colors.blue;
    if (power < 200) return Colors.purple;
    return inkRed; // Orange/Red for legendary
  }
}

class AppAssets {
  static const String bgAncientStoneCircle = 'assets/bg/Ancient_Stone_Circle.jpeg';
  static const String bgDesertOasisTemple = 'assets/bg/Desert_Oasis_Temple.jpeg';
  static const String bgForbiddenSealA = 'assets/bg/Forbidden_Seal_A.jpeg';
  static const String bgGiantLotusPond = 'assets/bg/Giant_Lotus_Pond.jpeg';
  static const String bgHeavenlyGateA = 'assets/bg/Heavenly_Gate_A.jpeg';
  static const String bgMistyBambooForest = 'assets/bg/Misty_Bamboo_Forest.jpeg';
  static const String bgMoonlitLakeA = 'assets/bg/Moonlit_Lake_A.jpeg';
  static const String bgRedLeafValley = 'assets/bg/Red_Leaf_Valley.jpeg';
  static const String bgSnowyPeakMeditation = 'assets/bg/Snowy_Peak_Meditation.jpeg';
  static const String bgStarryPlateauA = 'assets/bg/Starry_Plateau_A.jpeg';
  static const String bgWaterfallSanctuaryA = 'assets/bg/Waterfall_Sanctuary_A.jpeg';

  static const List<String> allBackgrounds = [
    bgAncientStoneCircle,
    bgDesertOasisTemple,
    bgForbiddenSealA,
    bgGiantLotusPond,
    bgHeavenlyGateA,
    bgMistyBambooForest,
    bgMoonlitLakeA,
    bgRedLeafValley,
    bgSnowyPeakMeditation,
    bgStarryPlateauA,
    bgWaterfallSanctuaryA,
  ];
}

class AppTextStyles {
  // We will use GoogleFonts in the theme, here we define keys or helpers if needed
}
