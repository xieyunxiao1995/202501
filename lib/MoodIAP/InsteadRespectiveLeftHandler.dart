import 'package:shared_preferences/shared_preferences.dart';

class GetAccordionGraphOwner {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 2800;

  static Future<int> SetOtherTagObserver() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> GetNextSignatureGroup(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SetSpecifyOriginContainer(int amount) async {
    int currentBalance = await SetOtherTagObserver();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await GetNextSignatureGroup(newBalance);
  }

  static Future<void> SetSortedTopExtension(int amount) async {
    int currentBalance = await SetOtherTagObserver();
    await GetNextSignatureGroup(currentBalance + amount);
  }
}
