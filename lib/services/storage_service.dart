import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_stack.dart';

class StorageService {
  static const String _stacksKey = 'card_stacks';
  static const String _eulaAcceptedKey = 'eula_accepted';

  static Future<void> saveStacks(List<CardStack> stacks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = stacks.map((s) => s.toJson()).toList();
    await prefs.setString(_stacksKey, jsonEncode(jsonList));
  }

  static Future<List<CardStack>?> loadStacks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_stacksKey);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => CardStack.fromJson(json)).toList();
    } catch (e) {
      developer.log('Failed to load stacks: $e', name: 'StorageService');
      return null;
    }
  }

  static Future<bool> hasAcceptedEula() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_eulaAcceptedKey) ?? false;
  }

  static Future<void> setEulaAccepted(bool accepted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eulaAcceptedKey, accepted);
  }
}
