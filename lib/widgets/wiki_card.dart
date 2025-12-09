import 'package:flutter/material.dart';
import '../models/wiki_model.dart';
import '../utils/constants.dart';
import 'image_placeholder.dart';

/// Wiki article card widget
class WikiCard extends StatelessWidget {
  final WikiArticle article;
  final VoidCallback onTap;

  const WikiCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          boxShadow: AppConstants.cardShadow,
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              child: article.thumbnailUrl != null
                  ? Image.asset(
                      article.thumbnailUrl!,
                      width: 140,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ImagePlaceholder(
                          width: 140,
                          height: 180,
                          icon: _getCategoryIcon(),
                          iconSize: AppConstants.iconSizeXXLarge,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMedium,
                          ),
                        );
                      },
                    )
                  : ImagePlaceholder(
                      width: 140,
                      height: 180,
                      icon: _getCategoryIcon(),
                      iconSize: AppConstants.iconSizeXXLarge,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
                    ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            // Text content
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppConstants.accentColor,
                      fontSize: AppConstants.fontSizeCaption,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    if (article.category.contains('Setup')) return Icons.holiday_village;
    if (article.category.contains('Food')) return Icons.restaurant;
    if (article.category.contains('First Aid')) return Icons.medical_services;
    return Icons.menu_book;
  }
}
