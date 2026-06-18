/// 货币数据模型（DTO）
///
/// 表示玩家持有的各类货币数量，如金币、元宝、美玉等。
class CurrencyModel {
  /// 货币类型标识
  final String type;

  /// 当前数量
  final int amount;

  const CurrencyModel({
    required this.type,
    this.amount = 0,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      type: json['type'] as String,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'amount': amount,
      };

  CurrencyModel copyWith({
    String? type,
    int? amount,
  }) {
    return CurrencyModel(
      type: type ?? this.type,
      amount: amount ?? this.amount,
    );
  }
}
