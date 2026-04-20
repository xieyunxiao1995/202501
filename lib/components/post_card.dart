import 'package:flutter/material.dart';
import '../../models/data.dart';
import '../../theme/theme.dart';

class PostCard extends StatelessWidget {
  final CommunityPost post;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onMoreTap;

  const PostCard({
    super.key,
    required this.post,
    required this.heroTag,
    required this.onTap,
    required this.onLike,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域
            if (post.imageUrl != null) ...[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: _buildImage(post.imageUrl!),
                    ),
                  ),
                  if (post.tag != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _buildTagChip(post.tag!),
                    ),
                ],
              ),
            ],

            // 内容区域
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户信息及操作
                  Row(
                    children: [
                      if (post.userAvatar != null) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade200,
                          child: _buildAvatarImage(post.userAvatar!),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post.userName != null)
                              Text(
                                post.userName!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMain,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (post.timeAgo != null)
                              Text(
                                post.timeAgo!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // 更多按钮（举报/拉黑） - 修复了 onTap 为 onPressed
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: onMoreTap,
                      ),
                      const SizedBox(width: 12),

                      // 点赞按钮
                      GestureDetector(
                        onTap: onLike,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.volunteer_activism,
                              size: 18,
                              color: post.isLiked
                                  ? AppColors.primaryDark
                                  : Colors.grey.shade400,
                              fill: post.isLiked ? 1 : 0,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${post.likes}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: post.isLiked
                                      ? AppColors.primaryDark
                                      : Colors.grey.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 内容文本
                  if (post.content != null && post.content!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      post.content!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // 底部互动数据
                  if (post.comments > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.mode_comment_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.comments}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textMain,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.image,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildAvatarImage(String avatar) {
    if (avatar.startsWith('http') || avatar.startsWith('assets/')) {
      return ClipOval(
        child: avatar.startsWith('assets/')
            ? Image.asset(
                avatar,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 16),
              )
            : Image.network(
                avatar,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 16),
              ),
      );
    }
    return Text(avatar, style: const TextStyle(fontSize: 14));
  }
}
