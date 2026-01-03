import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../models/player_stats.dart';

class StorageService {
  static const String _statsKey = 'player_stats';
  static const String _inventoryKey = 'inventory';
  static const String _deckKey = 'deck';

  Future<void> savePlayerStats(PlayerStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  Future<PlayerStats> loadPlayerStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_statsKey);
    if (data != null) {
      return PlayerStats.fromJson(jsonDecode(data));
    }
    return PlayerStats();
  }

  Future<void> saveInventory(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(_inventoryKey, jsonEncode(jsonList));
  }

  Future<List<Item>> loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_inventoryKey);
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Item.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveDeck(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(_deckKey, jsonEncode(jsonList));
  }

  Future<List<Item>> loadDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_deckKey);
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Item.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_inventoryKey);
    await prefs.remove(_deckKey);
  }
}
