import 'dart:ui';

/// 稀有度常量
///
/// 定义武将/装备的稀有度等级、对应颜色、权重和升级消耗等。
class RarityConstants {
  RarityConstants._();

  // ==================== 稀有度等级 ====================

  /// N 级（普通）
  static const String rarityN = 'N';

  /// R 级（稀有）
  static const String rarityR = 'R';

  /// SR 级（超稀有）
  static const String raritySR = 'SR';

  /// SSR 级（超超稀有）
  static const String raritySSR = 'SSR';

  /// UR 级（终极稀有）
  static const String rarityUR = 'UR';

  /// 传说级
  static const String rarityLegend = 'LEGEND';

  /// 所有稀有度等级（从低到高）
  static const List<String> allRarities = [
    rarityN,
    rarityR,
    raritySR,
    raritySSR,
    rarityUR,
    rarityLegend,
  ];

  // ==================== 稀有度颜色 ====================

  /// N 级颜色（灰色）
  static const Color colorN = Color(0xFF9E9E9E);

  /// R 级颜色（绿色）
  static const Color colorR = Color(0xFF4CAF50);

  /// SR 级颜色（蓝色）
  static const Color colorSR = Color(0xFF2196F3);

  /// SSR 级颜色（紫色）
  static const Color colorSSR = Color(0xFF9C27B0);

  /// UR 级颜色（橙色）
  static const Color colorUR = Color(0xFFFF9800);

  /// 传说级颜色（红色/金色渐变基准色）
  static const Color colorLegend = Color(0xFFFFD700);

  /// 稀有度对应的颜色映射
  static const Map<String, Color> rarityColors = {
    rarityN: colorN,
    rarityR: colorR,
    raritySR: colorSR,
    raritySSR: colorSSR,
    rarityUR: colorUR,
    rarityLegend: colorLegend,
  };

  // ==================== 抽卡权重 ====================

  /// N 级抽卡权重
  static const int weightN = 400;

  /// R 级抽卡权重
  static const int weightR = 350;

  /// SR 级抽卡权重
  static const int weightSR = 180;

  /// SSR 级抽卡权重
  static const int weightSSR = 55;

  /// UR 级抽卡权重
  static const int weightUR = 12;

  /// 传说级抽卡权重
  static const int weightLegend = 3;

  /// 抽卡权重总和
  static const int totalWeight =
      weightN + weightR + weightSR + weightSSR + weightUR + weightLegend;

  /// 稀有度对应的抽卡权重映射
  static const Map<String, int> rarityWeights = {
    rarityN: weightN,
    rarityR: weightR,
    raritySR: weightSR,
    raritySSR: weightSSR,
    rarityUR: weightUR,
    rarityLegend: weightLegend,
  };

  // ==================== 概率（百分比） ====================

  /// 稀有度对应的概率百分比映射
  static Map<String, double> get rarityProbabilities => {
        rarityN: (weightN / totalWeight) * 100,
        rarityR: (weightR / totalWeight) * 100,
        raritySR: (weightSR / totalWeight) * 100,
        raritySSR: (weightSSR / totalWeight) * 100,
        rarityUR: (weightUR / totalWeight) * 100,
        rarityLegend: (weightLegend / totalWeight) * 100,
      };

  // ==================== 升级消耗 ====================

  /// N 级升星消耗（通用货币）
  static const int upgradeCostN = 100;

  /// R 级升星消耗
  static const int upgradeCostR = 300;

  /// SR 级升星消耗
  static const int upgradeCostSR = 800;

  /// SSR 级升星消耗
  static const int upgradeCostSSR = 2000;

  /// UR 级升星消耗
  static const int upgradeCostUR = 5000;

  /// 传说级升星消耗
  static const int upgradeCostLegend = 10000;

  /// 稀有度对应的升星消耗映射
  static const Map<String, int> upgradeCosts = {
    rarityN: upgradeCostN,
    rarityR: upgradeCostR,
    raritySR: upgradeCostSR,
    raritySSR: upgradeCostSSR,
    rarityUR: upgradeCostUR,
    rarityLegend: upgradeCostLegend,
  };

  // ==================== 最大等级 ====================

  /// N 级最大等级
  static const int maxLevelN = 20;

  /// R 级最大等级
  static const int maxLevelR = 30;

  /// SR 级最大等级
  static const int maxLevelSR = 40;

  /// SSR 级最大等级
  static const int maxLevelSSR = 50;

  /// UR 级最大等级
  static const int maxLevelUR = 60;

  /// 传说级最大等级
  static const int maxLevelLegend = 80;

  /// 稀有度对应的最大等级映射
  static const Map<String, int> maxLevels = {
    rarityN: maxLevelN,
    rarityR: maxLevelR,
    raritySR: maxLevelSR,
    raritySSR: maxLevelSSR,
    rarityUR: maxLevelUR,
    rarityLegend: maxLevelLegend,
  };

  // ==================== 基础属性倍率 ====================

  /// 稀有度对应的基础属性倍率（相对于 N 级为 1.0）
  static const Map<String, double> baseStatMultipliers = {
    rarityN: 1.0,
    rarityR: 1.3,
    raritySR: 1.7,
    raritySSR: 2.2,
    rarityUR: 3.0,
    rarityLegend: 4.0,
  };

  // ==================== 分解获得 ====================

  /// 稀有度对应的分解碎片数量
  static const Map<String, int> decomposeFragments = {
    rarityN: 1,
    rarityR: 5,
    raritySR: 20,
    raritySSR: 80,
    rarityUR: 200,
    rarityLegend: 500,
  };

  /// 获取稀有度对应的颜色
  static Color getColor(String rarity) {
    return rarityColors[rarity] ?? colorN;
  }

  /// 获取稀有度对应的升星消耗
  static int getUpgradeCost(String rarity) {
    return upgradeCosts[rarity] ?? upgradeCostN;
  }

  /// 获取稀有度对应的最大等级
  static int getMaxLevel(String rarity) {
    return maxLevels[rarity] ?? maxLevelN;
  }

  /// 获取稀有度对应的基础属性倍率
  static double getBaseStatMultiplier(String rarity) {
    return baseStatMultipliers[rarity] ?? 1.0;
  }

  /// 获取稀有度对应的分解碎片数量
  static int getDecomposeFragments(String rarity) {
    return decomposeFragments[rarity] ?? 1;
  }
}
