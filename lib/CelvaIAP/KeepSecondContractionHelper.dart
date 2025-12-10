class MarkOriginalAssetArray {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;
  final int? vipDays;

  const MarkOriginalAssetArray({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
    this.vipDays,
  });
}

const List<MarkOriginalAssetArray> shopInventory = <MarkOriginalAssetArray>[
  // 金币包
  MarkOriginalAssetArray(
    itemId: 'meilv_coins_1',
    name: '金币包1',
    type: 'consumable',
    coinAmount: 38,
    price: '¥39',
    description: '可一次性获得38个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_coins_2',
    name: '金币包2',
    type: 'consumable',
    coinAmount: 82,
    price: '¥89',
    description: '可一次性获得82个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_coins_3',
    name: '金币包3',
    type: 'consumable',
    coinAmount: 154,
    price: '¥167',
    description: '可一次性获得154个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_coins_4',
    name: '金币包4',
    type: 'consumable',
    coinAmount: 346,
    price: '¥378',
    description: '可一次性获得346个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_coins_5',
    name: '金币包5',
    type: 'consumable',
    coinAmount: 586,
    price: '¥638',
    description: '可一次性获得586个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),

  // VIP会员包（更优惠的金币赠送）
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_5',
    name: '7天VIP会员',
    type: 'consumable',
    coinAmount: 50, // 更优惠：从20增加到50金币
    price: '¥58',
    description: '7天会员使用资格，可一次性获得50金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 7,
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_6',
    name: '15天VIP会员',
    type: 'consumable',
    coinAmount: 100, // 更优惠：从45增加到100金币
    price: '¥30',
    description: '15天会员使用资格，可一次性获得100金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 15,
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_1',
    name: '15天VIP会员',
    type: 'consumable',
    coinAmount: 150, // 更优惠：从45增加到150金币
    price: '¥138',
    description: '15天会员使用资格，可一次性获得150金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 15,
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_7',
    name: '30天VIP会员',
    type: 'consumable',
    coinAmount: 200, // 更优惠：从100增加到200金币
    price: '¥55',
    description: '30天会员使用资格，可一次性获得200金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 30,
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_2',
    name: '30天VIP会员',
    type: 'consumable',
    coinAmount: 250, // 更优惠：从100增加到250金币
    price: '¥228',
    description: '30天会员使用资格，可一次性获得250金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 30,
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_8',
    name: '90天VIP会员',
    type: 'consumable',
    coinAmount: 500, // 更优惠：从300增加到500金币
    price: '¥128',
    description: '90天会员使用资格，可一次性获得500金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 90,
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_3',
    name: '90天VIP会员',
    type: 'consumable',
    coinAmount: 800, // 更优惠：从300增加到800金币
    price: '¥428',
    description: '90天会员使用资格，可一次性获得800金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 90,
  ),
  MarkOriginalAssetArray(
    itemId: 'meilv_vip_4',
    name: '180天VIP会员',
    type: 'consumable',
    coinAmount: 1200, // 更优惠：从600增加到1200金币
    price: '¥608',
    description: '180天会员使用资格，可一次性获得1200金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 180,
  ),
];
