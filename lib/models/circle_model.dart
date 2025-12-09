/// Circle model for community groups
class Circle {
  final String id;
  final String name;
  final String emoji;
  final String? description;
  final int memberCount;
  final String category;
  final bool isJoined;

  const Circle({
    required this.id,
    required this.name,
    required this.emoji,
    this.description,
    required this.memberCount,
    required this.category,
    this.isJoined = false,
  });

  /// Create Circle from JSON
  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String?,
      memberCount: json['memberCount'] as int? ?? 0,
      category: json['category'] as String,
      isJoined: json['isJoined'] as bool? ?? false,
    );
  }

  /// Convert Circle to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'description': description,
      'memberCount': memberCount,
      'category': category,
      'isJoined': isJoined,
    };
  }

  /// Create a copy with updated fields
  Circle copyWith({
    String? id,
    String? name,
    String? emoji,
    String? description,
    int? memberCount,
    String? category,
    bool? isJoined,
  }) {
    return Circle(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      category: category ?? this.category,
      isJoined: isJoined ?? this.isJoined,
    );
  }

  @override
  String toString() => 'Circle(id: $id, name: $name, members: $memberCount)';
}

/// Circle categories
class CircleCategory {
  static const String location = 'location';
  static const String interest = 'interest';
  static const String skillLevel = 'skill_level';
}
