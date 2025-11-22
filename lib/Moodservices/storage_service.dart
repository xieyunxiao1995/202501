import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Moodmodels/journal.dart';
import '../Moodmodels/chat_message.dart';
import '../Moodmodels/app_settings.dart';
import 'sample_data_service.dart';

class StorageService {
  static const String _journalsKey = 'journals';
  static const String _chatMessagesKey = 'chat_messages';
  static const String _settingsKey = 'settings';
  static const String _eulaAcceptedKey = 'eula_accepted';
  static const String _dataVersionKey = 'data_version';
  static const int _currentDataVersion = 1;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Initialize with sample data if no journals exist or if data version is outdated
    final journalsJson = _prefs.getString(_journalsKey);
    final dataVersion = _prefs.getInt(_dataVersionKey) ?? 0;

    if (journalsJson == null || dataVersion < _currentDataVersion) {
      await _initializeSampleData();
      await _prefs.setInt(_dataVersionKey, _currentDataVersion);
    }
  }

  Future<void> _initializeSampleData() async {
    final sampleJournals = SampleDataService.getSampleJournals();
    for (final journal in sampleJournals) {
      await saveJournal(journal);
    }
  }

  SharedPreferences get prefs => _prefs;

  // Journal operations
  Future<List<Journal>> getJournals() async {
    final journalsJson = _prefs.getString(_journalsKey);
    if (journalsJson == null) return [];

    final List<dynamic> decoded = json.decode(journalsJson);
    return decoded.map((json) => Journal.fromJson(json)).toList();
  }

  Future<void> saveJournal(Journal journal) async {
    final journals = await getJournals();
    final index = journals.indexWhere((j) => j.id == journal.id);

    if (index >= 0) {
      journals[index] = journal;
    } else {
      journals.add(journal);
    }

    final encoded = json.encode(journals.map((j) => j.toJson()).toList());
    await _prefs.setString(_journalsKey, encoded);
  }

  Future<void> deleteJournal(String id) async {
    final journals = await getJournals();
    journals.removeWhere((j) => j.id == id);
    final encoded = json.encode(journals.map((j) => j.toJson()).toList());
    await _prefs.setString(_journalsKey, encoded);
  }

  List<Journal> getPublicJournalsSync(List<Journal> allJournals) {
    return allJournals.where((journal) => !journal.isPrivate).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Journal> getPrivateJournalsSync(List<Journal> allJournals) {
    return allJournals.where((journal) => journal.isPrivate).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Chat message operations
  Future<List<ChatMessage>> getChatMessages() async {
    final messagesJson = _prefs.getString(_chatMessagesKey);
    if (messagesJson == null) return [];

    final List<dynamic> decoded = json.decode(messagesJson);
    return decoded.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<void> saveChatMessage(ChatMessage message) async {
    final messages = await getChatMessages();
    messages.add(message);

    final encoded = json.encode(messages.map((m) => m.toJson()).toList());
    await _prefs.setString(_chatMessagesKey, encoded);
  }

  Future<void> clearChatMessages() async {
    await _prefs.setString(_chatMessagesKey, json.encode([]));
  }

  // Settings operations
  Future<AppSettings> getSettings() async {
    final settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson == null) {
      return AppSettings(
        aiAnalysisEnabled: true,
        anonymousInPublic: false,
        diaryRemindersEnabled: true,
        aiInteractionRemindersEnabled: false,
        themeMode: 'auto',
        blockedUserIds: [],
      );
    }

    final decoded = json.decode(settingsJson);
    return AppSettings.fromJson(decoded);
  }

  // 拉黑用户
  Future<void> blockUser(String userId) async {
    final settings = await getSettings();
    if (!settings.blockedUserIds.contains(userId)) {
      final updatedSettings = settings.copyWith(
        blockedUserIds: [...settings.blockedUserIds, userId],
      );
      await saveSettings(updatedSettings);
    }
  }

  // 取消拉黑用户
  Future<void> unblockUser(String userId) async {
    final settings = await getSettings();
    final updatedSettings = settings.copyWith(
      blockedUserIds: settings.blockedUserIds.where((id) => id != userId).toList(),
    );
    await saveSettings(updatedSettings);
  }

  // 检查用户是否被拉黑
  Future<bool> isUserBlocked(String userId) async {
    final settings = await getSettings();
    return settings.blockedUserIds.contains(userId);
  }

  // 获取拉黑用户列表
  Future<List<String>> getBlockedUserIds() async {
    final settings = await getSettings();
    return settings.blockedUserIds;
  }

  Future<void> saveSettings(AppSettings settings) async {
    final encoded = json.encode(settings.toJson());
    await _prefs.setString(_settingsKey, encoded);
  }

  // EULA operations
  Future<bool> hasAcceptedEula() async {
    return _prefs.getBool(_eulaAcceptedKey) ?? false;
  }

  Future<void> setEulaAccepted(bool accepted) async {
    await _prefs.setBool(_eulaAcceptedKey, accepted);
  }

  // Data export
  Future<Map<String, dynamic>> exportData() async {
    final journals = await getJournals();
    final messages = await getChatMessages();
    final settings = await getSettings();

    return {
      'journals': journals.map((j) => j.toJson()).toList(),
      'chatMessages': messages.map((m) => m.toJson()).toList(),
      'settings': settings.toJson(),
      'exportDate': DateTime.now().millisecondsSinceEpoch,
    };
  }

  // Clear all data and reinitialize with sample data
  Future<void> clearAllDataAndReinitialize() async {
    await _prefs.clear();
    await _initializeSampleData();
    await _prefs.setInt(_dataVersionKey, _currentDataVersion);
  }

  // Force reinitialize sample data (for debug purposes)
  Future<void> forceReinitializeSampleData() async {
    await _prefs.remove(_journalsKey);
    await _initializeSampleData();
    await _prefs.setInt(_dataVersionKey, _currentDataVersion);
  }
}
