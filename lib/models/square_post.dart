class SquarePost {
  final String id;
  final String author;
  final String color;
  final String content;
  final String? image;
  final int likes;
  final bool isLiked;
  final double angle;

  SquarePost({
    required this.id,
    required this.author,
    required this.color,
    required this.content,
    this.image,
    required this.likes,
    required this.isLiked,
    required this.angle,
  });

  SquarePost copyWith({
    String? id,
    String? author,
    String? color,
    String? content,
    String? image,
    int? likes,
    bool? isLiked,
    double? angle,
  }) =>
      SquarePost(
        id: id ?? this.id,
        author: author ?? this.author,
        color: color ?? this.color,
        content: content ?? this.content,
        image: image ?? this.image,
        likes: likes ?? this.likes,
        isLiked: isLiked ?? this.isLiked,
        angle: angle ?? this.angle,
      );
}
