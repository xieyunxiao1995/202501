import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../utils/constants.dart';
import 'image_placeholder.dart';

/// Post card for discovery feed
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback? onLike;
  final VoidCallback? onCreatorTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onLike,
    this.onCreatorTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: AppConstants.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeHeading3,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildCreatorInfo(), _buildLikeButton()],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusLarge),
          ),
          child: post.imageUrls.isNotEmpty
              ? Image.asset(
                  post.imageUrls.first,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ImagePlaceholder(
                      width: double.infinity,
                      height: 200,
                      icon: Icons.landscape,
                      iconSize: 48,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppConstants.radiusLarge),
                      ),
                    );
                  },
                )
              : ImagePlaceholder(
                  width: double.infinity,
                  height: 200,
                  icon: Icons.landscape,
                  iconSize: 48,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.radiusLarge),
                  ),
                ),
        ),
        if (post.hasPlan)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.layers, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Plan Included',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeCaption,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCreatorInfo() {
    return GestureDetector(
      onTap: onCreatorTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[300],
            backgroundImage: post.creator?.avatarUrl != null
                ? AssetImage(post.creator!.avatarUrl!)
                : null,
            child: post.creator?.avatarUrl == null
                ? const Icon(Icons.person, size: 14, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            post.creator?.username ?? 'Anonymous',
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return GestureDetector(
      onTap: onLike,
      child: Icon(
        post.isLiked ? Icons.favorite : Icons.favorite_border,
        color: post.isLiked ? Colors.red : Colors.grey[400],
        size: AppConstants.iconSizeLarge,
      ),
    );
  }
}
