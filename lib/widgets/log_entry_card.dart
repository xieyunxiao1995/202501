import 'package:flutter/material.dart';
import 'dart:io';
import '../models/log_model.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import 'image_placeholder.dart';

/// Log entry card widget
class LogEntryCard extends StatelessWidget {
  final LogEntry log;
  final bool isLatest;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const LogEntryCard({
    super.key, 
    required this.log, 
    this.isLatest = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                gradient: isLatest 
                    ? const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      )
                    : null,
                color: isLatest ? null : Colors.grey[400],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: isLatest ? [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.date.toRelativeString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isLatest
                        ? const Color(0xFF667EEA)
                        : Colors.grey[600],
                  ),
                ),
                if (log.location != null)
                  Text(
                    log.location!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            margin: const EdgeInsets.only(left: 28),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isLatest 
                    ? const Color(0xFF667EEA).withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (log.photoUrls.isNotEmpty) _buildPhotos(),
                if (log.photoUrls.isNotEmpty)
                  const SizedBox(height: 16),
                Text(
                  log.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMetadata(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotos() {
    if (log.photoUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        child: _buildSinglePhoto(log.photoUrls.first, double.infinity, 120),
      );
    }

    if (log.photoUrls.length == 2) {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              child: _buildSinglePhoto(log.photoUrls[0], null, 100),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              child: _buildSinglePhoto(log.photoUrls[1], null, 100),
            ),
          ),
        ],
      );
    }

    // For 3+ photos, show first two and a "+N more" indicator
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: _buildSinglePhoto(log.photoUrls[0], null, 100),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: Stack(
              children: [
                _buildSinglePhoto(log.photoUrls[1], null, 100),
                if (log.photoUrls.length > 2)
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Center(
                      child: Text(
                        '+${log.photoUrls.length - 2}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSinglePhoto(String photoUrl, double? width, double height) {
    // Check if it's a file path (real photo) or asset path (placeholder)
    if (photoUrl.startsWith('/') || photoUrl.startsWith('file://')) {
      // Real photo from device
      return Image.file(
        File(photoUrl),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ImagePlaceholder(
            width: width,
            height: height,
            icon: Icons.broken_image,
            backgroundColor: Colors.grey[300],
          );
        },
      );
    } else {
      // Fallback to placeholder for asset paths or invalid paths
      return ImagePlaceholder(
        width: width,
        height: height,
        icon: Icons.photo,
        backgroundColor: Colors.grey[200],
      );
    }
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        if (log.mood != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA).withValues(alpha: 0.1),
                  const Color(0xFF764BA2).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF667EEA).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getMoodEmoji(log.mood!), style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  log.mood!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A1D29),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (log.weather != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA).withValues(alpha: 0.1),
                  const Color(0xFF764BA2).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF667EEA).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getWeatherEmoji(log.weather!), style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  log.weather!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A1D29),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        const Spacer(),
        if (onTap != null)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: const Color(0xFF667EEA),
            ),
          ),
      ],
    );
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'excited':
        return '🤩';
      case 'peaceful':
        return '😌';
      case 'tired':
        return '😴';
      case 'adventurous':
        return '🤠';
      default:
        return '😊';
    }
  }

  String _getWeatherEmoji(String weather) {
    switch (weather) {
      case 'sunny':
        return '☀️';
      case 'cloudy':
        return '☁️';
      case 'rainy':
        return '🌧️';
      case 'snowy':
        return '❄️';
      default:
        return '☀️';
    }
  }
}
