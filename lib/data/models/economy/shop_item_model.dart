/// 商店商品数据模型（DTO）
///
/// 表示商店中的单个商品，包含价格、限购和折扣信息。
class ShopItemModel {
  /// 商品唯一标识
  final String id;

  /// 商品名称
  final String name;

  /// 物品 ID
  final String itemId;

  /// 价格
  final int price;

  /// 货币类型标识
  final String currencyType;

  /// 限购数量（0表示不限购）
  final int purchaseLimit;

  /// 已购买数量
  final int purchased;

  /// 折扣比例（0.0-1.0，1.0为无折扣）
  final double discount;

  /// 是否在售
  final bool available;

  const ShopItemModel({
    required this.id,
    required this.name,
    required this.itemId,
    required this.price,
    required this.currencyType,
    this.purchaseLimit = 0,
    this.purchased = 0,
    this.discount = 1.0,
    this.available = true,
  });

  factory ShopItemModel.fromJson(Map<String, dynamic> json) {
    return ShopItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      itemId: json['item_id'] as String? ?? json['itemId'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      currencyType: json['currency_type'] as String? ?? json['currencyType'] as String? ?? '',
      purchaseLimit: (json['purchase_limit'] as num?)?.toInt() ?? (json['purchaseLimit'] as num?)?.toInt() ?? 0,
      purchased: (json['purchased'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 1.0,
      available: json['available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'item_id': itemId,
        'price': price,
        'currency_type': currencyType,
        'purchase_limit': purchaseLimit,
        'purchased': purchased,
        'discount': discount,
        'available': available,
      };

  ShopItemModel copyWith({
    String? id,
    String? name,
    String? itemId,
    int? price,
    String? currencyType,
    int? purchaseLimit,
    int? purchased,
    double? discount,
    bool? available,
  }) {
    return ShopItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      itemId: itemId ?? this.itemId,
      price: price ?? this.price,
      currencyType: currencyType ?? this.currencyType,
      purchaseLimit: purchaseLimit ?? this.purchaseLimit,
      purchased: purchased ?? this.purchased,
      discount: discount ?? this.discount,
      available: available ?? this.available,
    );
  }
}
