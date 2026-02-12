
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MapConfig {
  final String id;
  final String name;
  final String description;
  final int difficulty; // 1-5
  final int width;
  final int height;
  final Color themeColor;
  final List<String> possibleEvents; // 'Corpse', 'Water', etc.

  const MapConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    this.width = 5,
    this.height = 7,
    required this.themeColor,
    this.possibleEvents = const ['林', '尸', '水', '泉'],
  });
}

class GameMaps {
  static const MapConfig southMountain = MapConfig(
    id: 'south_mountain',
    name: '南山经',
    description: '多招摇之山，临于西海之上，多桂，多金玉。',
    difficulty: 1,
    themeColor: AppColors.woodLight,
    possibleEvents: ['林', '尸', '水', '泉', '矿'],
  );

  static const MapConfig westMountain = MapConfig(
    id: 'west_mountain',
    name: '西山经',
    description: '华山之首，曰钱来之山，其上多松，其下多洗石。',
    difficulty: 2,
    themeColor: AppColors.stoneDark,
    possibleEvents: ['山', '兽', '雪', '墓'],
  );

  static const MapConfig northSea = MapConfig(
    id: 'north_sea',
    name: '北海内',
    description: '北海之内，有山，名曰幽都之山，黑水出焉。',
    difficulty: 3,
    themeColor: AppColors.elementWater,
    possibleEvents: ['海', '漩', '岛', '妖'],
  );

  static const MapConfig eastMountain = MapConfig(
    id: 'east_mountain',
    name: '东山经',
    description: '东山之首，曰樕之山，北临乾昧。',
    difficulty: 4,
    themeColor: AppColors.inkRed,
    possibleEvents: ['雷', '龙', '云', '峰'],
  );

  static const MapConfig centralPlains = MapConfig(
    id: 'central_plains',
    name: '中次七经',
    description: '中次七经苦山之首，曰休与之山。',
    difficulty: 5,
    themeColor: AppColors.gold,
    possibleEvents: ['魔', '墟', '塔', '祭'],
  );

  // New Maps
  static const MapConfig overseasSouth = MapConfig(
    id: 'overseas_south',
    name: '海外南经',
    description: '结胸国、羽民国所在，充满异域风情。',
    difficulty: 2,
    themeColor: AppColors.woodLight,
    possibleEvents: ['林', '羽', '结', '异'],
  );

  static const MapConfig overseasWest = MapConfig(
    id: 'overseas_west',
    name: '海外西经',
    description: '灭蒙鸟、三身国之地，神秘莫测。',
    difficulty: 3,
    themeColor: AppColors.stoneDark,
    possibleEvents: ['鸟', '三', '身', '迷'],
  );

  static const MapConfig overseasNorth = MapConfig(
    id: 'overseas_north',
    name: '海外北经',
    description: '无启国、一目国，荒诞离奇。',
    difficulty: 3,
    themeColor: AppColors.elementWater,
    possibleEvents: ['眼', '死', '生', '寒'],
  );

  static const MapConfig overseasEast = MapConfig(
    id: 'overseas_east',
    name: '海外东经',
    description: '大人国、君子国，礼仪之邦与巨人之地。',
    difficulty: 2,
    themeColor: AppColors.woodDark,
    possibleEvents: ['人', '礼', '巨', '市'],
  );

  static const MapConfig wildernessSouth = MapConfig(
    id: 'wilderness_south',
    name: '大荒南经',
    description: '巫山、三青鸟，神灵出没。',
    difficulty: 4,
    themeColor: AppColors.inkRed,
    possibleEvents: ['巫', '鸟', '灵', '祭'],
  );

  static const MapConfig wildernessWest = MapConfig(
    id: 'wilderness_west',
    name: '大荒西经',
    description: '女瓦之肠、西王母，古老传说。',
    difficulty: 5,
    themeColor: AppColors.gold,
    possibleEvents: ['神', '母', '古', '迹'],
  );

  static const MapConfig wildernessNorth = MapConfig(
    id: 'wilderness_north',
    name: '大荒北经',
    description: '附禺之山、烛龙，极寒之地。',
    difficulty: 5,
    themeColor: AppColors.elementWater,
    possibleEvents: ['龙', '冰', '暗', '光'],
  );

  static const MapConfig wildernessEast = MapConfig(
    id: 'wilderness_east',
    name: '大荒东经',
    description: '汤谷、扶桑，日出之所。',
    difficulty: 4,
    themeColor: AppColors.elementFire,
    possibleEvents: ['日', '木', '火', '谷'],
  );

  static const MapConfig domesticSouth = MapConfig(
    id: 'domestic_south',
    name: '海内南经',
    description: '巴蛇、流沙，险恶之地。',
    difficulty: 3,
    themeColor: AppColors.elementEarth,
    possibleEvents: ['蛇', '沙', '毒', '陷'],
  );

  static const MapConfig domesticWest = MapConfig(
    id: 'domestic_west',
    name: '海内西经',
    description: '昆仑之虚，万神之乡。',
    difficulty: 5,
    themeColor: AppColors.gold,
    possibleEvents: ['仙', '云', '玉', '兽'],
  );

  static const MapConfig domesticNorth = MapConfig(
    id: 'domestic_north',
    name: '海内北经',
    description: '蓬莱山、据比之尸，仙境与死亡并存。',
    difficulty: 4,
    themeColor: AppColors.stoneLight,
    possibleEvents: ['仙', '尸', '岛', '雾'],
  );

  static const MapConfig domesticEast = MapConfig(
    id: 'domestic_east',
    name: '海内东经',
    description: '雷泽、华胥，雷神栖息。',
    difficulty: 4,
    themeColor: AppColors.elementWood,
    possibleEvents: ['雷', '泽', '神', '迹'],
  );

  static const MapConfig centralMountain = MapConfig(
    id: 'central_mountain',
    name: '中山经',
    description: '众多名山，灵气充裕。',
    difficulty: 2,
    themeColor: AppColors.woodLight,
    possibleEvents: ['山', '灵', '草', '药'],
  );

  static const MapConfig northMountain = MapConfig(
    id: 'north_mountain',
    name: '北山经',
    description: '狱法之山，多怪兽。',
    difficulty: 3,
    themeColor: AppColors.stoneDark,
    possibleEvents: ['兽', '狱', '怪', '险'],
  );

  static const MapConfig southSecond = MapConfig(
    id: 'south_second',
    name: '南次二经',
    description: '柜山、长右，多水多玉。',
    difficulty: 2,
    themeColor: AppColors.elementWater,
    possibleEvents: ['水', '玉', '猴', '流'],
  );

  static const MapConfig westThird = MapConfig(
    id: 'west_third',
    name: '西次三经',
    description: '崇吾之山，蛮荒之地。',
    difficulty: 3,
    themeColor: AppColors.elementEarth,
    possibleEvents: ['蛮', '荒', '兽', '石'],
  );

  static const MapConfig northThird = MapConfig(
    id: 'north_third',
    name: '北次三经',
    description: '錞于毋逢之山，大风起兮。',
    difficulty: 4,
    themeColor: AppColors.elementMetal,
    possibleEvents: ['风', '山', '云', '变'],
  );

  static const MapConfig eastFourth = MapConfig(
    id: 'east_fourth',
    name: '东次四经',
    description: '北号之山，多狼多狐。',
    difficulty: 3,
    themeColor: AppColors.woodDark,
    possibleEvents: ['狼', '狐', '林', '夜'],
  );

  static const MapConfig centralTwelfth = MapConfig(
    id: 'central_twelfth',
    name: '中次十二经',
    description: '洞庭之山，帝之二女居之。',
    difficulty: 4,
    themeColor: AppColors.elementWater,
    possibleEvents: ['湖', '女', '神', '雾'],
  );

  static const MapConfig buzhouMountain = MapConfig(
    id: 'buzhou_mountain',
    name: '不周山',
    description: '支撑天地的神山，终极挑战。',
    difficulty: 5,
    themeColor: AppColors.inkBlack,
    possibleEvents: ['神', '天', '塌', '终'],
  );
  
  static const List<MapConfig> all = [
    southMountain, 
    westMountain, 
    northSea, 
    eastMountain, 
    centralPlains,
    overseasSouth,
    overseasWest,
    overseasNorth,
    overseasEast,
    wildernessSouth,
    wildernessWest,
    wildernessNorth,
    wildernessEast,
    domesticSouth,
    domesticWest,
    domesticNorth,
    domesticEast,
    centralMountain,
    northMountain,
    southSecond,
    westThird,
    northThird,
    eastFourth,
    centralTwelfth,
    buzhouMountain,
  ];
}
