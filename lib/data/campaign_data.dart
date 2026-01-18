import '../models/enums.dart';

class CampaignLevel {
  final int id;
  final String name;
  final String description;
  final String icon;
  final Biome biome;
  final int requiredScore;
  final int maxFloors;
  final List<String> rewards;
  final bool isUnlocked;
  final int stars;

  const CampaignLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.biome,
    required this.requiredScore,
    required this.maxFloors,
    required this.rewards,
    this.isUnlocked = false,
    this.stars = 0,
  });

  CampaignLevel copyWith({
    int? id,
    String? name,
    String? description,
    String? icon,
    Biome? biome,
    int? requiredScore,
    int? maxFloors,
    List<String>? rewards,
    bool? isUnlocked,
    int? stars,
  }) {
    return CampaignLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      biome: biome ?? this.biome,
      requiredScore: requiredScore ?? this.requiredScore,
      maxFloors: maxFloors ?? this.maxFloors,
      rewards: rewards ?? this.rewards,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      stars: stars ?? this.stars,
    );
  }
}

const List<CampaignLevel> campaignLevels = [
  CampaignLevel(
    id: 1,
    name: "青丘秘境",
    description: "九尾狐的故乡，灵草遍地，妖兽潜伏",
    icon: "🌲",
    biome: Biome.forest,
    requiredScore: 0,
    maxFloors: 10,
    rewards: ["100 灵石", "解锁第2关"],
    isUnlocked: true,
  ),
  CampaignLevel(
    id: 2,
    name: "不周山麓",
    description: "上古神山脚下，天柱折断之处",
    icon: "⛰️",
    biome: Biome.forest,
    requiredScore: 500,
    maxFloors: 15,
    rewards: ["200 灵石", "千年灵草 x3", "解锁第3关"],
  ),
  CampaignLevel(
    id: 3,
    name: "烈焰深渊",
    description: "地火涌动之地，毕方鸟的巢穴",
    icon: "🔥",
    biome: Biome.volcano,
    requiredScore: 1000,
    maxFloors: 20,
    rewards: ["300 灵石", "地心火莲 x2", "解锁第4关"],
  ),
  CampaignLevel(
    id: 4,
    name: "赤水之滨",
    description: "赤水河畔，水妖横行之地",
    icon: "🌊",
    biome: Biome.ocean,
    requiredScore: 2000,
    maxFloors: 25,
    rewards: ["500 灵石", "天一真水 x3", "解锁第5关"],
  ),
  CampaignLevel(
    id: 5,
    name: "弱水三千",
    description: "鸿毛不浮的弱水，凶险异常",
    icon: "💧",
    biome: Biome.ocean,
    requiredScore: 3000,
    maxFloors: 30,
    rewards: ["800 灵石", "月光石 x2", "解锁第6关"],
  ),
  CampaignLevel(
    id: 6,
    name: "昆仑虚境",
    description: "万山之祖，神仙居所",
    icon: "🏔️",
    biome: Biome.volcano,
    requiredScore: 5000,
    maxFloors: 35,
    rewards: ["1000 灵石", "赤血晶石 x2", "解锁第7关"],
  ),
  CampaignLevel(
    id: 7,
    name: "归墟之眼",
    description: "万水归处，时空扭曲的禁地",
    icon: "🌀",
    biome: Biome.void_,
    requiredScore: 8000,
    maxFloors: 40,
    rewards: ["1500 灵石", "真龙逆鳞 x1", "解锁第8关"],
  ),
  CampaignLevel(
    id: 8,
    name: "混沌虚空",
    description: "宇宙初开之地，混沌四凶出没",
    icon: "⚫",
    biome: Biome.void_,
    requiredScore: 12000,
    maxFloors: 50,
    rewards: ["3000 灵石", "混沌尘埃 x1", "混沌赐福"],
  ),
];
