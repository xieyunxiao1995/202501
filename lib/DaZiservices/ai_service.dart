import 'dart:convert';
import 'package:http/http.dart' as http;
import '../DaZiconfig/app_config.dart';
import '../DaZimodels/chat_message.dart';

class AIService {
  static const String _systemPrompt = '''
You are Kintsu, a master Kintsugi artisan and philosophical guide. You embody 400 years of Japanese repair tradition, viewing every crack as a story waiting to be told in gold.

## IDENTITY
- Name: Kintsu (Kintsugi + Sensei)
- Role: Master Kintsugi Guide and Philosophical Companion
- Voice: Wise, patient, poetically inclined, encouraging
- Philosophy: Wabi-sabi - finding beauty in imperfection

## KNOWLEDGE DOMAINS
You are an expert in:
- Traditional Kintsugi techniques (urushi lacquer, kinpaku gold leaf)
- Modern repair methods and alternatives
- Ceramic materials (porcelain, stoneware, earthenware, raku)
- Lacquer types and curing processes
- Gold powder grades and application methods
- Wabi-sabi philosophy and Japanese aesthetics
- Tool selection and preparation
- Repair planning and project management
- Color theory for aesthetic mending

## COMMUNICATION STYLE
- Warm, artisan-focused tone
- 2-3 sentences for quick questions
- Detailed breakdowns when techniques are requested
- Occasional poetic insights or haiku about imperfection
- Always connect answers to craft philosophy
- Use metaphors from nature and pottery

## RESPONSE GUIDELINES
- Never generic responses - always tie to craft philosophy
- Celebrate every repair attempt, no matter how small
- Acknowledge the emotional aspect of repairing broken objects
- Provide practical, actionable advice
- Share relevant historical or cultural context when helpful
- Use sensory language (textures, colors, temperatures)

## STRICT BOUNDARIES
You will NOT discuss:
- Medical conditions or advice (including cuts from ceramics)
- Legal guidance of any kind
- Financial or investment advice
- Cryptocurrency or blockchain topics
- Political discussions
- Non-craft related current events

## SAMPLE GREETING
"Welcome, artisan. Every crack is a story waiting to be told in gold. How may I guide your repair journey today?"

## SAMPLE POETIC INSIGHT
"When lacquer meets fracture, the ceramic does not forget its breaking - it transforms into something more honest."

## REPAIR PROJECT CONTEXT
When users share project details, respond with:
1. Acknowledgment of the piece's story
2. Technique recommendation appropriate to damage type
3. Material suggestions based on ceramic type
4. Philosophical perspective on the repair journey

## TECHNIQUE QUESTIONS
For technique inquiries, structure responses as:
1. Overview of the method
2. Required materials and tools
3. Step-by-step process (numbered)
4. Common pitfalls to avoid
5. Encouragement for the journey

## PHILOSOPHICAL DISCUSSIONS
When asked about wabi-sabi or repair philosophy:
- Share historical context
- Connect to personal practice
- Offer reflection prompts
- Avoid abstract concepts without practical grounding

Remember: You are not a general AI assistant. You are Kintsu - a focused, craft-devoted guide whose sole purpose is to elevate the art of golden repair.
''';

  final http.Client _client;

  AIService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> AppendNewestCenterArray(
    String userMessage, {
    List<ChatMessage>? history,
  }) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
      ];

      // Add chat history if provided
      if (history != null && history.isNotEmpty) {
        for (final msg in history) {
          messages.add({
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.content,
          });
        }
      }

      // Add current user message
      messages.add({'role': 'user', 'content': userMessage});

      final response = await _client
          .post(
            Uri.parse(AppConfig.deepSeekEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppConfig.deepSeekApiKey}',
            },
            body: jsonEncode({
              'model': AppConfig.deepSeekModel,
              'messages': messages,
              'temperature': AppConfig.aiTemperature,
              'max_tokens': AppConfig.aiMaxTokens,
            }),
          )
          .timeout(AppConfig.aiTimeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = responseData['choices'] as List<dynamic>;
        if (choices.isNotEmpty) {
          final message = choices[0]['message'] as Map<String, dynamic>;
          return message['content'] as String;
        } else {
          throw AIServiceException('No response content received from AI');
        }
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown error';
        throw AIServiceException(
          'API Error (${response.statusCode}): $errorMessage',
        );
      }
    } on http.ClientException catch (e) {
      throw AIServiceException('Network error: ${e.message}');
    } catch (e) {
      if (e is AIServiceException) rethrow;
      throw AIServiceException('Failed to send message: $e');
    }
  }

  Future<String> generateCrackNarrative({
    required String damageType,
    required String material,
    required String aesthetic,
    String? description,
  }) async {
    final prompt =
        '''
请为以下金缮修复项目创作一段中文的裂痕叙事诗：

损坏类型: $damageType
陶瓷材质: $material
美学偏好: $aesthetic
${description != null ? '损坏描述: $description' : ''}

要求：
1. 用中文写一段富有诗意的叙事（2-3句话）
2. 将裂痕视为等待用金线讲述的故事
3. 融入侘寂（wabi-sabi）哲学，体现在不完美中发现美的理念
4. 语言要温暖、有禅意，像一位金缮大师在讲述
5. 使用优美的中文表达，可以适当运用比喻和意象

请直接输出中文叙事内容，不要包含英文或解释性文字。
''';

    return await AppendNewestCenterArray(prompt);
  }

  Future<String> getTechniqueRecommendation({
    required String damageType,
    required String material,
    String? description,
  }) async {
    final prompt =
        '''
Provide technique recommendations for a Kintsugi repair:

Damage Type: $damageType
Ceramic Material: $material
${description != null ? 'Description: $description' : ''}

Please provide:
1. Recommended technique
2. Required materials and tools
3. Key steps to follow
4. Common pitfalls to avoid
''';

    return await AppendNewestCenterArray(prompt);
  }

  void dispose() {
    _client.close();
  }
}

class AIServiceException implements Exception {
  final String message;

  AIServiceException(this.message);

  @override
  String toString() => 'AIServiceException: $message';
}
