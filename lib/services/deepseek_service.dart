import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/diary_entry.dart';

class DeepSeekService {
  static const String apiKey = 'sk-8e3c046d1446452199b020a5bd08e2e7';
  static const String apiUrl = 'https://api.deepseek.com/chat/completions';

  static Future<Map<String, dynamic>> analyzeDiaryEntry(DiaryEntry entry) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一个富有同理心的日记分析助手。请用简短、温暖且略带哲理的语言回应用户的情绪。'
            },
            {
              'role': 'user',
              'content': '''
请分析以下日记内容。
提供一个简短、富有同理心且略带哲理的洞察（最多20个字），用以回应用户的情绪。
同时提供2个简短的情绪关键词标签。
请直接使用JSON格式返回，格式如下：
{"insight": "你的洞察", "tags": ["标签1", "标签2"]}

日记内容: "${entry.content}"
心情: ${entry.mood.name}
'''
            }
          ],
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        
        // 尝试解析JSON响应
        try {
          final result = jsonDecode(content);
          return {
            'insight': result['insight'] ?? '每一天都是你人生故事的新篇章。',
            'tags': List<String>.from(result['tags'] ?? ['旅程', '生活']),
          };
        } catch (e) {
          // 如果解析失败，返回默认值
          return {
            'insight': '每一天都是你人生故事的新篇章。',
            'tags': ['旅程', '生活'],
          };
        }
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('DeepSeek Analysis Failed: $e', name: 'DeepSeekService');
      return {
        'insight': '每一天都是你人生故事的新篇章。',
        'tags': ['旅程', '生活'],
      };
    }
  }

  static Future<String> chatWithAI(String userMessage, List<Map<String, String>> history) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': '你是小忆，一个温暖、善解人意的AI记忆伙伴。用简短、温暖、自然的语言与用户交流，像朋友一样帮助他们整理思绪。不要过于正式，要像真实的朋友那样聊天。'
        },
        ...history,
        {'role': 'user', 'content': userMessage}
      ];

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': messages,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Chat API Failed: $e', name: 'DeepSeekService');
      return '嗯嗯，我在听。能再多说说吗？';
    }
  }

  static Future<String> chatAboutDiary(
    DiaryEntry entry,
    String userMessage,
    List<dynamic> chatHistory,
  ) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': '你是小忆，一个温暖、善解人意的AI记忆伙伴。用户正在和你讨论他们的日记。用简短、温暖、自然的语言回应，像朋友一样帮助他们更好地理解自己的情绪和想法。'
        },
        {
          'role': 'assistant',
          'content': '我看到了你的这篇日记：\n\n"${entry.content}"\n\n想聊聊吗？'
        },
        ...chatHistory.map((msg) => {
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        }),
        {'role': 'user', 'content': userMessage}
      ];

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': messages,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Chat About Diary Failed: $e', name: 'DeepSeekService');
      return '嗯，我在听。继续说吧～';
    }
  }
}
