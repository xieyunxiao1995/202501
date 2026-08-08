import 'package:flutter/material.dart';

class LevelDefinition {
  const LevelDefinition({
    required this.number,
    required this.title,
    required this.goal,
    required this.seed,
    required this.difficulty,
    required this.targetTimeSeconds,
    required this.targetMoves,
  });

  final int number;
  final String title;
  final String goal;
  final int seed;
  final int difficulty;
  final int targetTimeSeconds;
  final int targetMoves;
}

class LevelChapter {
  const LevelChapter({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.symbol,
    required this.rewardTitle,
    required this.levels,
  });

  final int number;
  final String title;
  final String subtitle;
  final int color;
  final IconData icon;
  final String symbol;
  final String rewardTitle;
  final List<LevelDefinition> levels;
}

class LevelCatalog {
  const LevelCatalog._();

  static const levelsPerChapter = 20;
  static const totalLevels = 100;
  static const maxStarsPerLevel = 3;

  static final chapters = List<LevelChapter>.unmodifiable([
    _buildChapter(
      number: 1,
      title: 'Forest Journey',
      subtitle: 'Follow the green path and learn the rhythm of the table',
      color: 0xFF4D833F,
      icon: Icons.park_rounded,
      symbol: '🌲',
      rewardTitle: 'Forest Theme',
      start: 1,
      titles: _forestLevels,
    ),
    _buildChapter(
      number: 2,
      title: 'Royal Garden',
      subtitle: 'Plan one turn ahead through the palace gardens',
      color: 0xFF2F7C75,
      icon: Icons.local_florist_rounded,
      symbol: '👑',
      rewardTitle: 'Garden Card Back',
      start: 21,
      titles: _royalLevels,
    ),
    _buildChapter(
      number: 3,
      title: 'Midnight Cards',
      subtitle: 'Read the quiet table beneath the moon and stars',
      color: 0xFF354A87,
      icon: Icons.nightlight_round,
      symbol: '🌙',
      rewardTitle: 'Midnight Decoration',
      start: 41,
      titles: _midnightLevels,
    ),
    _buildChapter(
      number: 4,
      title: 'Ancient Castle',
      subtitle: 'Keep your plan steady beyond the stone gates',
      color: 0xFF625477,
      icon: Icons.account_balance_rounded,
      symbol: '🏰',
      rewardTitle: 'Castle Card Back',
      start: 61,
      titles: _castleLevels,
    ),
    _buildChapter(
      number: 5,
      title: 'Golden Kingdom',
      subtitle: 'Take the final road to the brightest table',
      color: 0xFF98712B,
      icon: Icons.workspace_premium_rounded,
      symbol: '✨',
      rewardTitle: 'Golden Table Decoration',
      start: 81,
      titles: _goldenLevels,
    ),
  ]);

  static Iterable<LevelDefinition> get levels =>
      chapters.expand((chapter) => chapter.levels);

  static LevelDefinition level(int number) =>
      levels.firstWhere((definition) => definition.number == number);

  static LevelChapter chapterForLevel(int levelNumber) {
    final safeNumber = levelNumber < 1
        ? 1
        : levelNumber > totalLevels
        ? totalLevels
        : levelNumber;
    return chapters[(safeNumber - 1) ~/ levelsPerChapter];
  }

  static int completedLevels(
    LevelChapter chapter,
    Map<int, int> completedStars,
  ) => chapter.levels
      .where((level) => (completedStars[level.number] ?? 0) > 0)
      .length;

  static int starsInChapter(
    LevelChapter chapter,
    Map<int, int> completedStars,
  ) => chapter.levels.fold(
    0,
    (total, level) => total + (completedStars[level.number] ?? 0).clamp(0, 3),
  );
}

LevelChapter _buildChapter({
  required int number,
  required String title,
  required String subtitle,
  required int color,
  required IconData icon,
  required String symbol,
  required String rewardTitle,
  required int start,
  required List<String> titles,
}) => LevelChapter(
  number: number,
  title: title,
  subtitle: subtitle,
  color: color,
  icon: icon,
  symbol: symbol,
  rewardTitle: rewardTitle,
  levels: List<LevelDefinition>.unmodifiable(
    List<LevelDefinition>.generate(titles.length, (index) {
      final levelNumber = start + index;
      final difficulty = number;
      return LevelDefinition(
        number: levelNumber,
        title: titles[index],
        goal: 'Complete the deal',
        seed: 100 + levelNumber,
        difficulty: difficulty,
        targetTimeSeconds: 240 - ((number - 1) * 20) - index,
        targetMoves: 120 - ((number - 1) * 8) - (index ~/ 4),
      );
    }),
  ),
);

const _forestLevels = <String>[
  'First Deal',
  'Open Path',
  'Color Switch',
  'Green Meadow',
  'Easy Crossing',
  'Lucky Turn',
  'Forest Gate',
  'Quiet Trail',
  'Sunlit Cards',
  'Roadside Inn',
  'Ivy Steps',
  'Hidden Bloom',
  'Rose Arch',
  'Garden Key',
  'Willow Bend',
  'Mossy Steps',
  'Orchard Turn',
  'Watering Well',
  'Secret Arbor',
  'Garden Crown',
];

const _royalLevels = <String>[
  'Drawbridge',
  'Marble Hall',
  'Royal Table',
  'Crown Room',
  'Knight\'s Turn',
  'Golden Stair',
  'Queen\'s Garden',
  'Bell Tower',
  'Castle Vault',
  'Royal Exit',
  'Moonlit Deal',
  'Hidden Hand',
  'Starlit Stack',
  'Midnight Turn',
  'Whispering Cards',
  'Shadow Path',
  'Silver Key',
  'Night Garden',
  'Last Secret',
  'Journey\'s End',
];

const _midnightLevels = <String>[
  'Moon Bridge',
  'Silver Shuffle',
  'Starry Stack',
  'Night Watch',
  'Blue Hour',
  'Comet Turn',
  'Quiet Orbit',
  'Moon Garden',
  'North Star',
  'Midnight Bell',
  'Lunar Gate',
  'Shadow Bloom',
  'Constellation',
  'Afterglow',
  'Dusk Crossing',
  'Velvet Sky',
  'Silver Lining',
  'Night Ferry',
  'Moonrise',
  'Midnight Cards',
];

const _castleLevels = <String>[
  'Stone Gate',
  'Old Courtyard',
  'Candle Hall',
  'Iron Bridge',
  'Hidden Stair',
  'Chamber Key',
  'Quiet Keep',
  'Tower Room',
  'Granite Turn',
  'Castle Watch',
  'Mosaic Floor',
  'Lantern Path',
  'Secret Courtyard',
  'Raven Door',
  'Ancient Table',
  'High Rampart',
  'Candle Crown',
  'Old Library',
  'Royal Crypt',
  'Castle Dawn',
];

const _goldenLevels = <String>[
  'Golden Gate',
  'Sunlit Vault',
  'Treasure Turn',
  'Amber Path',
  'Gilded Hall',
  'Crown Jewel',
  'Bright Crossing',
  'Golden Meadow',
  'Royal Treasure',
  'Sunrise Deal',
  'Gold Leaf',
  'Treasure Room',
  'Shining Stair',
  'Golden Compass',
  'Brilliant Table',
  'Crown Passage',
  'Sunstone',
  'Grand Vault',
  'Kingdom Gate',
  'Golden Kingdom',
];
