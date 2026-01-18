import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_data.dart';
import '../models/player_stats.dart';
import '../models/enums.dart';

class SaveManager {
  static const String _keySaveData = 'mythic_save_data';

  static Future<void> saveGame({
    required PlayerStats player,
    required List<CardData> cards,
    required GameState gameState,
  }) async {
    // Only save if we are in a valid state to resume (e.g. playing, shop)
    // If Game Over, we should clear the save instead.
    if (gameState == GameState.gameOver || gameState == GameState.menu) {
      await clearSave();
      return;
    }

    final data = {
      'player': player.toJson(),
      'cards': cards.map((c) => c.toJson()).toList(),
      'gameState': gameState.index,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySaveData, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keySaveData);
    if (jsonStr == null) return null;

    try {
      final data = jsonDecode(jsonStr);
      return data;
    } catch (e) {
      print("Error loading save: $e");
      return null;
    }
  }

  static Future<void> clearSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySaveData);
  }

  static Future<bool> hasSave() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keySaveData);
  }
}
