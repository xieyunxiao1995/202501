/// Topic model for community discussions
class Topic {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final int replyCount;
  final DateTime lastUpdated;
  final String? authorId;
  final List<TopicReply> replies;

  const Topic({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.replyCount,
    required this.lastUpdated,
    this.authorId,
    this.replies = const [],
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${difference.inDays ~/ 7}周前';
    }
  }
}

/// Topic reply model
class TopicReply {
  final String id;
  final String content;
  final String authorId;
  final DateTime createdAt;
  final int likes;

  const TopicReply({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
    required this.likes,
  });
}
