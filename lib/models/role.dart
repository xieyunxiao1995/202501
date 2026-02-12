
import 'package:flutter/material.dart';

enum RoleRarity {
  r,
  sr,
  ssr,
  ur
}

enum RoleElement {
  metal, // 金
  wood, // 木
  water, // 水
  fire, // 火
  earth, // 土
  wind, // 风
  thunder, // 雷
  yin, // 阴
  yang, // 阳
}

class Role {
  final String id;
  final String name;
  final String title;
  final String assetPath;
  final RoleElement element;
  final RoleRarity rarity;
  final int stars;
  final String description;

  const Role({
    required this.id,
    required this.name,
    required this.title,
    required this.assetPath,
    required this.element,
    required this.rarity,
    required this.stars,
    required this.description,
  });

  Color get elementColor {
    switch (element) {
      case RoleElement.metal:
        return const Color(0xFFE0E0E0); // Silver/Grey
      case RoleElement.wood:
        return const Color(0xFF4CAF50); // Green
      case RoleElement.water:
        return const Color(0xFF2196F3); // Blue
      case RoleElement.fire:
        return const Color(0xFFF44336); // Red
      case RoleElement.earth:
        return const Color(0xFF795548); // Brown
      case RoleElement.wind:
        return const Color(0xFF00BCD4); // Cyan
      case RoleElement.thunder:
        return const Color(0xFF9C27B0); // Purple
      case RoleElement.yin:
        return const Color(0xFF607D8B); // Blue Grey
      case RoleElement.yang:
        return const Color(0xFFFFC107); // Amber
    }
  }
  
  String get rarityLabel {
    return rarity.name.toUpperCase();
  }
}

final List<Role> allRoles = [
  const Role(
    id: 'monkey_king',
    name: '齐天大圣',
    title: '斗战胜佛',
    assetPath: 'assets/role/Monkey_King_3D.png',
    element: RoleElement.fire,
    rarity: RoleRarity.ur,
    stars: 5,
    description: '身穿金甲亮堂堂，头戴金冠光映映。手举金箍棒一根，足踏云鞋皆相称。一双怪眼似明星，两耳过肩查又硬。挺挺身才变化多，声音响亮如钟磬。',
  ),
  const Role(
    id: 'nezha',
    name: '哪吒',
    title: '三太子',
    assetPath: 'assets/role/Nezha_Lotus_Boy.png',
    element: RoleElement.fire,
    rarity: RoleRarity.ssr,
    stars: 5,
    description: '头戴乾坤圈，臂绕混天绫，脚踏风火轮，手持火尖枪。莲花化身，三头六臂，威风凛凛。',
  ),
  const Role(
    id: 'nuwa',
    name: '女娲',
    title: '大地之母',
    assetPath: 'assets/role/Nuwa_Snake_Goddess.png',
    element: RoleElement.earth,
    rarity: RoleRarity.ur,
    stars: 5,
    description: '人首蛇身，抟土造人，炼石补天。大地之母，万物之灵。',
  ),
  const Role(
    id: 'nine_tailed_fox',
    name: '九尾狐',
    title: '青丘国主',
    assetPath: 'assets/role/Nine-Tailed_Fox_3D.png',
    element: RoleElement.yin,
    rarity: RoleRarity.ssr,
    stars: 4,
    description: '青丘之山，有兽焉，其状如狐而九尾，其音如婴儿，能食人，食者不蛊。',
  ),
  const Role(
    id: 'white_dragon_girl',
    name: '白龙女',
    title: '龙宫公主',
    assetPath: 'assets/role/White_Dragon_Girl.png',
    element: RoleElement.water,
    rarity: RoleRarity.ssr,
    stars: 4,
    description: '西海龙王三公主，化作白衣秀士，温婉可人，法力高强。',
  ),
  const Role(
    id: 'blue_dragon_prince',
    name: '敖丙',
    title: '东海龙太子',
    assetPath: 'assets/role/Blue_Dragon_Prince.png',
    element: RoleElement.water,
    rarity: RoleRarity.ssr,
    stars: 4,
    description: '东海龙王三太子，身披银甲，手持方天画戟，英姿飒爽。',
  ),
  const Role(
    id: 'phoenix_goddess',
    name: '凤凰神女',
    title: '百鸟之王',
    assetPath: 'assets/role/Phoenix_Goddess_3D.png',
    element: RoleElement.fire,
    rarity: RoleRarity.ur,
    stars: 5,
    description: '凤凰涅槃，浴火重生。百鸟朝凤，神威浩荡。',
  ),
  const Role(
    id: 'demon_lord',
    name: '魔尊',
    title: '万魔之主',
    assetPath: 'assets/role/Demon_Lord_3D.png',
    element: RoleElement.yin,
    rarity: RoleRarity.ur,
    stars: 5,
    description: '统领魔界，法力无边。性格孤傲，唯我独尊。',
  ),
  const Role(
    id: 'ox_demon',
    name: '牛魔王',
    title: '平天大圣',
    assetPath: 'assets/role/Ox_Demon_3D.png',
    element: RoleElement.earth,
    rarity: RoleRarity.ssr,
    stars: 4,
    description: '大力王，七大圣之首。力大无穷，神通广大。',
  ),
  const Role(
    id: 'golden_dragon_general',
    name: '金龙将军',
    title: '天庭战神',
    assetPath: 'assets/role/Golden_Dragon_General.png',
    element: RoleElement.metal,
    rarity: RoleRarity.ssr,
    stars: 4,
    description: '身披金甲，手持金枪，威风凛凛，镇守天门。',
  ),
  const Role(
    id: 'moon_archer',
    name: '月影',
    title: '广寒射手',
    assetPath: 'assets/role/Moon_Archer_3D.png',
    element: RoleElement.yin,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '广寒宫中的神射手，箭术超群，百发百中。',
  ),
  const Role(
    id: 'sun_deity',
    name: '东君',
    title: '太阳神',
    assetPath: 'assets/role/Sun_Deity_3D.png',
    element: RoleElement.yang,
    rarity: RoleRarity.ssr,
    stars: 5,
    description: '日出东方，光耀万物。主宰太阳运行的神祇。',
  ),
  const Role(
    id: 'thunder_bird',
    name: '雷震子',
    title: '雷部正神',
    assetPath: 'assets/role/Thunder_Bird_3D.png',
    element: RoleElement.thunder,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '背生双翅，面如蓝靛，发似朱砂，巨口獠牙，眼似铜铃。',
  ),
  const Role(
    id: 'bamboo_swordsman',
    name: '竹林剑客',
    title: '隐世剑仙',
    assetPath: 'assets/role/Bamboo_Swordman_3D.png',
    element: RoleElement.wood,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '隐居竹林，以竹为剑，剑气纵横，潇洒飘逸。',
  ),
  const Role(
    id: 'lotus_princess',
    name: '莲花公主',
    title: '芙蓉仙子',
    assetPath: 'assets/role/Lotus_Princess_3D.png',
    element: RoleElement.wood,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '出淤泥而不染，濯清涟而不妖。',
  ),
  const Role(
    id: 'ice_crystal_fairy',
    name: '冰晶仙子',
    title: '雪山神女',
    assetPath: 'assets/role/Ice_Crystal_Fairy.png',
    element: RoleElement.water,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '居住在极寒之地的仙子，掌控冰雪之力。',
  ),
  const Role(
    id: 'taoist_master',
    name: '清虚道长',
    title: '得道高人',
    assetPath: 'assets/role/Taoist_Master_3D.png',
    element: RoleElement.yang,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '精通阴阳五行，擅长符箓咒语，斩妖除魔。',
  ),
  const Role(
    id: 'panda_monk',
    name: '熊猫武僧',
    title: '功夫大师',
    assetPath: 'assets/role/Panda_Monk_3D.png',
    element: RoleElement.earth,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '憨态可掬，武艺高强。喜爱竹子和烈酒。',
  ),
  const Role(
    id: 'ghost_bride',
    name: '冥婚新娘',
    title: '幽冥使者',
    assetPath: 'assets/role/Ghost_Bride_3D.png',
    element: RoleElement.yin,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '身穿红嫁衣，面容凄美，执念深重。',
  ),
  const Role(
    id: 'mist_dragon',
    name: '云雾龙',
    title: '云中君',
    assetPath: 'assets/role/Mist_Dragon_3D.png',
    element: RoleElement.wind,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '腾云驾雾，见首不见尾。',
  ),
  const Role(
    id: 'peacock_dancer',
    name: '孔雀舞者',
    title: '彩翎仙子',
    assetPath: 'assets/role/Peacock_Dancer_3D.png',
    element: RoleElement.wood,
    rarity: RoleRarity.r,
    stars: 2,
    description: '舞姿优美，如孔雀开屏，绚丽多彩。',
  ),
  const Role(
    id: 'raven_assassin',
    name: '渡鸦',
    title: '暗夜刺客',
    assetPath: 'assets/role/Raven_Assassin_3D.png',
    element: RoleElement.wind,
    rarity: RoleRarity.r,
    stars: 2,
    description: '行动敏捷，神出鬼没，如黑夜中的幽灵。',
  ),
  const Role(
    id: 'blue_jay_archer',
    name: '蓝羽',
    title: '丛林射手',
    assetPath: 'assets/role/Blue_Jay_Archer.png',
    element: RoleElement.wood,
    rarity: RoleRarity.r,
    stars: 2,
    description: '百步穿杨，箭无虚发。',
  ),
  const Role(
    id: 'crane_scholar',
    name: '鹤羽',
    title: '白衣秀士',
    assetPath: 'assets/role/Crane_Scholar_3D.png',
    element: RoleElement.metal,
    rarity: RoleRarity.r,
    stars: 2,
    description: '温文尔雅，博学多才。',
  ),
  const Role(
    id: 'cactus_boy',
    name: '仙人球',
    title: '沙漠行者',
    assetPath: 'assets/role/Cactus_Boy_3D.png',
    element: RoleElement.wood,
    rarity: RoleRarity.r,
    stars: 1,
    description: '虽然浑身是刺，但内心柔软。',
  ),
  const Role(
    id: 'fire_elemental',
    name: '火灵',
    title: '火焰精灵',
    assetPath: 'assets/role/Fire_Elemental_3D.png',
    element: RoleElement.fire,
    rarity: RoleRarity.r,
    stars: 1,
    description: '火焰化成的精灵，活泼好动。',
  ),
  const Role(
    id: 'crystal_golem',
    name: '晶石怪',
    title: '矿山守卫',
    assetPath: 'assets/role/Crystal_Golem_3D.png',
    element: RoleElement.earth,
    rarity: RoleRarity.r,
    stars: 2,
    description: '身体坚硬如铁，力大无穷。',
  ),
  const Role(
    id: 'river_spirit',
    name: '河灵',
    title: '水中小妖',
    assetPath: 'assets/role/River_Spirit_3D.png',
    element: RoleElement.water,
    rarity: RoleRarity.r,
    stars: 1,
    description: '生活在河流中的小妖怪，调皮捣蛋。',
  ),
  const Role(
    id: 'tree_guardian',
    name: '树精',
    title: '森林守卫',
    assetPath: 'assets/role/Tree_Guardian_3D.png',
    element: RoleElement.wood,
    rarity: RoleRarity.r,
    stars: 2,
    description: '古树化成，守护着森林的安宁。',
  ),
  const Role(
    id: 'shark_knight',
    name: '鲛人',
    title: '深海骑士',
    assetPath: 'assets/role/Shark_Knight_3D.png',
    element: RoleElement.water,
    rarity: RoleRarity.sr,
    stars: 3,
    description: '人身鱼尾，骁勇善战。',
  ),
  const Role(
    id: 'sea_serpent_warrior',
    name: '海蛇',
    title: '深渊战士',
    assetPath: 'assets/role/Sea_Serpent_Warrior.png',
    element: RoleElement.water,
    rarity: RoleRarity.r,
    stars: 2,
    description: '潜伏在深海中的捕猎者。',
  ),
];
