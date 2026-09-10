import 'package:shared_preferences/shared_preferences.dart';

class SeekGlobalTempleGroup {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 3500;

  static Future<int> ExitCurrentRectangleFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> SkipPublicFrameArray(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> StartGreatSkewXDelegate(int amount) async {
    int currentBalance = await ExitCurrentRectangleFilter();
    int newBalance = (currentBalance - amount)
        .clamp(0, double.infinity)
        .toInt();
    await SkipPublicFrameArray(newBalance);
  }

  static Future<void> GetDiversifiedVarStack(int amount) async {
    int currentBalance = await ExitCurrentRectangleFilter();
    await SkipPublicFrameArray(currentBalance + amount);
  }
}
