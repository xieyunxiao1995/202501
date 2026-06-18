/// 商店数据模型（DTO）
///
/// 表示游戏中的商店配置，包含商店类型、名称和商品列表。
class ShopModel {
  /// 商店唯一标识
  final String id;

  /// 商店名称
  final String name;

  /// 商店类型标识
  final String type;

  /// 商品 ID 列表
  final List<String> itemIds;

  /// 刷新时间间隔（秒）
  final int refreshInterval;

  /// 下次刷新时间戳（毫秒）
  final int nextRefreshTime;

  const ShopModel({
    required this.id,
    required this.name,
    required this.type,
    this.itemIds = const [],
    this.refreshInterval = 86400,
    this.nextRefreshTime = 0,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      itemIds: (json['item_ids'] as List<dynamic>? ?? json['itemIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ?? const [],
      refreshInterval: (json['refresh_interval'] as num?)?.toInt() ?? (json['refreshInterval'] as num?)?.toInt() ?? 86400,
      nextRefreshTime: (json['next_refresh_time'] as num?)?.toInt() ?? (json['nextRefreshTime'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'item_ids': itemIds,
        'refresh_interval': refreshInterval,
        'next_refresh_time': nextRefreshTime,
      };

  ShopModel copyWith({
    String? id,
    String? name,
    String? type,
    List<String>? itemIds,
    int? refreshInterval,
    int? nextRefreshTime,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      itemIds: itemIds ?? this.itemIds,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      nextRefreshTime: nextRefreshTime ?? this.nextRefreshTime,
    );
  }
}
