/// 道具数据模型（DTO）
///
/// 表示游戏中的道具配置，包含道具类型、稀有度和描述。
class ItemModel {
  /// 道具唯一标识
  final String id;

  /// 道具名称
  final String name;

  /// 道具类型标识
  final String type;

  /// 稀有度标识
  final String rarity;

  /// 道具描述
  final String? description;

  /// 拥有数量
  final int count;

  /// 是否可使用
  final bool usable;

  /// 图标路径
  final String? icon;

  const ItemModel({
    required this.id,
    required this.name,
    required this.type,
    this.rarity = 'n',
    this.description,
    this.count = 0,
    this.usable = false,
    this.icon,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      rarity: json['rarity'] as String? ?? 'n',
      description: json['description'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
      usable: json['usable'] as bool? ?? false,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'rarity': rarity,
        if (description != null) 'description': description,
        'count': count,
        'usable': usable,
        if (icon != null) 'icon': icon,
      };

  ItemModel copyWith({
    String? id,
    String? name,
    String? type,
    String? rarity,
    String? description,
    int? count,
    bool? usable,
    String? icon,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      description: description ?? this.description,
      count: count ?? this.count,
      usable: usable ?? this.usable,
      icon: icon ?? this.icon,
    );
  }
}
