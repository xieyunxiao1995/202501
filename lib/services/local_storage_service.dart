import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/camp_model.dart';
import '../models/gear_model.dart';
import '../models/log_model.dart';

/// Local storage service using SharedPreferences
class LocalStorageService {
  // Storage keys
  static const String _keyUser = 'user_data';
  static const String _keyPlans = 'camp_plans';
  static const String _keyGear = 'gear_items';
  static const String _keyLogs = 'log_entries';
  static const String _keyCurrentPlanId = 'current_plan_id';
  static const String _keyEULAAgreed = 'eula_agreed';

  late SharedPreferences _prefs;

  // Singleton pattern
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User operations
  Future<bool> saveUser(User user) async {
    try {
      return await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  User? loadUser() {
    try {
      final data = _prefs.getString(_keyUser);
      if (data == null) return null;
      return User.fromJson(jsonDecode(data));
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }

  // Plans operations
  Future<bool> savePlans(List<CampPlan> plans) async {
    try {
      final jsonList = plans.map((p) => p.toJson()).toList();
      return await _prefs.setString(_keyPlans, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving plans: $e');
      return false;
    }
  }

  List<CampPlan> loadPlans() {
    try {
      final data = _prefs.getString(_keyPlans);
      if (data == null) return [];
      final jsonList = jsonDecode(data) as List<dynamic>;
      return jsonList
          .map((json) => CampPlan.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading plans: $e');
      return [];
    }
  }

  Future<bool> setCurrentPlanId(String planId) async {
    return await _prefs.setString(_keyCurrentPlanId, planId);
  }

  String? getCurrentPlanId() {
    return _prefs.getString(_keyCurrentPlanId);
  }

  // Gear operations
  Future<bool> saveGearItems(List<GearItem> items) async {
    try {
      final jsonList = items.map((g) => g.toJson()).toList();
      return await _prefs.setString(_keyGear, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving gear items: $e');
      return false;
    }
  }

  List<GearItem> loadGearItems() {
    try {
      final data = _prefs.getString(_keyGear);
      if (data == null) return [];
      final jsonList = jsonDecode(data) as List<dynamic>;
      return jsonList
          .map((json) => GearItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading gear items: $e');
      return [];
    }
  }

  // Log operations
  Future<bool> saveLogs(List<LogEntry> logs) async {
    try {
      final jsonList = logs.map((l) => l.toJson()).toList();
      return await _prefs.setString(_keyLogs, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving logs: $e');
      return false;
    }
  }

  List<LogEntry> loadLogs() {
    try {
      final data = _prefs.getString(_keyLogs);
      if (data == null) return [];
      final jsonList = jsonDecode(data) as List<dynamic>;
      return jsonList
          .map((json) => LogEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading logs: $e');
      return [];
    }
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  // Clear specific data
  Future<bool> clearUser() async {
    return await _prefs.remove(_keyUser);
  }

  Future<bool> clearPlans() async {
    return await _prefs.remove(_keyPlans);
  }

  Future<bool> clearGearItems() async {
    return await _prefs.remove(_keyGear);
  }

  Future<bool> clearLogs() async {
    return await _prefs.remove(_keyLogs);
  }

  // EULA operations
  Future<bool> setEULAAgreed(bool agreed) async {
    return await _prefs.setBool(_keyEULAAgreed, agreed);
  }

  Future<bool> hasAgreedEULA() async {
    return _prefs.getBool(_keyEULAAgreed) ?? false;
  }

  Future<bool> clearEULAStatus() async {
    return await _prefs.remove(_keyEULAAgreed);
  }
}
