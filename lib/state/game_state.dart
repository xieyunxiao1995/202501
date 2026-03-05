import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../constants.dart';

String generateUuid() {
  return DateTime.now().millisecondsSinceEpoch.toRadixString(36) +
      _randomString(5);
}

String _randomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(
    length,
    (index) => chars[DateTime.now().millisecond % chars.length],
  ).join();
}

String formatNumber(int num) {
  if (num >= 1000000) {
    return '${(num / 1000000).toStringAsFixed(2)}M';
  } else if (num >= 1000) {
    return '${(num / 1000).toStringAsFixed(1)}K';
  }
  return num.toString();
}

class GameState {
  void addGold(int amount) => gold += amount;
  void addExp(int amount) => exp += amount;
  int gold;
  int exp;
  int playerLevel;
  int vipLevel;

  List<Hero> inventory;
  List<String> team;

  // アイテムバックパック（素材、券など）
  Map<String, int> materials;

  GameState({
    this.gold = 5000,
    this.exp = 1000000,
    this.playerLevel = 120,
    this.vipLevel = 13,
    List<Hero>? inventory,
    List<String>? team,
    Map<String, int>? materials,
  }) : inventory = inventory ?? [],
       team = team ?? [],
       materials = materials ?? {} {
    if (this.inventory.isEmpty) {
      final starterHero = HERO_TEMPLATES[0].createInstance(
        uid: generateUuid(),
        level: 70,
        stars: 5,
      );
      starterHero.hp = 286521;
      starterHero.atk = 19011;
      starterHero.def = 1652;
      starterHero.spd = 120;
      this.inventory.add(starterHero);
      this.team.add(starterHero.uid);
    }

    // 初心者向け初期素材を付与
    if (this.materials.isEmpty) {
      this.materials = {'初心者の短剣': 1, '小型経験瓶': 5};
    }
  }

  int get totalCombatPower {
    return team.fold<int>(0, (sum, uid) {
      final hero = inventory.firstWhere(
        (h) => h.uid == uid,
        orElse: () => Hero(
          uid: '',
          templateId: '',
          name: '',
          title: '',
          rarity: RarityType.R,
          faction: FactionType.fire,
          heroClass: HeroClass.warrior,
          level: 1,
          stars: 1,
          hp: 0,
          atk: 0,
          def: 0,
          spd: 0,
          skills: [],
        ),
      );
      return sum + hero.combatPower.floor();
    });
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gold', gold);
    await prefs.setInt('exp', exp);
    await prefs.setInt('playerLevel', playerLevel);
    await prefs.setInt('vipLevel', vipLevel);
    await prefs.setStringList('team', team);

    final heroesJson = inventory.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList('inventory', heroesJson);

    await prefs.setString('materials', jsonEncode(materials));
  }

  static Future<GameState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final gold = prefs.getInt('gold');
    final exp = prefs.getInt('exp');
    final playerLevel = prefs.getInt('playerLevel');
    final vipLevel = prefs.getInt('vipLevel');
    final team = prefs.getStringList('team') ?? [];

    final inventoryJson = prefs.getStringList('inventory') ?? [];
    final inventory = inventoryJson
        .map((json) => Hero.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();

    final materialsString = prefs.getString('materials');
    Map<String, int> materials = {};
    if (materialsString != null) {
      materials = Map<String, int>.from(jsonDecode(materialsString));
    }

    if (gold == null) return GameState();

    return GameState(
      gold: gold,
      exp: exp ?? 1000000,
      playerLevel: playerLevel ?? 120,
      vipLevel: vipLevel ?? 13,
      inventory: inventory,
      team: team,
      materials: materials,
    );
  }

  bool spendGold(int amount) {
    if (gold >= amount) {
      gold -= amount;
      return true;
    }
    return false;
  }

  bool spendExp(int amount) {
    if (exp >= amount) {
      exp -= amount;
      return true;
    }
    return false;
  }

  // --- アイテム方法 ---
  void addMaterial(String name, int amount) {
    materials[name] = (materials[name] ?? 0) + amount;
  }

  bool spendMaterial(String name, int amount) {
    if ((materials[name] ?? 0) >= amount) {
      materials[name] = materials[name]! - amount;
      if (materials[name] == 0) materials.remove(name);
      return true;
    }
    return false;
  }

  void addHero(Hero hero) => inventory.add(hero);
  void addHeroes(List<Hero> heroes) => inventory.addAll(heroes);
  void removeHero(String uid) {
    inventory.removeWhere((h) => h.uid == uid);
    team.remove(uid);
  }

  Hero? getHero(String uid) {
    try {
      return inventory.firstWhere((h) => h.uid == uid);
    } catch (e) {
      return null;
    }
  }

  void updateHero(Hero hero) {
    final index = inventory.indexWhere((h) => h.uid == hero.uid);
    if (index != -1) inventory[index] = hero;
  }

  bool addTeamMember(String uid) {
    if (team.length >= 5 ||
        team.contains(uid) ||
        !inventory.any((h) => h.uid == uid))
      return false;
    team.add(uid);
    return true;
  }

  void removeTeamMember(String uid) => team.remove(uid);
  bool toggleTeamMember(String uid) {
    if (team.contains(uid)) {
      team.remove(uid);
      return false;
    } else {
      return addTeamMember(uid);
    }
  }

  List<Hero> getTeamHeroes() =>
      team.map((uid) => inventory.firstWhere((h) => h.uid == uid)).toList();
}
