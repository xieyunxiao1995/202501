class Journal {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final List<String> emotionTags;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId; // 用户ID，用于拉黑功能

  Journal({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.emotionTags,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'emotionTags': emotionTags,
      'isPrivate': isPrivate,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      emotionTags: List<String>.from(json['emotionTags'] ?? []),
      isPrivate: json['isPrivate'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      userId: json['userId'] ?? 'anonymous_${json['id']}', // 兼容旧数据
    );
  }

  Journal copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? emotionTags,
    bool? isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Journal(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      emotionTags: emotionTags ?? this.emotionTags,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}
