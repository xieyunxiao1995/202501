import 'enums.dart';

class LevelConfig {
  final Biome biome;
  final int minPower;
  final int maxPower;
  final List<String> monsterPool;
  final String? bossName;
  final GameElement? bossElement;
  final double trapChance;
  final double shopChance;

  const LevelConfig({
    required this.biome,
    required this.minPower,
    required this.maxPower,
    required this.monsterPool,
    this.bossName,
    this.bossElement,
    this.trapChance = 0.15,
    this.shopChance = 0.0,
  });
}
