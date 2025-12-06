/// Gear item model
class GearItem {
  final String id;
  final String name;
  final String category;
  final String emoji;
  final String? description;
  final bool isPacked;
  final String? condition;
  final double? weight;
  final double? value;

  const GearItem({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    this.description,
    this.isPacked = false,
    this.condition,
    this.weight,
    this.value,
  });

  /// Create GearItem from JSON
  factory GearItem.fromJson(Map<String, dynamic> json) {
    return GearItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String?,
      isPacked: json['isPacked'] as bool? ?? false,
      condition: json['condition'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      value: (json['value'] as num?)?.toDouble(),
    );
  }

  /// Convert GearItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'emoji': emoji,
      'description': description,
      'isPacked': isPacked,
      'condition': condition,
      'weight': weight,
      'value': value,
    };
  }

  /// Create a copy with updated fields
  GearItem copyWith({
    String? id,
    String? name,
    String? category,
    String? emoji,
    String? description,
    bool? isPacked,
    String? condition,
    double? weight,
    double? value,
  }) {
    return GearItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      isPacked: isPacked ?? this.isPacked,
      condition: condition ?? this.condition,
      weight: weight ?? this.weight,
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'GearItem(id: $id, name: $name, isPacked: $isPacked)';
}

/// Gear categories
class GearCategory {
  static const String all = 'All';
  static const String sleep = 'Sleep';
  static const String cook = 'Cook';
  static const String lighting = 'Lighting';
  static const String clothing = 'Clothing';
  static const String tools = 'Tools';
  static const String firstAid = 'First Aid';

  static List<String> get allCategories => [
    all,
    sleep,
    cook,
    lighting,
    clothing,
    tools,
    firstAid,
  ];
}
