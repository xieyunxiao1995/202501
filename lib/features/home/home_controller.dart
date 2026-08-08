import 'package:flutter/material.dart';

import '../levels/level_catalog.dart';

class GameStatistics {
  const GameStatistics({
    this.gamesPlayed = 0,
    this.totalWins = 0,
    this.fastestWinSeconds,
    this.totalMoves = 0,
  });
  final int gamesPlayed;
  final int totalWins;
  final int? fastestWinSeconds;
  final int totalMoves;

  GameStatistics recordGameStart() => GameStatistics(
    gamesPlayed: gamesPlayed + 1,
    totalWins: totalWins,
    fastestWinSeconds: fastestWinSeconds,
    totalMoves: totalMoves,
  );

  GameStatistics recordWin({required int elapsedSeconds, required int moves}) =>
      GameStatistics(
        gamesPlayed: gamesPlayed,
        totalWins: totalWins + 1,
        fastestWinSeconds:
            fastestWinSeconds == null || elapsedSeconds < fastestWinSeconds!
            ? elapsedSeconds
            : fastestWinSeconds,
        totalMoves: totalMoves + moves,
      );

  Map<String, dynamic> toJson() => {
    'gamesPlayed': gamesPlayed,
    'totalWins': totalWins,
    'fastestWinSeconds': fastestWinSeconds,
    'totalMoves': totalMoves,
  };
  factory GameStatistics.fromJson(Map<String, dynamic>? json) => GameStatistics(
    gamesPlayed: json?['gamesPlayed'] as int? ?? 0,
    totalWins: json?['totalWins'] as int? ?? 0,
    fastestWinSeconds: json?['fastestWinSeconds'] as int?,
    totalMoves: json?['totalMoves'] as int? ?? 0,
  );
}

class ThemeOption {
  const ThemeOption(this.id, this.name, this.tableColor, this.backgroundAsset);
  final String id;
  final String name;
  final int tableColor;
  final String backgroundAsset;
  static const all = <ThemeOption>[
    ThemeOption('emerald', 'Emerald Forest', 0xFF12331E, 'assets/背景/Bg1.png'),
    ThemeOption('royal', 'Royal Blue', 0xFF122A55, 'assets/背景/Bg2.png'),
    ThemeOption('casino', 'Vintage Casino', 0xFF4B1F1A, 'assets/背景/Bg3.png'),
    ThemeOption('midnight', 'Midnight Sky', 0xFF151A36, 'assets/背景/Bg4.png'),
  ];
  static ThemeOption byId(String id) =>
      all.firstWhere((theme) => theme.id == id, orElse: () => all.first);
}

class DailyChallenge {
  const DailyChallenge({
    required this.date,
    required this.seed,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.accentColor,
    required this.icon,
  });

  final DateTime date;
  final int seed;
  final String title;
  final String subtitle;
  final int difficulty;
  final int accentColor;
  final IconData icon;

  factory DailyChallenge.forDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final presentation =
        _dailyPresentations[(normalized.year +
                normalized.month +
                normalized.day) %
            _dailyPresentations.length];
    return DailyChallenge(
      date: normalized,
      seed: date.year * 10000 + date.month * 100 + date.day,
      title: presentation.title,
      subtitle: presentation.subtitle,
      difficulty: presentation.difficulty,
      accentColor: presentation.accentColor,
      icon: presentation.icon,
    );
  }
}

class _DailyPresentation {
  const _DailyPresentation({
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.accentColor,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final int difficulty;
  final int accentColor;
  final IconData icon;
}

const _dailyPresentations = <_DailyPresentation>[
  _DailyPresentation(
    title: 'Royal Morning Deal',
    subtitle: 'A bright opening hand for a calm start.',
    difficulty: 2,
    accentColor: 0xFF6D8F38,
    icon: Icons.wb_sunny_rounded,
  ),
  _DailyPresentation(
    title: 'Forest Focus',
    subtitle: 'Take your time and find the quiet path.',
    difficulty: 1,
    accentColor: 0xFF32735B,
    icon: Icons.park_rounded,
  ),
  _DailyPresentation(
    title: 'Golden Table',
    subtitle: 'A sharper deal for a little extra sparkle.',
    difficulty: 3,
    accentColor: 0xFF9A6D24,
    icon: Icons.auto_awesome_rounded,
  ),
  _DailyPresentation(
    title: 'Moonlit Shuffle',
    subtitle: 'A thoughtful evening hand under silver light.',
    difficulty: 2,
    accentColor: 0xFF4C528F,
    icon: Icons.nightlight_round,
  ),
  _DailyPresentation(
    title: 'Quiet Garden',
    subtitle: 'A gentle route through today\'s green table.',
    difficulty: 1,
    accentColor: 0xFF477D4D,
    icon: Icons.local_florist_rounded,
  ),
];

class PlayerProgress {
  const PlayerProgress({
    required this.completedStars,
    required this.selectedTheme,
    required this.ownedThemes,
    required this.statistics,
    this.levelBestTimes = const <int, int>{},
    this.levelBestMoves = const <int, int>{},
  });

  final Map<int, int> completedStars;
  final String selectedTheme;
  final Set<String> ownedThemes;
  final GameStatistics statistics;
  final Map<int, int> levelBestTimes;
  final Map<int, int> levelBestMoves;

  factory PlayerProgress.initial() => const PlayerProgress(
    completedStars: <int, int>{},
    selectedTheme: 'emerald',
    ownedThemes: {'emerald', 'royal', 'casino', 'midnight'},
    statistics: GameStatistics(),
    levelBestTimes: <int, int>{},
    levelBestMoves: <int, int>{},
  );

  int get unlockedLevel {
    var next = 1;
    while (next < LevelCatalog.totalLevels &&
        completedStars.containsKey(next)) {
      next++;
    }
    return next;
  }

  LevelChapter get currentChapter =>
      LevelCatalog.chapterForLevel(unlockedLevel);
  double get winRate => statistics.gamesPlayed == 0
      ? 0
      : statistics.totalWins / statistics.gamesPlayed;

  PlayerProgress copyWith({
    Map<int, int>? completedStars,
    String? selectedTheme,
    Set<String>? ownedThemes,
    GameStatistics? statistics,
    Map<int, int>? levelBestTimes,
    Map<int, int>? levelBestMoves,
  }) => PlayerProgress(
    completedStars: completedStars ?? this.completedStars,
    selectedTheme: selectedTheme ?? this.selectedTheme,
    ownedThemes: ownedThemes ?? this.ownedThemes,
    statistics: statistics ?? this.statistics,
    levelBestTimes: levelBestTimes ?? this.levelBestTimes,
    levelBestMoves: levelBestMoves ?? this.levelBestMoves,
  );

  PlayerProgress recordGameStart() =>
      copyWith(statistics: statistics.recordGameStart());

  PlayerProgress recordWin({
    required int elapsedSeconds,
    required int moves,
    int? level,
    int stars = 0,
  }) {
    final updated = Map<int, int>.from(completedStars);
    final updatedBestTimes = Map<int, int>.from(levelBestTimes);
    final updatedBestMoves = Map<int, int>.from(levelBestMoves);
    if (level != null) {
      updated[level] = (updated[level] ?? 0) > stars ? updated[level]! : stars;
      if (elapsedSeconds > 0 &&
          (updatedBestTimes[level] == null ||
              elapsedSeconds < updatedBestTimes[level]!)) {
        updatedBestTimes[level] = elapsedSeconds;
      }
      if (moves > 0 &&
          (updatedBestMoves[level] == null ||
              moves < updatedBestMoves[level]!)) {
        updatedBestMoves[level] = moves;
      }
    }
    return copyWith(
      completedStars: updated,
      levelBestTimes: updatedBestTimes,
      levelBestMoves: updatedBestMoves,
      statistics: statistics.recordWin(
        elapsedSeconds: elapsedSeconds,
        moves: moves,
      ),
    );
  }

  PlayerProgress completeLevel(int level, {required int stars}) =>
      recordWin(elapsedSeconds: 0, moves: 0, level: level, stars: stars);

  PlayerProgress selectTheme(String id) {
    if (!ThemeOption.all.any((theme) => theme.id == id)) return this;
    return copyWith(selectedTheme: id, ownedThemes: {...ownedThemes, id});
  }

  Map<String, dynamic> toJson() => {
    'completedStars': completedStars.map(
      (key, value) => MapEntry('$key', value),
    ),
    'selectedTheme': selectedTheme,
    'ownedThemes': ownedThemes.toList(),
    'statistics': statistics.toJson(),
    'levelBestTimes': _encodeLevelStats(levelBestTimes),
    'levelBestMoves': _encodeLevelStats(levelBestMoves),
  };

  factory PlayerProgress.fromJson(Map<String, dynamic> json) => PlayerProgress(
    completedStars:
        ((json['completedStars'] as Map?)?.cast<String, dynamic>() ??
                const <String, dynamic>{})
            .map((key, value) => MapEntry(int.parse(key), value as int)),
    selectedTheme: json['selectedTheme'] as String? ?? 'emerald',
    ownedThemes: {
      ...ThemeOption.all.map((theme) => theme.id),
      ...((json['ownedThemes'] as List?)?.cast<String>() ?? const ['emerald']),
    },
    statistics: GameStatistics.fromJson(
      (json['statistics'] as Map?)?.cast<String, dynamic>(),
    ),
    levelBestTimes: _decodeLevelStats(json['levelBestTimes']),
    levelBestMoves: _decodeLevelStats(json['levelBestMoves']),
  );
}

Map<String, int> _encodeLevelStats(Map<int, int> stats) =>
    stats.map((key, value) => MapEntry('$key', value));

Map<int, int> _decodeLevelStats(Object? raw) {
  final map = (raw as Map?)?.cast<String, dynamic>();
  if (map == null) return <int, int>{};
  return map.map((key, value) => MapEntry(int.parse(key), value as int));
}
