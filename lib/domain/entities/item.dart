import '../../shared/enums/item_type.dart' as enums;
import '../../shared/enums/rarity.dart' as enums;

/// 道具实体
///
/// 表示游戏中的各类道具，包括材料、经验书、进阶石、招贤令等。
/// 道具可堆叠，通过数量字段记录持有量。
class Item {
  /// 道具唯一标识
  final String id;

  /// 道具名称
  final String name;

  /// 道具类型（材料/经验书/进阶石/觉醒石/招贤令/装备材料/礼物/宝箱）
  final enums.ItemType type;

  /// 稀有度
  final enums.Rarity rarity;

  /// 持有数量
  final int quantity;

  /// 道具描述
  final String description;

  /// 图标路径
  final String? iconPath;

  const Item({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    this.quantity = 0,
    this.description = '',
    this.iconPath,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] != null
          ? enums.ItemType.fromJson(json['type'] as String)
          : enums.ItemType.material,
      rarity: json['rarity'] != null
          ? enums.Rarity.fromJson(json['rarity'] as String)
          : enums.Rarity.n,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      iconPath: json['iconPath'] as String? ?? json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'rarity': rarity.toJson(),
        'quantity': quantity,
        'description': description,
        'iconPath': iconPath,
      };

  Item copyWith({
    String? id,
    String? name,
    enums.ItemType? type,
    enums.Rarity? rarity,
    int? quantity,
    String? description,
    String? iconPath,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}

