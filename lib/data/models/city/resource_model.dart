/// 资源数据模型（DTO）
///
/// 表示玩家拥有的各类资源数量，如粮食、金币、木材、铁矿等。
class ResourceModel {
  /// 资源类型标识
  final String type;

  /// 当前数量
  final int amount;

  /// 上限（0表示无上限）
  final int capacity;

  /// 每小时产量
  final int productionPerHour;

  const ResourceModel({
    required this.type,
    this.amount = 0,
    this.capacity = 0,
    this.productionPerHour = 0,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      type: json['type'] as String,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      productionPerHour: (json['productionPerHour'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'amount': amount,
        'capacity': capacity,
        'productionPerHour': productionPerHour,
      };

  ResourceModel copyWith({
    String? type,
    int? amount,
    int? capacity,
    int? productionPerHour,
  }) {
    return ResourceModel(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      capacity: capacity ?? this.capacity,
      productionPerHour: productionPerHour ?? this.productionPerHour,
    );
  }
}
