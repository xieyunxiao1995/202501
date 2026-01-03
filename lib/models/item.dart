class Item {
  final String id;
  final String name;
  final String description;
  final int damage;
  final String iconData; // Can be emoji or specific string key for Icon map

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.damage,
    required this.iconData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'damage': damage,
      'iconData': iconData,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      damage: json['damage'] ?? 0,
      iconData: json['iconData'] ?? '❓',
    );
  }
}
