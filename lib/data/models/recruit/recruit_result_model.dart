/// 招募结果数据模型（DTO）
///
/// 表示单次招募的结果，包含获得的武将或物品信息。
class RecruitResultModel {
  /// 结果唯一标识
  final String id;

  /// 卡池 ID
  final String poolId;

  /// 获得类型（general/item/fragment）
  final String resultType;

  /// 获得物品 ID
  final String itemId;

  /// 获得数量
  final int count;

  /// 稀有度标识
  final String rarity;

  /// 是否为新获得
  final bool isNew;

  /// 招募时间戳（毫秒）
  final int timestamp;

  const RecruitResultModel({
    required this.id,
    required this.poolId,
    required this.resultType,
    required this.itemId,
    this.count = 1,
    required this.rarity,
    this.isNew = false,
    this.timestamp = 0,
  });

  factory RecruitResultModel.fromJson(Map<String, dynamic> json) {
    return RecruitResultModel(
      id: json['id'] as String,
      poolId: json['pool_id'] as String? ?? json['poolId'] as String? ?? '',
      resultType: json['result_type'] as String? ?? json['resultType'] as String? ?? '',
      itemId: json['item_id'] as String? ?? json['itemId'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 1,
      rarity: json['rarity'] as String? ?? '',
      isNew: json['is_new'] as bool? ?? json['isNew'] as bool? ?? false,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pool_id': poolId,
        'result_type': resultType,
        'item_id': itemId,
        'count': count,
        'rarity': rarity,
        'is_new': isNew,
        'timestamp': timestamp,
      };

  RecruitResultModel copyWith({
    String? id,
    String? poolId,
    String? resultType,
    String? itemId,
    int? count,
    String? rarity,
    bool? isNew,
    int? timestamp,
  }) {
    return RecruitResultModel(
      id: id ?? this.id,
      poolId: poolId ?? this.poolId,
      resultType: resultType ?? this.resultType,
      itemId: itemId ?? this.itemId,
      count: count ?? this.count,
      rarity: rarity ?? this.rarity,
      isNew: isNew ?? this.isNew,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
