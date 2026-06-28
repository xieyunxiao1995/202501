import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/deepseek_config.dart';
import '../models/chat_message.dart';
import '../models/clothing_item.dart';
import '../models/outfit_entry.dart';

class DeepSeekException implements Exception {
  const DeepSeekException(this.message);

  final String message;

  @override
  String toString() => message;
}

class DeepSeekService {
  DeepSeekService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static String buildSystemPrompt({
    required List<ClothingItem> clothingItems,
    required List<OutfitEntry> outfits,
  }) {
    final owned = clothingItems.where((item) => item.isPurchased).toList();
    final wanted = clothingItems.where((item) => !item.isPurchased).toList();
    final recent = [...outfits]..sort((a, b) => b.date.compareTo(a.date));
    final recentSummary = recent
        .take(8)
        .map((entry) {
          return '- ${entry.date.month}月${entry.date.day}日 ${entry.title}｜${entry.occasion}｜心情：${entry.mood}${entry.notes.isEmpty ? '' : '｜备注：${entry.notes}'}';
        })
        .join('\n');
    final ownedSummary = owned
        .map((item) {
          return '- ${item.name}｜${item.category}｜${item.color}｜${item.season}${item.careNotes.isEmpty ? '' : '｜养护：${item.careNotes}'}';
        })
        .join('\n');
    final wantedSummary = wanted
        .map(
          (item) =>
              '- ${item.name}｜${item.category}｜${item.color}｜${item.season}',
        )
        .join('\n');

    return '''
你是 CPDD小屋 的私人穿搭、购物和衣物养护助手。请始终使用自然、友好、简洁的中文回答，并给出具体可执行的建议。

工作原则：
1. 优先使用用户已经拥有的衣物完成搭配，不虚构衣橱中不存在的单品。
2. 购物建议必须说明衣橱缺口、至少三个复用场景，并先给出“不购买”的现有衣物替代方案；不要制造焦虑或鼓励冲动消费。
3. 如果信息不足，最多询问两个真正影响建议的问题。
4. 养护建议要区分面料，明确这是通用经验，并提醒用户优先查看衣物洗标。
5. 不分析或上传图片；你看到的是用户主动记录的文字摘要。

用户已拥有的衣物：
${ownedSummary.isEmpty ? '（衣橱尚未记录已拥有单品）' : ownedSummary}

用户愿望清单：
${wantedSummary.isEmpty ? '（暂无愿望清单）' : wantedSummary}

最近穿搭：
${recentSummary.isEmpty ? '（暂无近期穿搭记录）' : recentSummary}
''';
  }

  Future<String> send({
    required List<ChatMessage> messages,
    required List<ClothingItem> clothingItems,
    required List<OutfitEntry> outfits,
  }) async {
    if (!DeepSeekConfig.isConfigured) {
      throw const DeepSeekException(
        'DeepSeek API Key 尚未配置，请在 lib/config/deepseek_config.dart 中填入密钥。',
      );
    }

    try {
      final response = await _client
          .post(
            Uri.parse(DeepSeekConfig.endpoint),
            headers: {
              'Authorization': 'Bearer ${DeepSeekConfig.token}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': DeepSeekConfig.model,
              'temperature': 0.65,
              'max_tokens': 1200,
              'messages': [
                {
                  'role': 'system',
                  'content': buildSystemPrompt(
                    clothingItems: clothingItems,
                    outfits: outfits,
                  ),
                },
                ...messages.where((message) => !message.isError).map((message) {
                  return {
                    'role': message.role == ChatRole.user
                        ? 'user'
                        : 'assistant',
                    'content': message.content,
                  };
                }),
              ],
            }),
          )
          .timeout(const Duration(seconds: 35));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final detail = _extractError(response.body);
        throw DeepSeekException(
          response.statusCode == 401
              ? 'DeepSeek 密钥无效，请检查配置。'
              : 'AI 服务暂时不可用（${response.statusCode}）${detail.isEmpty ? '' : '：$detail'}',
        );
      }

      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final choices = body is Map<String, dynamic> ? body['choices'] : null;
      if (choices is! List || choices.isEmpty) {
        throw const DeepSeekException('AI 返回了无法识别的内容，请稍后重试。');
      }
      final first = choices.first;
      final message = first is Map<String, dynamic> ? first['message'] : null;
      final content = message is Map<String, dynamic>
          ? message['content']
          : null;
      if (content is! String || content.trim().isEmpty) {
        throw const DeepSeekException('AI 没有返回有效内容，请换一种问法。');
      }
      return content.trim();
    } on TimeoutException {
      throw const DeepSeekException('请求超时了，请检查网络后重试。');
    } on DeepSeekException {
      rethrow;
    } catch (_) {
      throw const DeepSeekException('网络连接失败，请检查网络后重试。');
    }
  }

  String _extractError(String source) {
    try {
      final body = jsonDecode(source);
      final error = body is Map<String, dynamic> ? body['error'] : null;
      final message = error is Map<String, dynamic> ? error['message'] : null;
      return message is String ? message : '';
    } catch (_) {
      return '';
    }
  }
}
