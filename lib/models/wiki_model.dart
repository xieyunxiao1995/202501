/// Wiki article model
class WikiArticle {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String description;
  final String? videoUrl;
  final String? videoDuration;
  final String? thumbnailUrl;
  final List<WikiStep> steps;
  final List<RelatedGear> relatedGear;
  final DateTime createdAt;
  final bool isBookmarked;

  const WikiArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.description,
    this.videoUrl,
    this.videoDuration,
    this.thumbnailUrl,
    this.steps = const [],
    this.relatedGear = const [],
    required this.createdAt,
    this.isBookmarked = false,
  });

  /// Create WikiArticle from JSON
  factory WikiArticle.fromJson(Map<String, dynamic> json) {
    return WikiArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String?,
      videoDuration: json['videoDuration'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => WikiStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      relatedGear:
          (json['relatedGear'] as List<dynamic>?)
              ?.map((e) => RelatedGear.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  /// Convert WikiArticle to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'difficulty': difficulty,
      'description': description,
      'videoUrl': videoUrl,
      'videoDuration': videoDuration,
      'thumbnailUrl': thumbnailUrl,
      'steps': steps.map((e) => e.toJson()).toList(),
      'relatedGear': relatedGear.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isBookmarked': isBookmarked,
    };
  }

  /// Create a copy with updated fields
  WikiArticle copyWith({
    String? id,
    String? title,
    String? category,
    String? difficulty,
    String? description,
    String? videoUrl,
    String? videoDuration,
    String? thumbnailUrl,
    List<WikiStep>? steps,
    List<RelatedGear>? relatedGear,
    DateTime? createdAt,
    bool? isBookmarked,
  }) {
    return WikiArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      videoDuration: videoDuration ?? this.videoDuration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      steps: steps ?? this.steps,
      relatedGear: relatedGear ?? this.relatedGear,
      createdAt: createdAt ?? this.createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  String toString() =>
      'WikiArticle(id: $id, title: $title, category: $category)';
}

/// Wiki step model
class WikiStep {
  final int stepNumber;
  final String title;
  final String description;
  final String? imageUrl;
  final String? tip;

  const WikiStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.imageUrl,
    this.tip,
  });

  /// Create WikiStep from JSON
  factory WikiStep.fromJson(Map<String, dynamic> json) {
    return WikiStep(
      stepNumber: json['stepNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      tip: json['tip'] as String?,
    );
  }

  /// Convert WikiStep to JSON
  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'tip': tip,
    };
  }
}

/// Related gear model
class RelatedGear {
  final String id;
  final String name;
  final String description;
  final String emoji;

  const RelatedGear({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
  });

  /// Create RelatedGear from JSON
  factory RelatedGear.fromJson(Map<String, dynamic> json) {
    return RelatedGear(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
    );
  }

  /// Convert RelatedGear to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description, 'emoji': emoji};
  }
}

/// Wiki categories
class WikiCategory {
  static const String setup = 'Setup Guide';
  static const String cooking = 'Camp Food';
  static const String firstAid = 'First Aid';
  static const String skills = 'Skills';
}

/// Difficulty levels
class Difficulty {
  static const String beginner = 'Beginner';
  static const String intermediate = 'Intermediate';
  static const String advanced = 'Advanced';
}
