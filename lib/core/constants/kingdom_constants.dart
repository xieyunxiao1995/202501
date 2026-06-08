import 'dart:ui';

/// 三国阵营常量
///
/// 定义魏、蜀、吴、群、晋、女将等阵营的标识、名称、颜色等信息。
class KingdomConstants {
  KingdomConstants._();

  // ==================== 阵营标识 ====================

  /// 魏国
  static const String kingdomWei = 'wei';

  /// 蜀国
  static const String kingdomShu = 'shu';

  /// 吴国
  static const String kingdomWu = 'wu';

  /// 群雄
  static const String kingdomQun = 'qun';

  /// 晋国
  static const String kingdomJin = 'jin';

  /// 女将
  static const String kingdomFemale = 'female';

  /// 所有阵营标识列表
  static const List<String> allKingdoms = [
    kingdomWei,
    kingdomShu,
    kingdomWu,
    kingdomQun,
    kingdomJin,
    kingdomFemale,
  ];

  // ==================== 阵营名称 ====================

  /// 魏国名称
  static const String nameWei = '魏';

  /// 蜀国名称
  static const String nameShu = '蜀';

  /// 吴国名称
  static const String nameWu = '吴';

  /// 群雄名称
  static const String nameQun = '群';

  /// 晋国名称
  static const String nameJin = '晋';

  /// 女将名称
  static const String nameFemale = '女将';

  /// 阵营标识对应的名称映射
  static const Map<String, String> kingdomNames = {
    kingdomWei: nameWei,
    kingdomShu: nameShu,
    kingdomWu: nameWu,
    kingdomQun: nameQun,
    kingdomJin: nameJin,
    kingdomFemale: nameFemale,
  };

  // ==================== 阵营颜色 ====================

  /// 魏国颜色（蓝色 #1565C0）
  static const Color colorWei = Color(0xFF1565C0);

  /// 蜀国颜色（红色 #C62828）
  static const Color colorShu = Color(0xFFC62828);

  /// 吴国颜色（绿色 #2E7D32）
  static const Color colorWu = Color(0xFF2E7D32);

  /// 群雄颜色（紫色 #6A1B9A）
  static const Color colorQun = Color(0xFF6A1B9A);

  /// 晋国颜色（青灰色 #37474F）
  static const Color colorJin = Color(0xFF37474F);

  /// 女将颜色（粉红色 #AD1457）
  static const Color colorFemale = Color(0xFFAD1457);

  /// 阵营标识对应的颜色映射
  static const Map<String, Color> kingdomColors = {
    kingdomWei: colorWei,
    kingdomShu: colorShu,
    kingdomWu: colorWu,
    kingdomQun: colorQun,
    kingdomJin: colorJin,
    kingdomFemale: colorFemale,
  };

  // ==================== 阵营图标资源路径 ====================

  /// 魏国图标
  static const String iconWei = 'assets/images/ui/kingdom_wei.png';

  /// 蜀国图标
  static const String iconShu = 'assets/images/ui/kingdom_shu.png';

  /// 吴国图标
  static const String iconWu = 'assets/images/ui/kingdom_wu.png';

  /// 群雄图标
  static const String iconQun = 'assets/images/ui/kingdom_qun.png';

  /// 晋国图标
  static const String iconJin = 'assets/images/ui/kingdom_jin.png';

  /// 女将图标
  static const String iconFemale = 'assets/images/ui/kingdom_female.png';

  /// 阵营标识对应的图标路径映射
  static const Map<String, String> kingdomIcons = {
    kingdomWei: iconWei,
    kingdomShu: iconShu,
    kingdomWu: iconWu,
    kingdomQun: iconQun,
    kingdomJin: iconJin,
    kingdomFemale: iconFemale,
  };

  // ==================== 国战阵营对应关系 ====================

  /// 国战中可选的阵营（不含女将和晋国，国战为三国争霸）
  static const List<String> nationalWarKingdoms = [
    kingdomWei,
    kingdomShu,
    kingdomWu,
  ];

  // ==================== 阵营特色 ====================

  /// 魏国特色：防御加成
  static const double weiDefenseBonus = 0.1;

  /// 蜀国特色：攻击加成
  static const double shuAttackBonus = 0.1;

  /// 吴国特色：谋略加成
  static const double wuStrategyBonus = 0.1;

  /// 群雄特色：无阵营加成，但武将技能更多样
  static const double qunNoBonus = 0.0;

  /// 晋国特色：统帅加成
  static const double jinCommandBonus = 0.1;

  /// 女将特色：魅力加成（影响招募概率）
  static const double femaleCharismaBonus = 0.1;

  /// 阵营标识对应的特色加成类型
  static const Map<String, String> kingdomBonusTypes = {
    kingdomWei: '防御',
    kingdomShu: '攻击',
    kingdomWu: '谋略',
    kingdomQun: '多样',
    kingdomJin: '统帅',
    kingdomFemale: '魅力',
  };

  /// 同阵营武将上阵加成比例
  static const double sameKingdomBonus = 0.15;

  /// 同阵营上阵最少武将数（触发加成）
  static const int sameKingdomMinCount = 2;

  // ==================== 工具方法 ====================

  /// 获取阵营名称
  static String getName(String kingdom) {
    return kingdomNames[kingdom] ?? '未知';
  }

  /// 获取阵营颜色
  static Color getColor(String kingdom) {
    return kingdomColors[kingdom] ?? const Color(0xFF9E9E9E);
  }

  /// 获取阵营图标路径
  static String getIcon(String kingdom) {
    return kingdomIcons[kingdom] ?? '';
  }

  /// 获取阵营特色类型描述
  static String getBonusType(String kingdom) {
    return kingdomBonusTypes[kingdom] ?? '无';
  }

  /// 判断是否为国战可选阵营
  static bool isNationalWarKingdom(String kingdom) {
    return nationalWarKingdoms.contains(kingdom);
  }
}
