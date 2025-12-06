/// Camping tip question model
class CampingTip {
  final String id;
  final String question;
  final String emoji;
  final String category;
  final String difficulty;
  final int viewCount;

  const CampingTip({
    required this.id,
    required this.question,
    required this.emoji,
    required this.category,
    required this.difficulty,
    required this.viewCount,
  });
}

/// Camping tip categories
class TipCategory {
  static const String gear = 'gear';
  static const String setup = 'setup';
  static const String cooking = 'cooking';
  static const String weather = 'weather';
  static const String safety = 'safety';
  static const String location = 'location';
}

/// Difficulty levels
class TipDifficulty {
  static const String beginner = 'beginner';
  static const String intermediate = 'intermediate';
  static const String advanced = 'advanced';
}
