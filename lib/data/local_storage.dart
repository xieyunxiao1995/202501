import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/outfit_models.dart';

class LocalStorage {
  static final diaryChanged = ValueNotifier<int>(0);
  static final wardrobeChanged = ValueNotifier<int>(0);
  static final aiHistoryChanged = ValueNotifier<int>(0);
  static const diaryCountKey = 'diary_count';
  static const savedTodayKey = 'saved_today';
  static const diaryEntriesKey = 'diary_entries';
  static const wardrobeKey = 'wardrobe';
  static const aiHistoryKey = 'ai_history';
  static const favoritesKey = 'favorite_inspiration';
  static const preferredStylesKey = 'preferred_styles';
  static const preferredColorsKey = 'preferred_colors';
  static const eulaAcceptedKey = 'eula_accepted_version';

  /// 当前 EULA 版本，更新协议或启动页内容后修改此值即可让用户重新确认
  static const eulaVersion = '2';

  Future<bool> readEulaAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(eulaAcceptedKey) == eulaVersion;
  }

  Future<void> saveEulaAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(eulaAcceptedKey, eulaVersion);
  }

  Future<int> readDiaryCount() async {
    final list = await readDiaryEntries();
    return list.length;
  }

  /// 「今日已记录」标记按当天日期失效，次日自动重置
  static String get _todayStamp {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<bool> readSavedToday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(savedTodayKey) == _todayStamp;
  }

  Future<void> saveToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(savedTodayKey, _todayStamp);
  }

  Future<List<DiaryEntry>> readDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(diaryEntriesKey);
    if (raw == null) return List.of(_defaultDiaryEntries);
    return (jsonDecode(raw) as List)
        .map((item) => DiaryEntry.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveDiaryEntry(DiaryEntry entry) async {
    final entries = List<DiaryEntry>.from(await readDiaryEntries());
    entries.removeWhere((item) => item.id == entry.id);
    entries.insert(0, entry);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      diaryEntriesKey,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
    diaryChanged.value++;
  }

  Future<void> deleteDiaryEntry(String id) async {
    final entries = List<DiaryEntry>.from(await readDiaryEntries());
    entries.removeWhere((item) => item.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      diaryEntriesKey,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
    diaryChanged.value++;
  }

  Future<Set<String>> readPreferredStyles() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(preferredStylesKey) ?? const []).toSet();
  }

  Future<Set<String>> readPreferredColors() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(preferredColorsKey) ?? const []).toSet();
  }

  Future<void> savePreferences({
    required Set<String> styles,
    required Set<String> colors,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(preferredStylesKey, styles.toList());
    await prefs.setStringList(preferredColorsKey, colors.toList());
  }

  Future<List<ClothingItem>> readWardrobe() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(wardrobeKey);
    if (raw == null) return List<ClothingItem>.of(_defaultWardrobe);
    return (jsonDecode(raw) as List)
        .map((item) => ClothingItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveWardrobe(List<ClothingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      wardrobeKey,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
    wardrobeChanged.value++;
  }

  Future<void> saveClothingItem(ClothingItem item) async {
    final items = await readWardrobe();
    final index = items.indexWhere((value) => value.id == item.id);
    if (index == -1) {
      items.insert(0, item);
    } else {
      items[index] = item;
    }
    await saveWardrobe(items);
  }

  Future<void> deleteClothingItem(String id) async {
    final items = await readWardrobe();
    items.removeWhere((e) => e.id == id);
    await saveWardrobe(items);
  }

  Future<List<AiHistoryEntry>> readAiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(aiHistoryKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((item) => AiHistoryEntry.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveAiHistory(AiHistoryEntry entry) async {
    final entries = await readAiHistory();
    entries.removeWhere((item) => item.id == entry.id);
    entries.insert(0, entry);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      aiHistoryKey,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
    aiHistoryChanged.value++;
  }

  Future<Set<String>> readFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(favoritesKey) ?? const []).toSet();
  }

  Future<void> saveFavorites(Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoritesKey, favorites.toList());
  }

  static const _defaultWardrobe = [
    ClothingItem(
      id: 'default-blazer',
      name: '米色西装',
      type: '外套',
      image: 'assets/cream_tweed_jacket_product.png',
    ),
    ClothingItem(
      id: 'default-skirt',
      name: '百褶半裙',
      type: '裙装',
      image: 'assets/cream_pleated_midi_skirt_v1.png',
    ),
    ClothingItem(
      id: 'default-bag',
      name: '米色手提包',
      type: '鞋包',
      image: 'assets/beige_structured_handbag_with_clasp_v1.png',
    ),
  ];

  static const _defaultDiaryEntries = [
    DiaryEntry(
      id: 'demo-0518',
      date: '5.18',
      image: 'assets/outfit_beige_trench_coat_jeans_bag_sneakers.png',
      mood: '开心',
      weather: '多云 18~26°C',
      tags: ['通勤', '简约'],
    ),
    DiaryEntry(
      id: 'demo-0517',
      date: '5.17',
      image: 'assets/outfit_lavender_cardigan_pleated_skirt_bag_loafers.png',
      mood: '放松',
      weather: '晴 20~28°C',
      tags: ['休闲', '舒适'],
    ),
    DiaryEntry(
      id: 'demo-0516',
      date: '5.16',
      image: 'assets/outfit_pink_blouse_pink_pleated_skirt_bag_heels.png',
      mood: '平静',
      weather: '晴 16~22°C',
      tags: ['约会', '温柔'],
    ),
  ];
}
