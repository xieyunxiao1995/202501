import 'user_model.dart';

/// Post model for discovery feed
class Post {
  final String id;
  final String title;
  final String? description;
  final List<String> imageUrls;
  final String creatorId;
  final User? creator;
  final int likes;
  final bool isLiked;
  final bool hasPlan;
  final String? planId;
  final String category;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.title,
    this.description,
    this.imageUrls = const [],
    required this.creatorId,
    this.creator,
    required this.likes,
    this.isLiked = false,
    this.hasPlan = false,
    this.planId,
    required this.category,
    required this.createdAt,
  });

  /// Create Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      creatorId: json['creatorId'] as String,
      creator: json['creator'] != null
          ? User.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      likes: json['likes'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      hasPlan: json['hasPlan'] as bool? ?? false,
      planId: json['planId'] as String?,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'creatorId': creatorId,
      'creator': creator?.toJson(),
      'likes': likes,
      'isLiked': isLiked,
      'hasPlan': hasPlan,
      'planId': planId,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  Post copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? creatorId,
    User? creator,
    int? likes,
    bool? isLiked,
    bool? hasPlan,
    String? planId,
    String? category,
    DateTime? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      creatorId: creatorId ?? this.creatorId,
      creator: creator ?? this.creator,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      hasPlan: hasPlan ?? this.hasPlan,
      planId: planId ?? this.planId,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'Post(id: $id, title: $title, creator: ${creator?.username})';
}

/// Post categories
class PostCategory {
  static const String featured = 'Featured';
  static const String bushcraft = 'Bushcraft';
  static const String glamping = 'Glamping';
}
