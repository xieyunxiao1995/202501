
enum ItemType {
  consumable,
  material,
  special,
}

enum ItemEffectType {
  healSanity,
  restoreInk,
  buffAttack, // Example for future
  none,
}

class Item {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemEffectType effectType;
  final int effectValue;
  int count;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.effectType = ItemEffectType.none,
    this.effectValue = 0,
    this.count = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'effectType': effectType.index,
      'effectValue': effectValue,
      'count': count,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: ItemType.values[json['type']],
      effectType: ItemEffectType.values[json['effectType'] ?? ItemEffectType.none.index],
      effectValue: json['effectValue'] ?? 0,
      count: json['count'] ?? 1,
    );
  }
  
  Item copyWith({int? count}) {
    return Item(
      id: id,
      name: name,
      description: description,
      type: type,
      effectType: effectType,
      effectValue: effectValue,
      count: count ?? this.count,
    );
  }
}
