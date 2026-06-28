class OutfitEntry {
  const OutfitEntry({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.occasion,
    required this.mood,
    required this.notes,
    required this.clothingItemIds,
  });

  final String id;
  final String imagePath;
  final String title;
  final DateTime date;
  final String occasion;
  final String mood;
  final String notes;
  final List<String> clothingItemIds;

  OutfitEntry copyWith({
    String? id,
    String? imagePath,
    String? title,
    DateTime? date,
    String? occasion,
    String? mood,
    String? notes,
    List<String>? clothingItemIds,
  }) {
    return OutfitEntry(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      date: date ?? this.date,
      occasion: occasion ?? this.occasion,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
      clothingItemIds: clothingItemIds ?? this.clothingItemIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'date': date.toIso8601String(),
      'occasion': occasion,
      'mood': mood,
      'notes': notes,
      'clothingItemIds': clothingItemIds,
    };
  }

  factory OutfitEntry.fromJson(Map<String, dynamic> json) {
    return OutfitEntry(
      id: json['id'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      occasion: json['occasion'] as String? ?? '',
      mood: json['mood'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      clothingItemIds: (json['clothingItemIds'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OutfitEntry &&
            id == other.id &&
            imagePath == other.imagePath &&
            title == other.title &&
            date == other.date &&
            occasion == other.occasion &&
            mood == other.mood &&
            notes == other.notes &&
            _listsEqual(clothingItemIds, other.clothingItemIds);
  }

  @override
  int get hashCode => Object.hash(
    id,
    imagePath,
    title,
    date,
    occasion,
    mood,
    notes,
    Object.hashAll(clothingItemIds),
  );
}

bool _listsEqual(List<Object?> first, List<Object?> second) {
  if (identical(first, second)) return true;
  if (first.length != second.length) return false;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return false;
  }
  return true;
}
