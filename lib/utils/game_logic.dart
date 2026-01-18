import 'dart:math';
import '../constants.dart';
import '../models/card_data.dart';
import '../models/enums.dart';
import '../data/levels_data.dart';
import '../models/alchemy_model.dart';
import '../data/alchemy_data.dart';
import '../data/events_data.dart';

Biome _getBiome(int floor) {
  if (floor <= 10) return Biome.forest;
  if (floor <= 20) return Biome.volcano;
  if (floor <= 30) return Biome.ocean;
  
  // Endless Mode Logic
  if (floor > 30) {
    // Cycle every 10 floors: 31-40 Forest, 41-50 Volcano, 51-60 Ocean
    final cycle = ((floor - 31) ~/ 10) % 3;
    if (cycle == 0) return Biome.forest;
    if (cycle == 1) return Biome.volcano;
    if (cycle == 2) return Biome.ocean;
  }
  
  return Biome.void_;
}

String getBiomeName(int floor) {
  final biome = _getBiome(floor);
  switch (biome) {
    case Biome.forest: return "迷雾之林";
    case Biome.volcano: return "炽热荒原";
    case Biome.ocean: return "深海幽谷";
    case Biome.void_: return "混沌虚空";
  }
}

String uid() {
  final random = Random();
  return DateTime.now().millisecondsSinceEpoch.toString() +
      random.nextInt(10000).toString();
}

GameElement _getMonsterElement(Biome biome) {
  final rand = Random().nextDouble();
  // 60% chance for Biome element, 20% counter, 20% random
  if (rand < 0.6) {
    switch (biome) {
      case Biome.forest: return GameElement.wood;
      case Biome.volcano: return GameElement.fire;
      case Biome.ocean: return GameElement.water;
      case Biome.void_: return GameElement.values[Random().nextInt(GameElement.values.length)];
    }
  } else if (rand < 0.8) {
    // Secondary element
    switch (biome) {
      case Biome.forest: return GameElement.earth;
      case Biome.volcano: return GameElement.metal;
      case Biome.ocean: return GameElement.wood;
      case Biome.void_: return GameElement.none;
    }
  }
  return GameElement.none;
}

CardData generateSingleCard(int floor, {bool excludeBoss = false, bool forcePortal = false}) {
  final random = Random();
  final biome = _getBiome(floor);
  final config = biomeConfigs[biome]!;
  
  final isBossFloor = floor % 10 == 0; // Boss every 10 floors
  
  // Use config power ranges
  final basePower = config.minPower + (floor * 1.5);
  final powerVariance = (config.maxPower - config.minPower) + floor;

  if (forcePortal) {
    return CardData(
      id: uid(),
      type: CardType.portal,
      value: 0,
      isFlipped: false,
      name: isBossFloor ? "领主传送门" : "大荒传送门",
      icon: "🌀",
      rarity: Rarity.epic,
    );
  }

  final rand = random.nextDouble();

  // Alchemy Material Spawn (10% Chance, higher in biomes)
  if (rand < 0.10) {
    // Determine possible materials based on biome
    List<AlchemyMaterial> possibleMaterials = [];
    if (biome == Biome.forest) {
      possibleMaterials = allMaterials.where((m) => m.type == MaterialType.herb).toList();
    } else if (biome == Biome.volcano) {
      possibleMaterials = allMaterials.where((m) => m.type == MaterialType.ore).toList();
    } else if (biome == Biome.ocean) {
      possibleMaterials = allMaterials.where((m) => m.type == MaterialType.essence).toList(); // Essence in Ocean
    } else {
      possibleMaterials = allMaterials; // Void/Mixed
    }
    
    // Fallback if empty (shouldn't happen with current data)
    if (possibleMaterials.isEmpty) possibleMaterials = allMaterials;

    final mat = possibleMaterials[random.nextInt(possibleMaterials.length)];
    
    // Rarity check (Simple)
    if (mat.rarity == Rarity.legendary && random.nextDouble() > 0.05) {
       // Reroll if legendary but failed roll, fallback to common
       // Actually, let's just pick one.
    }

    return CardData(
      id: uid(),
      type: CardType.material,
      value: 0,
      isFlipped: false,
      name: mat.name,
      icon: mat.icon,
      rarity: mat.rarity,
      description: mat.id, // Store ID in description for pickup logic
    );
  }

  if (rand < 0.18) {
    // Special Objects: Key, Chest, Shrine
    final subRand = random.nextDouble();
    if (subRand < 0.35) {
      return CardData(
          id: uid(),
          type: CardType.key,
          value: 1,
          isFlipped: false,
          name: "古旧铜钥",
          icon: "🗝️",
          rarity: Rarity.rare);
    } else if (subRand < 0.65) {
      final val = 100 + (floor * 20);
      return CardData(
          id: uid(),
          type: CardType.chest,
          value: val,
          isFlipped: false,
          name: "山海秘藏",
          icon: "🔒",
          rarity: Rarity.epic);
    } else {
      return CardData(
          id: uid(),
          type: CardType.shrine,
          value: 0,
          isFlipped: false,
          name: "远古祭坛",
          icon: "⛩️",
          rarity: Rarity.rare);
    }
  } else if (rand < (0.08 + config.trapChance)) {
    // TRAP
    final damage = 10 + (floor * 2);
    return CardData(
      id: uid(),
      type: CardType.trap,
      value: damage,
      isFlipped: false,
      name: trapNames[random.nextInt(trapNames.length)],
      icon: "⚠️",
      rarity: Rarity.common,
    );
  } else if (rand < 0.14) {
    // Event (4% Chance)
    final event = allEvents[random.nextInt(allEvents.length)];
    return CardData(
      id: uid(),
      type: CardType.event,
      value: 0,
      isFlipped: false,
      name: "大荒奇遇",
      icon: "📜", // Or event.icon if revealed? Let's keep it mysterious until flipped? Or just generic scroll.
      rarity: Rarity.rare,
      description: event.id, // Store event ID
    );
  } else if (rand < 0.29) {
    // Weapon
    final val = basePower + (random.nextDouble() * powerVariance);
    final el = random.nextDouble() < 0.3 ? _getMonsterElement(biome) : GameElement.none;
    return CardData(
      id: uid(),
      type: CardType.weapon,
      value: val.floor(),
      isFlipped: false,
      name: weaponNames[min(floor ~/ 3, weaponNames.length - 1)],
      icon: "⚔️",
      rarity: Rarity.common,
      element: el,
    );
  } else if (rand < 0.39) {
    // Shield
    final val = 10 + (floor * 5);
    return CardData(
      id: uid(),
      type: CardType.shield,
      value: val,
      isFlipped: false,
      name: shieldNames[min(floor ~/ 3, shieldNames.length - 1)],
      icon: "🛡️",
      rarity: Rarity.common,
    );
  } else if (rand < 0.52) {
    // Potion
    final isLarge = random.nextDouble() > 0.8;
    return CardData(
      id: uid(),
      type: CardType.potion,
      value: isLarge ? 50 + (floor * 5) : 20 + (floor * 2),
      isFlipped: false,
      name: isLarge ? "大回元丹" : "回元丹",
      icon: isLarge ? "🍷" : "🧪",
      rarity: isLarge ? Rarity.rare : Rarity.common,
    );
  } else if (rand < 0.62) {
    // Treasure
    final val = 25 + (floor * 10);
    return CardData(
      id: uid(),
      type: CardType.treasure,
      value: val,
      isFlipped: false,
      name: "灵石",
      icon: "💰",
      rarity: Rarity.common,
    );
  } else {
    // Monster
    final isElite = random.nextDouble() > 0.85;
    int monsterPower = (basePower + (random.nextDouble() * powerVariance)).floor();

    Affix affix = Affix.none;
    String namePrefix = "";

    // Affix Logic (Floor 3+)
    if (floor >= 2 && random.nextDouble() > 0.65) {
      final roll = random.nextDouble();
      if (roll < 0.3) {
        affix = Affix.heavy;
        monsterPower = (monsterPower * 1.3).floor();
        namePrefix = "巨力·";
      } else if (roll < 0.6) {
        affix = Affix.sharp;
        namePrefix = "锐利·";
      } else if (roll < 0.75) {
        affix = Affix.toxic;
        namePrefix = "剧毒·";
      } else if (roll < 0.9) {
        affix = Affix.burning; 
        namePrefix = "烈焰·";
      } else {
        affix = Affix.cursed;
        namePrefix = "诅咒·";
      }
    }

    if (isElite) {
      monsterPower = (monsterPower * 1.5).floor();
      namePrefix = "大妖·$namePrefix";
    }

    // Enemy Type Logic
    EnemyType enemyType = EnemyType.standard;
    String typeIcon = isElite ? "💀" : "👿";
    int maxHp = 0;
    int currentHp = 0;

    if (!isElite && random.nextDouble() < 0.4) {
      final typeRoll = random.nextDouble();
      if (typeRoll < 0.33) {
        enemyType = EnemyType.ranged;
        typeIcon = "🏹";
        namePrefix = "${namePrefix}影袭";
        monsterPower = (monsterPower * 0.9).floor();
      } else if (typeRoll < 0.66) {
        enemyType = EnemyType.tank;
        typeIcon = "🐢";
        namePrefix = "${namePrefix}玄甲";
        monsterPower = (monsterPower * 1.2).floor();
        maxHp = 1;
        currentHp = 1;
      } else {
        enemyType = EnemyType.summoner;
        typeIcon = "🧙";
        namePrefix = "${namePrefix}祝师";
        monsterPower = (monsterPower * 0.8).floor();
      }
    }

    // Biome Logic for Name & Element
    final names = config.monsterPool;
    final nameBase = names[random.nextInt(names.length)];
    final element = _getMonsterElement(biome);

    if (element == GameElement.fire) typeIcon = "🔥";
    if (element == GameElement.water) typeIcon = "💧";
    if (element == GameElement.wood) typeIcon = "🌲";
    if (element == GameElement.metal) typeIcon = "🤖";
    if (element == GameElement.earth) typeIcon = "🗿";

    return CardData(
      id: uid(),
      type: CardType.monster,
      value: monsterPower,
      maxHp: maxHp,
      currentHp: currentHp,
      enemyType: enemyType,
      isFlipped: false,
      name: "$namePrefix$nameBase",
      icon: typeIcon,
      rarity: isElite ? Rarity.rare : Rarity.common,
      isBoss: false,
      affix: affix,
      element: element,
    );
  }
}

List<CardData> generateLevel(int floor) {
  final List<CardData> cards = [];
  final random = Random();
  final isBossFloor = floor % 10 == 0; // Boss every 10 floors now
  final biome = _getBiome(floor);
  final config = biomeConfigs[biome]!;

  final basePower = config.minPower + (floor * 1.5);

  // 1. Portal (Always present)
  cards.add(generateSingleCard(floor, forcePortal: true));

  // 2. Boss (If boss floor)
  if (isBossFloor) {
    final bossName = config.bossName ?? "虚空之主";
    
    // Boss element
    GameElement bossElement = config.bossElement ?? GameElement.none;
    if (bossElement == GameElement.none && biome == Biome.void_) {
        bossElement = GameElement.values[Random().nextInt(GameElement.values.length)];
    }

    cards.add(CardData(
      id: uid(),
      type: CardType.monster,
      value: (basePower * 3.5).floor(),
      isFlipped: false,
      name: bossName,
      icon: "👹",
      rarity: Rarity.legendary,
      isBoss: true,
      affix: Affix.none,
      element: bossElement,
    ));
  }

  // 3. Fill Grid
  final cardsToGen = gridSize - cards.length;
  for (int i = 0; i < cardsToGen; i++) {
    cards.add(generateSingleCard(floor, excludeBoss: true));
  }

  // 4. Shuffle
  cards.shuffle(random);
  
  return cards;
}

bool isElementCounter(GameElement atk, GameElement def) {
  if (atk == GameElement.metal && def == GameElement.wood) return true;
  if (atk == GameElement.wood && def == GameElement.earth) return true;
  if (atk == GameElement.earth && def == GameElement.water) return true;
  if (atk == GameElement.water && def == GameElement.fire) return true;
  if (atk == GameElement.fire && def == GameElement.metal) return true;
  return false;
}
