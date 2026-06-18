/// 订单数据模型（DTO）
///
/// 表示玩家的充值订单信息，包含订单号、金额和状态。
class OrderModel {
  /// 订单唯一标识
  final String id;

  /// 用户 ID
  final String userId;

  /// 商品 ID
  final String productId;

  /// 订单金额（分）
  final int amount;

  /// 订单状态（pending/paid/delivered/refunded）
  final String status;

  /// 创建时间戳（毫秒）
  final int createdAt;

  /// 支付时间戳（毫秒）
  final int? paidAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.amount,
    this.status = 'pending',
    this.createdAt = 0,
    this.paidAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      productId: json['product_id'] as String? ?? json['productId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      createdAt: (json['created_at'] as num?)?.toInt() ?? (json['createdAt'] as num?)?.toInt() ?? 0,
      paidAt: json['paid_at'] != null
          ? (json['paid_at'] as num).toInt()
          : json['paidAt'] != null
              ? (json['paidAt'] as num).toInt()
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'product_id': productId,
        'amount': amount,
        'status': status,
        'created_at': createdAt,
        if (paidAt != null) 'paid_at': paidAt,
      };

  OrderModel copyWith({
    String? id,
    String? userId,
    String? productId,
    int? amount,
    String? status,
    int? createdAt,
    int? paidAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
