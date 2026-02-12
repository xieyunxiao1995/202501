enum RewardStatus {
  locked,
  available,
  claimed,
}

enum RewardRarity {
  r,
  sr,
  ssr,
  sp,
}

class DailyReward {
  final int day;
  final String itemName;
  final String assetPath;
  final int count;
  final RewardStatus status;
  final RewardRarity rarity;
  final bool isSpecial; // For 3rd, 5th, 7th day big rewards

  const DailyReward({
    required this.day,
    required this.itemName,
    required this.assetPath,
    required this.count,
    this.status = RewardStatus.locked,
    this.rarity = RewardRarity.r,
    this.isSpecial = false,
  });

  DailyReward copyWith({RewardStatus? status}) {
    return DailyReward(
      day: day,
      itemName: itemName,
      assetPath: assetPath,
      count: count,
      status: status ?? this.status,
      rarity: rarity,
      isSpecial: isSpecial,
    );
  }
}

// Initial mock data
final List<DailyReward> initialDailyRewards = [
  const DailyReward(
    day: 1,
    itemName: '角色碎片',
    assetPath: 'assets/item/Cute_crystal_lotus.png',
    count: 15,
    rarity: RewardRarity.sr,
    status: RewardStatus.available,
  ),
  const DailyReward(
    day: 2,
    itemName: '角色碎片',
    assetPath: 'assets/item/Cute_crystal_lotus.png',
    count: 15,
    rarity: RewardRarity.sr,
  ),
  const DailyReward(
    day: 3,
    itemName: '翡翠玉环',
    assetPath: 'assets/item/Double_Fish_Jade.png',
    count: 50,
    rarity: RewardRarity.r,
  ),
  const DailyReward(
    day: 4,
    itemName: '招魂铃',
    assetPath: 'assets/item/Jade_Spirit_Bottle.png',
    count: 1,
    rarity: RewardRarity.r,
  ),
  const DailyReward(
    day: 5,
    itemName: '角色碎片',
    assetPath: 'assets/item/Cute_crystal_lotus.png',
    count: 15,
    rarity: RewardRarity.sr,
  ),
  const DailyReward(
    day: 6,
    itemName: '角色碎片',
    assetPath: 'assets/item/Cute_crystal_lotus.png',
    count: 15,
    rarity: RewardRarity.sr,
  ),
  const DailyReward(
    day: 7,
    itemName: '翡翠玉环',
    assetPath: 'assets/item/Double_Fish_Jade.png',
    count: 50,
    rarity: RewardRarity.r,
  ),
  const DailyReward(
    day: 8,
    itemName: '招魂铃',
    assetPath: 'assets/item/Jade_Spirit_Bottle.png',
    count: 1,
    rarity: RewardRarity.r,
  ),
  const DailyReward(
    day: 9,
    itemName: '角色碎片',
    assetPath: 'assets/item/Cute_crystal_lotus.png',
    count: 15,
    rarity: RewardRarity.sr,
  ),
  const DailyReward(
    day: 10,
    itemName: '角色碎片',
    assetPath: 'assets/item/Cute_crystal_lotus.png',
    count: 15,
    rarity: RewardRarity.sr,
  ),
  const DailyReward(
    day: 11,
    itemName: '翡翠玉环',
    assetPath: 'assets/item/Double_Fish_Jade.png',
    count: 50,
    rarity: RewardRarity.r,
  ),
  const DailyReward(
    day: 12,
    itemName: '招魂铃',
    assetPath: 'assets/item/Jade_Spirit_Bottle.png',
    count: 1,
    rarity: RewardRarity.r,
  ),
];
