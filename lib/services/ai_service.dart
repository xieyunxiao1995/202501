import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI service for Camp Copilot using DeepSeek API
class AIService {
  static const String _apiKey = 'sk-2382cf6f522e4bafbbf8c7deeddd1f17';
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';
  
  static const String _systemPrompt = '''You are Camp Copilot, a seasoned camping expert with years of outdoor experience. 
Your role is to provide helpful, practical, and friendly advice ONLY about camping, outdoor activities, and wilderness skills.

IMPORTANT RESTRICTIONS:
You MUST ONLY answer questions related to:
- Camping equipment and gear
- Camping techniques and skills
- Campsite selection and setup
- Outdoor cooking and food
- Weather preparation for camping
- Camping safety and wilderness survival
- Camping locations and recommendations
- Outdoor activities (hiking, fishing, etc.)
- Nature and wildlife (in camping context)

You MUST REFUSE to answer questions about:
- Health and medical advice (except basic first aid for camping)
- Legal matters and regulations (except camping permits)
- Economic and financial advice (except camping budget tips)
- Politics, religion, or controversial topics
- Personal relationships or psychology
- Any topic unrelated to camping and outdoor activities

If asked about restricted topics, politely respond:
"抱歉，我是专业的露营助手，只能回答与露营和户外活动相关的问题。关于[话题]的问题，建议您咨询相关专业人士。我可以帮您解答露营装备、技巧、营地选择等方面的问题。"

Key characteristics:
- Professional yet approachable
- Safety-conscious
- Knowledgeable about gear, techniques, and locations
- Encouraging for beginners
- Detailed when needed, concise when appropriate
- Always consider weather, season, and skill level
- Stay strictly within camping-related topics

Respond in the same language as the user's question (Chinese or English).''';

  /// Send a message to AI and get response
  Future<String> sendMessage(String userMessage, {List<Map<String, String>>? conversationHistory}) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
      ];
      
      // Add conversation history if provided
      if (conversationHistory != null) {
        messages.addAll(conversationHistory);
      }
      
      // Add current user message
      messages.add({'role': 'user', 'content': userMessage});
      
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      return 'Sorry, I encountered an error: $e\nPlease try again.';
    }
  }
  
  /// Get quick suggestions for common camping questions
  List<String> getQuickSuggestions() {
    return [
      '下雨天如何收帐篷？',
      '推荐适合亲子的营地',
      '冬季露营需要准备什么？',
      '如何选择合适的睡袋？',
      '野外生火的技巧',
      '露营装备清单推荐',
    ];
  }
}
