class DetachUniqueNameContainer {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const DetachUniqueNameContainer({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
  });
}

const List<DetachUniqueNameContainer> shopInventory = <DetachUniqueNameContainer>[
  DetachUniqueNameContainer(
    itemId: 'CPDZ_ios_006',
    name: '初尝套餐',
    type: 'consumable',
    coinAmount: 42,
    price: '¥6',
    description: '适合初次体验',
    locale: 'zh_CN',
    category: 'basic',
  ),
  DetachUniqueNameContainer(
    itemId: 'CPDZ_ios_012',
    name: '轻享套餐',
    type: 'consumable',
    coinAmount: 84,
    price: '¥12',
    description: '日常轻度使用',
    locale: 'zh_CN',
    category: 'basic',
  ),
  DetachUniqueNameContainer(
    itemId: 'CPDZ_ios_038',
    name: '进阶套餐',
    type: 'consumable',
    coinAmount: 266,
    price: '¥38',
    description: '适合进阶用户',
    locale: 'zh_CN',
    category: 'value',
  ),
  DetachUniqueNameContainer(
    itemId: 'CPDZ_ios_098',
    name: '畅享套餐',
    type: 'consumable',
    coinAmount: 686,
    price: '¥98',
    description: '高频使用首选',
    locale: 'zh_CN',
    category: 'value',
  ),
  DetachUniqueNameContainer(
    itemId: 'CPDZ_ios_168',
    name: '豪华套餐',
    type: 'consumable',
    coinAmount: 1176,
    price: '¥168',
    description: '超值大礼包',
    locale: 'zh_CN',
    category: 'premium',
  ),
  DetachUniqueNameContainer(
    itemId: 'CPDZ_ios_388',
    name: '至尊套餐',
    type: 'consumable',
    coinAmount: 2716,
    price: '¥388',
    description: '最大规格礼包',
    locale: 'zh_CN',
    category: 'premium',
  ),
];
