/// 充值商品数据模型（DTO）
///
/// 表示可充值的商品配置，包含价格、元宝数量和首充奖励信息。
class RechargeModel {
  /// 商品唯一标识
  final String id;

  /// 商品名称
  final String name;

  /// 价格（分）
  final int price;

  /// 获得元宝数量
  final int premiumAmount;

  /// 是否首充奖励已领取
  final bool firstBonusClaimed;

  /// 首充额外奖励（物品ID -> 数量）
  final Map<String, int> firstBonusItems;

  /// 排序权重
  final int sortWeight;

  const RechargeModel({
    required this.id,
    required this.name,
    required this.price,
    required this.premiumAmount,
    this.firstBonusClaimed = false,
    this.firstBonusItems = const {},
    this.sortWeight = 0,
  });

  factory RechargeModel.fromJson(Map<String, dynamic> json) {
    return RechargeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num?)?.toInt() ?? 0,
      premiumAmount: (json['premium_amount'] as num?)?.toInt() ?? (json['premiumAmount'] as num?)?.toInt() ?? 0,
      firstBonusClaimed: json['first_bonus_claimed'] as bool? ?? json['firstBonusClaimed'] as bool? ?? false,
      firstBonusItems: (json['first_bonus_items'] as Map<String, dynamic>? ?? json['firstBonusItems'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? const {},
      sortWeight: (json['sort_weight'] as num?)?.toInt() ?? (json['sortWeight'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'premium_amount': premiumAmount,
        'first_bonus_claimed': firstBonusClaimed,
        'first_bonus_items': firstBonusItems,
        'sort_weight': sortWeight,
      };

  RechargeModel copyWith({
    String? id,
    String? name,
    int? price,
    int? premiumAmount,
    bool? firstBonusClaimed,
    Map<String, int>? firstBonusItems,
    int? sortWeight,
  }) {
    return RechargeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      premiumAmount: premiumAmount ?? this.premiumAmount,
      firstBonusClaimed: firstBonusClaimed ?? this.firstBonusClaimed,
      firstBonusItems: firstBonusItems ?? this.firstBonusItems,
      sortWeight: sortWeight ?? this.sortWeight,
    );
  }
}
