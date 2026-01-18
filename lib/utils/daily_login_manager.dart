import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DailyLoginManager {
  static const String _storageKey = 'mythic_daily_login';

  static int currentDay = 1; // 1-7
  static bool isClaimedToday = false;
  static String lastLoginDate = "";

  static Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    if (data != null) {
      final map = jsonDecode(data);
      lastLoginDate = map['lastLoginDate'];
      currentDay = map['currentDay'];
      isClaimedToday = map['isClaimedToday'];

      if (lastLoginDate == todayStr) {
        // Already logged in today, status remains as loaded
      } else {
        // New day
        final lastDate = _parseDate(lastLoginDate);
        final difference = now.difference(lastDate).inDays;

        if (difference == 1) {
          // Consecutive day
          currentDay++;
          if (currentDay > 7) currentDay = 1; // Loop 7 days
        } else {
          // Missed a day or more, reset to day 1
          currentDay = 1;
        }
        isClaimedToday = false;
        lastLoginDate = todayStr;
        await _save(prefs);
      }
    } else {
      // First time
      currentDay = 1;
      isClaimedToday = false;
      lastLoginDate = todayStr;
      await _save(prefs);
    }
  }

  static bool get hasRewardAvailable => !isClaimedToday;


  static Future<void> claimReward() async {
    isClaimedToday = true;
    final prefs = await SharedPreferences.getInstance();
    await _save(prefs);
  }

  static Future<void> _save(SharedPreferences prefs) async {
    final map = {
      'lastLoginDate': lastLoginDate,
      'currentDay': currentDay,
      'isClaimedToday': isClaimedToday,
    };
    await prefs.setString(_storageKey, jsonEncode(map));
  }

  static DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }
}
