class ResetIndependentBorderObserver {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;
  final String? gender;

  const ResetIndependentBorderObserver({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
    this.gender,
  });
}

const List<ResetIndependentBorderObserver> shopInventory = <ResetIndependentBorderObserver>[
  // Coin packages
  ResetIndependentBorderObserver(
    itemId: 'zy_coins_1',
    name: '金币包',
    type: 'coins',
    coinAmount: 38,
    price: '¥39',
    description: '获得38个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_coins_2',
    name: '金币包',
    type: 'coins',
    coinAmount: 82,
    price: '¥89',
    description: '获得82个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_coins_3',
    name: '金币包',
    type: 'coins',
    coinAmount: 154,
    price: '¥167',
    description: '获得154个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_coins_4',
    name: '金币包',
    type: 'coins',
    coinAmount: 346,
    price: '¥378',
    description: '获得346个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_coins_6',
    name: '金币包',
    type: 'coins',
    coinAmount: 586,
    price: '¥638',
    description: '获得586个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),

  // Male VIP packages
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_male_1',
    name: '15天尊享会员',
    type: 'subscription',
    coinAmount: 50,
    price: '¥138',
    description: '50金币',
    locale: 'zh_CN',
    category: 'vip',
    gender: 'male',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_male_2',
    name: '30天尊享会员',
    type: 'subscription',
    coinAmount: 120,
    price: '¥228',
    description: '120金币',
    locale: 'zh_CN',
    category: 'vip',
    gender: 'male',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_male_3',
    name: '90天尊享会员',
    type: 'subscription',
    coinAmount: 400,
    price: '¥428',
    description: '400金币',
    locale: 'zh_CN',
    category: 'vip',
    gender: 'male',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_male_4',
    name: '180天尊享会员',
    type: 'subscription',
    coinAmount: 900,
    price: '¥608',
    description: '900金币',
    locale: 'zh_CN',
    category: 'vip',
    gender: 'male',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_male_sale_1',
    name: '限时特惠会员',
    type: 'subscription',
    coinAmount: 20,
    price: '¥58',
    description: '20金币',
    locale: 'zh_CN',
    category: 'vip_sale',
    gender: 'male',
  ),

  // Female VIP packages
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_female_1',
    name: '15天优雅会员',
    type: 'subscription',
    coinAmount: 50,
    price: '¥30',
    description: '50金币',
    locale: 'zh_CN',
    category: 'vip',
    gender: 'female',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_female_2',
    name: '30天优雅会员',
    type: 'subscription',
    coinAmount: 120,
    price: '¥55',
    description: '120金币',
    locale: 'zh_CN',
    category: 'vip',
    gender: 'female',
  ),
  ResetIndependentBorderObserver(
    itemId: 'zy_vip_female_3',
    name: '90天优雅会员',
    type: 'subscription',
    coinAmount: 400,
    price: '¥128',
    description: '400金币',
    locale: 'zh_CN',
    category: 'vip',
    gender: 'female',
  ),
];
