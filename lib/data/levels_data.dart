import '../models/level_config.dart';
import '../models/enums.dart';

const Map<Biome, LevelConfig> biomeConfigs = {
  Biome.forest: LevelConfig(
    biome: Biome.forest,
    minPower: 3,
    maxPower: 10,
    monsterPool: ["狰", "狡", "蛊雕", "诸犍", "颙"],
    bossName: "九尾狐",
    bossElement: GameElement.wood,
    trapChance: 0.15,
  ),
  Biome.volcano: LevelConfig(
    biome: Biome.volcano,
    minPower: 10,
    maxPower: 25,
    monsterPool: ["毕方", "天狗", "祸斗", "火鼠", "赤眼猪妖"],
    bossName: "夔牛",
    bossElement: GameElement.fire,
    trapChance: 0.20,
  ),
  Biome.ocean: LevelConfig(
    biome: Biome.ocean,
    minPower: 25,
    maxPower: 45,
    monsterPool: ["旋龟", "长右", "化蛇", "横公鱼", "虎蛟"],
    bossName: "相柳",
    bossElement: GameElement.water,
    trapChance: 0.25,
  ),
  Biome.void_: LevelConfig(
    biome: Biome.void_,
    minPower: 50,
    maxPower: 100,
    monsterPool: ["穷奇", "梼杌", "饕餮", "混沌"],
    bossName: "烛龙",
    bossElement: GameElement.none, // Random in logic
    trapChance: 0.30,
  ),
};
