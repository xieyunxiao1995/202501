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
  // 金币包 - 使用yuebang_前缀
  MarkOriginalAssetArray(
    itemId: 'yuebang_coins_1',
    name: '金币包1',
    type: 'consumable',
    coinAmount: 38,
    price: '¥39',
    description: '可一次性获得38个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_coins_2',
    name: '金币包2',
    type: 'consumable',
    coinAmount: 82,
    price: '¥89',
    description: '可一次性获得82个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_coins_3',
    name: '金币包3',
    type: 'consumable',
    coinAmount: 154,
    price: '¥167',
    description: '可一次性获得154个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_coins_4',
    name: '金币包4',
    type: 'consumable',
    coinAmount: 346,
    price: '¥378',
    description: '可一次性获得346个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_coins_5',
    name: '金币包5',
    type: 'consumable',
    coinAmount: 586,
    price: '¥638',
    description: '可一次性获得586个金币',
    locale: 'zh_CN',
    category: 'coins',
  ),

  // VIP会员包 - 按您提供的ID列表整理
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_1',
    name: '1天VIP会员',
    type: 'consumable',
    coinAmount: 30, // 1天VIP赠送30金币
    price: '¥78',
    description: '1天会员使用资格，可一次性获得30金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 1,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_6',
    name: '7天VIP会员',
    type: 'consumable',
    coinAmount: 50, // 7天VIP赠送50金币
    price: '¥58',
    description: '7天会员使用资格，可一次性获得50金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 7,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_2',
    name: '7天VIP会员',
    type: 'consumable',
    coinAmount: 70, // 另一个7天VIP赠送70金币
    price: '¥98',
    description: '7天会员使用资格，可一次性获得70金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 7,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_7',
    name: '15天VIP会员',
    type: 'consumable',
    coinAmount: 100, // 15天VIP赠送100金币
    price: '¥30',
    description: '15天会员使用资格，可一次性获得100金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 15,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_3',
    name: '15天VIP会员',
    type: 'consumable',
    coinAmount: 150, // 另一个15天VIP赠送150金币
    price: '¥138',
    description: '15天会员使用资格，可一次性获得150金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 15,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_8',
    name: '30天VIP会员',
    type: 'consumable',
    coinAmount: 200, // 30天VIP赠送200金币
    price: '¥55',
    description: '30天会员使用资格，可一次性获得200金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 30,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_4',
    name: '30天VIP会员',
    type: 'consumable',
    coinAmount: 250, // 另一个30天VIP赠送250金币
    price: '¥228',
    description: '30天会员使用资格，可一次性获得250金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 30,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_9',
    name: '90天VIP会员',
    type: 'consumable',
    coinAmount: 500, // 90天VIP赠送500金币
    price: '¥128',
    description: '90天会员使用资格，可一次性获得500金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 90,
  ),
  MarkOriginalAssetArray(
    itemId: 'yuebang_vip_5',
    name: '90天VIP会员',
    type: 'consumable',
    coinAmount: 800, // 另一个90天VIP赠送800金币
    price: '¥428',
    description: '90天会员使用资格，可一次性获得800金币',
    locale: 'zh_CN',
    category: 'vip',
    vipDays: 90,
  ),
];
