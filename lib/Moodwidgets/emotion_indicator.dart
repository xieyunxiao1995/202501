import 'package:flutter/material.dart';
import '../Moodmodels/emotion_tag.dart';

class EmotionIndicator extends StatelessWidget {
  final List<String> emotionTags;
  final bool isLarge;

  const EmotionIndicator({
    super.key,
    required this.emotionTags,
    this.isLarge = false,
  });

  Color _getEmotionColor(String emotionName) {
    final tag = EmotionTag.getTagByName(emotionName);
    if (tag != null) {
      return Color(int.parse('0xFF${tag.color.substring(1)}'));
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (emotionTags.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = emotionTags.take(3).map((tag) => _getEmotionColor(tag)).toList();

    return Container(
      width: isLarge ? 80 : 60,
      height: isLarge ? 80 : 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _getEmotionSymbol(emotionTags.first),
          style: TextStyle(
            fontSize: isLarge ? 32 : 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getEmotionSymbol(String emotionName) {
    switch (emotionName.toLowerCase()) {
      case 'peaceful':
        return '☮';
      case 'joy':
        return '☀️';
      case 'anxiety':
        return '😰';
      case 'hope':
        return '✨';
      case 'love':
        return '💖';
      case 'energy':
        return '⚡';
      case 'tired':
        return '😴';
      case 'grateful':
        return '🙏';
      case 'confused':
        return '😵';
      case 'accomplished':
        return '🎯';
      default:
        return '💙';
    }
  }
}
