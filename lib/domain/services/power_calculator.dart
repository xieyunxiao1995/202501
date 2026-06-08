import '../entities/general.dart';

/// 战力计算服务
///
/// 提供武将和阵容战力计算逻辑，用于排行榜、阵容推荐等场景。
/// 战力综合考虑属性、稀有度、星级、羁绊和阵法等因素。
class PowerCalculator {
  /// 稀有度系数映射
  ///
  /// 不同稀有度对应不同的战力系数，稀有度越高系数越大。
  static const Map<String, double> _rarityMultiplier = {
    'common': 1.0,
    'rare': 1.2,
    'epic': 1.5,
    'legendary': 2.0,
    'supreme': 2.5,
    'mythic': 3.0,
  };

  /// 星级系数映射
  ///
  /// 不同星级对应不同的战力系数，星级越高系数越大。
  static const Map<int, double> _starMultiplier = {
    1: 1.0,
    2: 1.1,
    3: 1.25,
    4: 1.45,
    5: 1.7,
    6: 2.0,
    7: 2.4,
  };

  /// 计算武将战力
  ///
  /// [general] 武将实体
  ///
  /// 公式：综合属性 * 稀有度系数 * 星级系数
  /// 综合属性 = 攻击力 + 防御力 + 生命值 * 0.5 + 速度 * 2
  /// 觉醒状态额外加成 20%
  double calculateGeneralPower(General general) {
    // 计算综合属性
    final compositeAttr = general.atk +
        general.def +
        general.hp * 0.5 +
        general.spd * 2.0;

    // 获取稀有度系数
    final rarityMult = _rarityMultiplier[general.rarity.name] ?? 1.0;

    // 获取星级系数
    final starMult = _starMultiplier[general.star] ?? 1.0;

    // 觉醒加成
    final awakeBonus = general.isAwakened ? 1.2 : 1.0;

    return compositeAttr * rarityMult * starMult * awakeBonus;
  }

  /// 计算阵容战力
  ///
  /// [generals] 阵容中的武将列表（最多 6 位）
  /// [bondBonus] 羁绊加成比例（如 0.15 表示 +15%）
  /// [formationBonus] 阵法加成比例（如 0.1 表示 +10%）
  ///
  /// 公式：6武将战力之和 * (1 + 羁绊加成) * (1 + 阵法加成)
  double calculateTeamPower(
    List<General> generals, {
    double bondBonus = 0,
    double formationBonus = 0,
  }) {
    // 计算所有武将战力之和
    final totalPower = generals
        .map((g) => calculateGeneralPower(g))
        .fold(0.0, (sum, power) => sum + power);

    // 应用羁绊和阵法加成
    return totalPower * (1 + bondBonus) * (1 + formationBonus);
  }
}
