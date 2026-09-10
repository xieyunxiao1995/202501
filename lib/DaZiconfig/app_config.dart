class AppConfig {
  // DeepSeek API Configuration
  static const String deepSeekApiKey = 'sk-ca65f6f0017242b385adb0a83da4a362';
  static const String deepSeekEndpoint =
      'https://api.deepseek.com/v1/chat/completions';
  static const String deepSeekModel = 'deepseek-chat';

  // AI Parameters
  static const double aiTemperature = 0.7;
  static const int aiMaxTokens = 5000;
  static const Duration aiTimeout = Duration(seconds: 30);

  // App Info
  static const String appName = 'CP嗒啧';
  static const String appVersion = '1.0.0';

  // DeepSeek Privacy Policy
  static const String deepSeekPrivacyPolicyUrl =
      'https://www.deepseek.com/privacy';
}
