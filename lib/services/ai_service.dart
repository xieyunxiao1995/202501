import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'sk-8ff327b23b59479eb1e9f4a67460a79d';
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';

  Future<String> generateFlavorText(String context) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "deepseek-chat",
          "messages": [
            {"role": "system", "content": "你是一款水墨克苏鲁/山海经风格文字冒险游戏的旁白。保持描述简短、隐晦且充满氛围感（最多2句话）。请使用中文。"},
            {"role": "user", "content": context}
          ],
          "stream": false
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'] ?? '墨色无声地流转...';
      } else {
        print('AI Error: ${response.statusCode} ${response.body}');
        return '虚空在低语，无法辨识...';
      }
    } catch (e) {
      print('AI Exception: $e');
      return '与虚空的连接断开了...';
    }
  }
}
