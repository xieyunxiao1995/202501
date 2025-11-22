import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const String _apiKey = 'sk-8f1022ce384c49e1ae178f02a77938ec';

  Future<String> GetStaticVectorManager(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are Mora, a compassionate AI emotional companion. Provide supportive, empathetic responses that help users process their emotions. Keep responses warm, concise (under 100 words), and offer gentle guidance or suggestions when appropriate.'
            },
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.8,
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] ?? 'I\'m here for you.';
      } else {
        return 'I\'m having trouble responding right now. Please try again.';
      }
    } catch (e) {
      return 'I\'m here for you. How are you feeling today?';
    }
  }

  Future<String> analyzeJournalContent(String content) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are analyzing a journal entry for emotional content. Provide a brief, supportive response (under 50 words) and suggest 1-2 relevant emotion tags from this list: peaceful, joy, anxiety, hope, love, energy, tired, grateful, confused, accomplished.'
            },
            {'role': 'user', 'content': content}
          ],
          'temperature': 0.7,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
