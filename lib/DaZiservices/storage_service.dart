import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/repair_project.dart';
import '../models/chat_message.dart';
import '../models/user_preferences.dart';
import '../models/repair_log.dart';

class StorageService {
  final SharedPreferences _prefs;

  // Storage Keys
  static const String _keyEulaAccepted = 'pref_eula_accepted';
  static const String _keyOnboardingCompleted = 'pref_onboarding_completed';
  static const String _keyFirstLaunch = 'pref_is_first_launch';
  static const String _keyPreferredAesthetic = 'pref_preferred_aesthetic';
  static const String _keyTotalProjectsCompleted =
      'pref_total_projects_completed';
  static const String _keyLastChatTimestamp = 'pref_last_chat_timestamp';
  static const String _keyRepairProjects = 'data_repair_projects';
  static const String _keyChatHistory = 'data_chat_history';
  static const String _keyUserPreferences = 'data_user_preferences';
  static const String _keyLastPhotoPath = 'cache_last_photo_path';
  static const String _keyTempProjectId = 'cache_temp_project_id';
  static const String _keyRepairLogs = 'data_repair_logs';

  StorageService(this._prefs);

  // EULA & Onboarding
  Future<bool> hasAcceptedEula() async {
    try {
      return _prefs.getBool(_keyEulaAccepted) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> setEulaAccepted(bool value) async {
    try {
      await _prefs.setBool(_keyEulaAccepted, value);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<bool> hasCompletedOnboarding() async {
    try {
      return _prefs.getBool(_keyOnboardingCompleted) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> setOnboardingCompleted(bool value) async {
    try {
      await _prefs.setBool(_keyOnboardingCompleted, value);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<bool> isFirstLaunch() async {
    try {
      return _prefs.getBool(_keyFirstLaunch) ?? true;
    } catch (e) {
      return true;
    }
  }

  Future<void> setFirstLaunch(bool value) async {
    try {
      await _prefs.setBool(_keyFirstLaunch, value);
    } catch (e) {
      // Handle error silently
    }
  }

  // User Preferences
  Future<String> getPreferredAesthetic() async {
    try {
      return _prefs.getString(_keyPreferredAesthetic) ?? 'classic-gold';
    } catch (e) {
      return 'classic-gold';
    }
  }

  Future<void> setPreferredAesthetic(String aesthetic) async {
    try {
      await _prefs.setString(_keyPreferredAesthetic, aesthetic);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<int> getTotalProjectsCompleted() async {
    try {
      return _prefs.getInt(_keyTotalProjectsCompleted) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> incrementProjectsCompleted() async {
    try {
      final current = await getTotalProjectsCompleted();
      await _prefs.setInt(_keyTotalProjectsCompleted, current + 1);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setTotalProjectsCompleted(int value) async {
    try {
      await _prefs.setInt(_keyTotalProjectsCompleted, value);
    } catch (e) {
      // Handle error silently
    }
  }

  // Repair Projects
  Future<List<RepairProject>> getAllProjects() async {
    try {
      final jsonString = _prefs.getString(_keyRepairProjects) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => RepairProject.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveProject(RepairProject project) async {
    try {
      final projects = await getAllProjects();
      final existingIndex = projects.indexWhere((p) => p.id == project.id);

      if (existingIndex >= 0) {
        projects[existingIndex] = project;
      } else {
        projects.add(project);
      }

      final jsonList = projects.map((p) => p.toJson()).toList();
      await _prefs.setString(_keyRepairProjects, jsonEncode(jsonList));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      final projects = await getAllProjects();
      projects.removeWhere((p) => p.id == projectId);
      final jsonList = projects.map((p) => p.toJson()).toList();
      await _prefs.setString(_keyRepairProjects, jsonEncode(jsonList));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> archiveProject(String projectId) async {
    try {
      final projects = await getAllProjects();
      final index = projects.indexWhere((p) => p.id == projectId);
      if (index >= 0) {
        projects[index] = projects[index].copyWith(isArchived: true);
        final jsonList = projects.map((p) => p.toJson()).toList();
        await _prefs.setString(_keyRepairProjects, jsonEncode(jsonList));
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<RepairProject?> getProjectById(String id) async {
    try {
      final projects = await getAllProjects();
      return projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Chat History
  Future<List<ChatMessage>> getChatHistory() async {
    try {
      final jsonString = _prefs.getString(_keyChatHistory) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addChatMessage(ChatMessage message) async {
    try {
      final history = await getChatHistory();
      history.add(message);
      final jsonList = history.map((m) => m.toJson()).toList();
      await _prefs.setString(_keyChatHistory, jsonEncode(jsonList));
      await _prefs.setString(
        _keyLastChatTimestamp,
        message.timestamp.toIso8601String(),
      );
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearChatHistory() async {
    try {
      await _prefs.setString(_keyChatHistory, '[]');
      await _prefs.setString(_keyLastChatTimestamp, '');
    } catch (e) {
      // Handle error silently
    }
  }

  Future<String> getLastChatTimestamp() async {
    try {
      return _prefs.getString(_keyLastChatTimestamp) ?? '';
    } catch (e) {
      return '';
    }
  }

  // Cache
  Future<String> getLastPhotoPath() async {
    try {
      return _prefs.getString(_keyLastPhotoPath) ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> setLastPhotoPath(String path) async {
    try {
      await _prefs.setString(_keyLastPhotoPath, path);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<String?> getTempProjectId() async {
    try {
      return _prefs.getString(_keyTempProjectId);
    } catch (e) {
      return null;
    }
  }

  Future<void> setTempProjectId(String? id) async {
    try {
      if (id == null) {
        await _prefs.remove(_keyTempProjectId);
      } else {
        await _prefs.setString(_keyTempProjectId, id);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearTempProjectId() async {
    try {
      await _prefs.remove(_keyTempProjectId);
    } catch (e) {
      // Handle error silently
    }
  }

  // User Preferences Object
  Future<UserPreferences> getUserPreferences() async {
    try {
      final jsonString = _prefs.getString(_keyUserPreferences) ?? '{}';
      return UserPreferences.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      return const UserPreferences();
    }
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    try {
      await _prefs.setString(_keyUserPreferences, preferences.toJsonString());
    } catch (e) {
      // Handle error silently
    }
  }

  // Repair Logs
  Future<List<RepairLogEntry>> getRepairLogs(String projectId) async {
    try {
      final jsonString = _prefs.getString(_keyRepairLogs) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      final logs = jsonList
          .map((json) => RepairLogEntry.fromJson(json as Map<String, dynamic>))
          .toList();
      return logs.where((log) => log.projectId == projectId).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<RepairLogEntry>> getAllRepairLogs() async {
    try {
      final jsonString = _prefs.getString(_keyRepairLogs) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => RepairLogEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveRepairLog(RepairLogEntry log) async {
    try {
      final logs = await getAllRepairLogs();
      final existingIndex = logs.indexWhere((l) => l.id == log.id);

      if (existingIndex >= 0) {
        logs[existingIndex] = log;
      } else {
        logs.add(log);
      }

      final jsonList = logs.map((l) => l.toJson()).toList();
      await _prefs.setString(_keyRepairLogs, jsonEncode(jsonList));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> deleteRepairLog(String logId) async {
    try {
      final logs = await getAllRepairLogs();
      logs.removeWhere((l) => l.id == logId);
      final jsonList = logs.map((l) => l.toJson()).toList();
      await _prefs.setString(_keyRepairLogs, jsonEncode(jsonList));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> deleteRepairLogsByProject(String projectId) async {
    try {
      final logs = await getAllRepairLogs();
      logs.removeWhere((l) => l.projectId == projectId);
      final jsonList = logs.map((l) => l.toJson()).toList();
      await _prefs.setString(_keyRepairLogs, jsonEncode(jsonList));
    } catch (e) {
      // Handle error silently
    }
  }
}
