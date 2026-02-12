import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';

class StorageService {
  static const String _playerKey = 'player_data';

  Future<void> savePlayer(Player player) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(player.toJson());
    await prefs.setString(_playerKey, jsonString);
  }

  Future<Player?> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_playerKey);
    if (jsonString != null) {
      try {
        return Player.fromJson(jsonDecode(jsonString));
      } catch (e) {
        print('Error loading player: $e');
        return null;
      }
    }
    return null;
  }
  
  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
