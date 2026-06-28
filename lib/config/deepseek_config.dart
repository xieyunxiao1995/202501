import 'dart:convert';

abstract final class DeepSeekConfig {
  static const String _tokenB64 =
      'c2stYTJjZmRiMDM5OGU1NGRkM2E5OTI4MzNkYzNhZGQyNTc=';
  static const endpoint = 'https://api.deepseek.com/chat/completions';
  static const model = 'deepseek-chat';

  static String get token => utf8.decode(base64Decode(_tokenB64));

  static bool get isConfigured =>
      token.isNotEmpty && !token.startsWith('REPLACE_WITH_');
}
