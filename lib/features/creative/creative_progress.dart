import 'creative_mode.dart';

class CreativeProgress {
  CreativeProgress({
    Map<String, int> played = const <String, int>{},
    Map<String, int> wins = const <String, int>{},
    Map<String, int> bestTimes = const <String, int>{},
    Map<String, int> bestMoves = const <String, int>{},
    Map<String, int> highestScores = const <String, int>{},
    Map<String, int> bestTreasures = const <String, int>{},
    Map<String, int> bestStars = const <String, int>{},
    this.treasuresFoundTotal = 0,
    this.lastPlayed,
  }) : played = Map.unmodifiable(played),
       wins = Map.unmodifiable(wins),
       bestTimes = Map.unmodifiable(bestTimes),
       bestMoves = Map.unmodifiable(bestMoves),
       highestScores = Map.unmodifiable(highestScores),
       bestTreasures = Map.unmodifiable(bestTreasures),
       bestStars = Map.unmodifiable(bestStars);

  factory CreativeProgress.initial() => CreativeProgress();

  final Map<String, int> played;
  final Map<String, int> wins;
  final Map<String, int> bestTimes;
  final Map<String, int> bestMoves;
  final Map<String, int> highestScores;
  final Map<String, int> bestTreasures;
  final Map<String, int> bestStars;
  final int treasuresFoundTotal;
  final String? lastPlayed;

  int playedFor(CreativeModeType mode) => played[mode.name] ?? 0;

  int winsFor(CreativeModeType mode) => wins[mode.name] ?? 0;

  int? bestTimeFor(CreativeModeType mode) => bestTimes[mode.name];

  int? bestMovesFor(CreativeModeType mode) => bestMoves[mode.name];

  int highestScoreFor(CreativeModeType mode) => highestScores[mode.name] ?? 0;

  int bestTreasuresFor(CreativeModeType mode) => bestTreasures[mode.name] ?? 0;

  int bestStarsFor(CreativeModeType mode) => bestStars[mode.name] ?? 0;

  CreativeProgress recordPlay(CreativeModeType mode) {
    final updatedPlayed = Map<String, int>.from(played);
    updatedPlayed[mode.name] = playedFor(mode) + 1;
    return CreativeProgress(
      played: updatedPlayed,
      wins: wins,
      bestTimes: bestTimes,
      bestMoves: bestMoves,
      highestScores: highestScores,
      bestTreasures: bestTreasures,
      bestStars: bestStars,
      treasuresFoundTotal: treasuresFoundTotal,
      lastPlayed: mode.name,
    );
  }

  CreativeProgress recordWin(
    CreativeModeType mode, {
    required int elapsedSeconds,
    int? moves,
    int score = 0,
    int treasuresFound = 0,
    int stars = 0,
  }) {
    final key = mode.name;
    final updatedWins = Map<String, int>.from(wins);
    updatedWins[key] = winsFor(mode) + 1;

    final updatedBestTimes = Map<String, int>.from(bestTimes);
    final previousBestTime = bestTimeFor(mode);
    if (previousBestTime == null || elapsedSeconds < previousBestTime) {
      updatedBestTimes[key] = elapsedSeconds;
    }

    final updatedBestMoves = Map<String, int>.from(bestMoves);
    final previousBestMoves = bestMovesFor(mode);
    if (moves != null &&
        moves > 0 &&
        (previousBestMoves == null || moves < previousBestMoves)) {
      updatedBestMoves[key] = moves;
    }

    final updatedHighestScores = Map<String, int>.from(highestScores);
    if (score > highestScoreFor(mode)) updatedHighestScores[key] = score;

    final updatedBestTreasures = Map<String, int>.from(bestTreasures);
    if (treasuresFound > bestTreasuresFor(mode)) {
      updatedBestTreasures[key] = treasuresFound;
    }

    final updatedBestStars = Map<String, int>.from(bestStars);
    if (stars > bestStarsFor(mode)) updatedBestStars[key] = stars;

    return CreativeProgress(
      played: played,
      wins: updatedWins,
      bestTimes: updatedBestTimes,
      bestMoves: updatedBestMoves,
      highestScores: updatedHighestScores,
      bestTreasures: updatedBestTreasures,
      bestStars: updatedBestStars,
      treasuresFoundTotal:
          treasuresFoundTotal + (treasuresFound < 0 ? 0 : treasuresFound),
      lastPlayed: mode.name,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'played': played,
    'wins': wins,
    'bestTimes': bestTimes,
    'bestMoves': bestMoves,
    'highestScores': highestScores,
    'bestTreasures': bestTreasures,
    'bestStars': bestStars,
    'treasuresFoundTotal': treasuresFoundTotal,
    'lastPlayed': lastPlayed,
  };

  factory CreativeProgress.fromJson(Map<String, dynamic> json) =>
      CreativeProgress(
        played: _intMap(json['played']),
        wins: _intMap(json['wins']),
        bestTimes: _intMap(json['bestTimes']),
        bestMoves: _intMap(json['bestMoves']),
        highestScores: _intMap(json['highestScores']),
        bestTreasures: _intMap(json['bestTreasures']),
        bestStars: _intMap(json['bestStars']),
        treasuresFoundTotal:
            (json['treasuresFoundTotal'] as num?)?.toInt() ?? 0,
        lastPlayed: json['lastPlayed'] is String
            ? json['lastPlayed'] as String
            : null,
      );

  @override
  bool operator ==(Object other) =>
      other is CreativeProgress &&
      _mapEquals(played, other.played) &&
      _mapEquals(wins, other.wins) &&
      _mapEquals(bestTimes, other.bestTimes) &&
      _mapEquals(bestMoves, other.bestMoves) &&
      _mapEquals(highestScores, other.highestScores) &&
      _mapEquals(bestTreasures, other.bestTreasures) &&
      _mapEquals(bestStars, other.bestStars) &&
      treasuresFoundTotal == other.treasuresFoundTotal &&
      lastPlayed == other.lastPlayed;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(played.entries),
    Object.hashAll(wins.entries),
    Object.hashAll(bestTimes.entries),
    Object.hashAll(bestMoves.entries),
    Object.hashAll(highestScores.entries),
    Object.hashAll(bestTreasures.entries),
    Object.hashAll(bestStars.entries),
    treasuresFoundTotal,
    lastPlayed,
  );

  static Map<String, int> _intMap(Object? raw) {
    if (raw is! Map) return <String, int>{};
    final result = <String, int>{};
    for (final entry in raw.entries) {
      if (entry.key is String && entry.value is num) {
        result[entry.key as String] = (entry.value as num).toInt();
      }
    }
    return result;
  }

  static bool _mapEquals(Map<String, int> first, Map<String, int> second) =>
      first.length == second.length &&
      first.entries.every((entry) => second[entry.key] == entry.value);
}
