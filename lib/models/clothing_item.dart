class ClothingItem {
  const ClothingItem({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.category,
    required this.color,
    required this.season,
    required this.isPurchased,
    required this.careNotes,
    required this.createdAt,
  });

  final String id;
  final String imagePath;
  final String name;
  final String category;
  final String color;
  final String season;
  final bool isPurchased;
  final String careNotes;
  final DateTime createdAt;

  ClothingItem copyWith({
    String? id,
    String? imagePath,
    String? name,
    String? category,
    String? color,
    String? season,
    bool? isPurchased,
    String? careNotes,
    DateTime? createdAt,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      season: season ?? this.season,
      isPurchased: isPurchased ?? this.isPurchased,
      careNotes: careNotes ?? this.careNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'name': name,
      'category': category,
      'color': color,
      'season': season,
      'isPurchased': isPurchased,
      'careNotes': careNotes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '其他',
      color: json['color'] as String? ?? '',
      season: json['season'] as String? ?? '四季',
      isPurchased: json['isPurchased'] as bool? ?? true,
      careNotes: json['careNotes'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClothingItem &&
            id == other.id &&
            imagePath == other.imagePath &&
            name == other.name &&
            category == other.category &&
            color == other.color &&
            season == other.season &&
            isPurchased == other.isPurchased &&
            careNotes == other.careNotes &&
            createdAt == other.createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    imagePath,
    name,
    category,
    color,
    season,
    isPurchased,
    careNotes,
    createdAt,
  );
}
