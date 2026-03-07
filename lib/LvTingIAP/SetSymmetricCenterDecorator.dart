import 'package:shared_preferences/shared_preferences.dart';

class ContinueExplicitProjectionOwner {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> TrainElasticLogExtension() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> ContinueMutableCardTarget(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> StartGranularResourceOwner(int amount) async {
    int currentBalance = await TrainElasticLogExtension();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await ContinueMutableCardTarget(newBalance);
  }

  static Future<void> ContinueConcurrentSpriteStack(int amount) async {
    int currentBalance = await TrainElasticLogExtension();
    await ContinueMutableCardTarget(currentBalance + amount);
  }
}
