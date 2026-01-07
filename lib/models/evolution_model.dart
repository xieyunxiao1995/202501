import 'beast_model.dart';

class EvolutionRequirement {
  final int level;
  final int spiritCost;
  final int fleshCost;
  final List<String> requiredParts;
  final int minStatsTotal;

  EvolutionRequirement({
    required this.level,
    required this.spiritCost,
    required this.fleshCost,
    required this.requiredParts,
    required this.minStatsTotal,
  });

  bool canEvolve(Beast beast, int playerSpirit, int playerFlesh) {
    if (playerSpirit < spiritCost || playerFlesh < fleshCost) return false;

    final hasAllParts = requiredParts.every((part) => beast.parts.contains(part));
    if (!hasAllParts) return false;

    if (beast.stats.totalScore < minStatsTotal) return false;

    return true;
  }
}

class EvolutionPath {
  final String fromTier;
  final String toTier;
  final String name;
  final List<EvolutionRequirement> stages;

  EvolutionPath({
    required this.fromTier,
    required this.toTier,
    required this.name,
    required this.stages,
  });

  static final Map<String, EvolutionPath> paths = {
    '百年_to_千年': EvolutionPath(
      fromTier: '百年',
      toTier: '千年',
      name: '飞升之路',
      stages: [
        EvolutionRequirement(
          level: 1,
          spiritCost: 500,
          fleshCost: 100,
          requiredParts: [],
          minStatsTotal: 200,
        ),
      ],
    ),
    '千年_to_万年': EvolutionPath(
      fromTier: '千年',
      toTier: '万年',
      name: '化神之路',
      stages: [
        EvolutionRequirement(
          level: 1,
          spiritCost: 2000,
          fleshCost: 500,
          requiredParts: ['龙鳞', '凤羽'],
          minStatsTotal: 500,
        ),
      ],
    ),
  };
}
