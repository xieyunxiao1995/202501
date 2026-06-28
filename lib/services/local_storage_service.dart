import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';
import '../models/clothing_item.dart';
import '../models/outfit_entry.dart';

class LocalStorageService {
  static const _outfitsKey = 'cpcloth.outfits.v1';
  static const _clothingItemsKey = 'cpcloth.clothing_items.v1';
  static const _chatMessagesKey = 'cpcloth.chat_messages.v1';

  Future<List<OutfitEntry>> loadOutfits() async {
    final values = await _readJsonList(_outfitsKey);
    return values.map(OutfitEntry.fromJson).toList(growable: false);
  }

  Future<void> saveOutfits(List<OutfitEntry> outfits) {
    return _writeJsonList(_outfitsKey, outfits.map((item) => item.toJson()));
  }

  Future<List<ClothingItem>> loadClothingItems() async {
    final values = await _readJsonList(_clothingItemsKey);
    return values.map(ClothingItem.fromJson).toList(growable: false);
  }

  Future<void> saveClothingItems(List<ClothingItem> items) {
    return _writeJsonList(
      _clothingItemsKey,
      items.map((item) => item.toJson()),
    );
  }

  Future<List<ChatMessage>> loadChatMessages() async {
    final values = await _readJsonList(_chatMessagesKey);
    return values.map(ChatMessage.fromJson).toList(growable: false);
  }

  Future<void> saveChatMessages(List<ChatMessage> messages) {
    return _writeJsonList(
      _chatMessagesKey,
      messages.map((item) => item.toJson()),
    );
  }

  Future<void> clearAll() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.remove(_outfitsKey),
      preferences.remove(_clothingItemsKey),
      preferences.remove(_chatMessagesKey),
    ]);
  }

  Future<List<Map<String, dynamic>>> _readJsonList(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final source = preferences.getString(key);
    if (source == null || source.isEmpty) return const [];

    try {
      final decoded = jsonDecode(source);
      if (decoded is! List<dynamic>) return const [];
      return decoded
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => item.map((key, value) => MapEntry('$key', value)))
          .toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  Future<void> _writeJsonList(
    String key,
    Iterable<Map<String, dynamic>> values,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(values.toList(growable: false));
    await preferences.setString(key, encoded);
  }
}
