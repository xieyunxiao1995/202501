import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/configs.dart';
import '../data/achievements_data.dart';
import '../models/player_stats.dart';

class AchievementManager {
  static const String _storageKey = 'mythic_achievements';
  static const String _statsKey = 'mythic_stats'; // For cumulative stats

  static List<String> unlockedIds = [];
  static Map<String, int> cumulativeStats = {
    'kills': 0,
    'gold': 0,
    'deaths': 0,
  };

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    unlockedIds = prefs.getStringList(_storageKey) ?? [];
    
    final statsJson = prefs.getString(_statsKey);
    if (statsJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(statsJson);
      cumulativeStats = decoded.map((k, v) => MapEntry(k, v as int));
    }
  }

  static Future<List<Achievement>> checkAchievements({
    required PlayerStats player, 
    int newKills = 0, 
    int newGold = 0,
    bool isDeath = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Achievement> newUnlocked = [];

    // Update Cumulative Stats
    cumulativeStats['kills'] = (cumulativeStats['kills'] ?? 0) + newKills;
    cumulativeStats['gold'] = (cumulativeStats['gold'] ?? 0) + newGold;
    if (isDeath) cumulativeStats['deaths'] = (cumulativeStats['deaths'] ?? 0) + 1;

    // Save Stats
    await prefs.setString(_statsKey, jsonEncode(cumulativeStats));

    // Check Logic
    for (final ach in achievements) {
      if (unlockedIds.contains(ach.id)) continue;

      bool unlocked = false;
      switch (ach.type) {
        case 'kill':
          if ((cumulativeStats['kills'] ?? 0) >= ach.targetValue) unlocked = true;
          break;
        case 'gold':
          if ((cumulativeStats['gold'] ?? 0) >= ach.targetValue) unlocked = true;
          break;
        case 'floor':
          // Check current run floor
          if (player.floor >= ach.targetValue) unlocked = true;
          break;
        case 'death':
          if ((cumulativeStats['deaths'] ?? 0) >= ach.targetValue) unlocked = true;
          break;
      }

      if (unlocked) {
        unlockedIds.add(ach.id);
        newUnlocked.add(ach);
      }
    }

    if (newUnlocked.isNotEmpty) {
      await prefs.setStringList(_storageKey, unlockedIds);
    }

    return newUnlocked;
  }
}
