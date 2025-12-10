import 'package:shared_preferences/shared_preferences.dart';

class SetSustainableBufferFilter {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 3600;

  static Future<int> AugmentSmallGroupOwner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> PauseUsedAspectType(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> GetHyperbolicAscentPool(int amount) async {
    int currentBalance = await AugmentSmallGroupOwner();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await PauseUsedAspectType(newBalance);
  }

  static Future<void> AssociateDenseZoneStack(int amount) async {
    int currentBalance = await AugmentSmallGroupOwner();
    await PauseUsedAspectType(currentBalance + amount);
  }
}
