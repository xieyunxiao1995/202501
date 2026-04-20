import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import '../theme/theme.dart';

class AiStylistChatPage extends StatefulWidget {
  const AiStylistChatPage({super.key});

  @override
  State<AiStylistChatPage> createState() => _AiStylistChatPageState();
}

class _AiStylistChatPageState extends State<AiStylistChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];
  bool _isWaitingForResponse = false;
  bool _hasAskedNeeds = false;

  final List<String> _quickSuggestions = ['通勤穿搭', '约会造型', '运动风格', '派对装扮'];

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  void _addInitialMessage() {
    _messages.add(
      ChatMessage(
        text:
            '你好！我是小搭 ✨\n\n请告诉我你的需求，例如：\n• 今天要去什么场合？\n• 喜欢什么风格？\n• 天气如何？\n\n我会为你搭配最合适的造型！',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(
        ChatMessage(text: text.trim(), isUser: true, timestamp: DateTime.now()),
      );
    });

    _scrollToBottom();

    if (!_hasAskedNeeds) {
      _hasAskedNeeds = true;
      _generateAIResponse(text.trim(), isFirstAsk: true);
    } else {
      _generateAIResponse(text.trim());
    }
  }

  Future<void> _generateAIResponse(
    String userMessage, {
    bool isFirstAsk = false,
  }) async {
    setState(() {
      _isWaitingForResponse = true;
    });

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 15);

      final request = await client.postUrl(
        Uri.parse('https://ark.cn-beijing.volces.com/api/v3/responses'),
      );
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ark-977e354d-0328-428d-9728-6bb22f5586b2-e3d4c',
      );
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final List<Map<String, dynamic>> conversationHistory = [
        {
          "role": "system",
          "content": [
            {"type": "input_text", "text": _buildSystemPrompt()},
          ],
        },
      ];

      for (final msg in _messages) {
        conversationHistory.add({
          "role": msg.isUser ? "user" : "assistant",
          "content": [
            {"type": "input_text", "text": msg.text},
          ],
        });
      }

      conversationHistory.add({
        "role": "user",
        "content": [
          {"type": "input_text", "text": userMessage},
        ],
      });

      final payload = {
        "model": "doubao-seed-1-8-251228",
        "input": conversationHistory,
      };

      request.add(utf8.encode(jsonEncode(payload)));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final jsonResponse = jsonDecode(responseBody);

      String aiResponse = '';

      if (jsonResponse['choices'] != null &&
          jsonResponse['choices'].isNotEmpty) {
        aiResponse = jsonResponse['choices'][0]['message']['content'] ?? '';
      } else if (jsonResponse['output'] != null &&
          jsonResponse['output']['text'] != null) {
        aiResponse = jsonResponse['output']['text'];
      } else if (jsonResponse['text'] != null) {
        aiResponse = jsonResponse['text'];
      }

      if (aiResponse.trim().isEmpty) {
        throw Exception("Empty AI response");
      }

      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: aiResponse.trim(),
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isWaitingForResponse = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('AI API Error: $e');
      _generateLocalResponse(userMessage, isFirstAsk: isFirstAsk);
    }
  }

  String _buildSystemPrompt() {
    return '''你是一位专业的AI穿搭造型师，名叫"StyleAI"。你的职责是帮助用户搭配最适合的服装造型。

【核心规则】
1. 你只能讨论与穿搭、服装、造型相关的话题
2. 如果用户提到与穿搭无关的话题，请礼貌地回复："抱歉，我是一位专业的穿搭造型师，只能为您提供穿搭相关的建议哦～请告诉我您的穿搭需求吧！"
3. 必须先询问用户的需求（场合、风格偏好、天气、身材特点等），再给出穿搭建议
4. 使用中文回复，语言亲切自然
5. 穿搭建议要具体、实用、有时尚感
6. 拒绝回答与穿搭无关的问题，例如："我是一个专业的穿搭造型师，只能为您提供穿搭相关的建议哦～请告诉我您的穿搭需求吧！"

【回复格式】
- 首次回复时，先询问用户需求
- 了解需求后，按照以下格式回复：
  🎯 推荐造型
  👕 上装：[具体描述]
  👖 下装：[具体描述]
  👟 鞋履：[具体描述]
  🎒 配饰：[具体描述]
  💡 搭配要点：[简短说明]

【风格要求】
- 语言亲切，像朋友一样自然
- 适当使用emoji增加趣味性
- 建议要实用且时尚
- 考虑场合、天气、个人特点等因素''';
  }

  void _generateLocalResponse(String userMessage, {bool isFirstAsk = false}) {
    final responses = {
      '通勤':
          '🎯 通勤造型推荐\n\n👕 上装：简约白色衬衫，干练又不失气质\n👖 下装：高腰直筒西装裤，修饰腿型\n👟 鞋履：低跟尖头单鞋，舒适好走\n🎒 配饰：精致手表+简约托特包\n💡 搭配要点：保持干净利落的线条感，颜色以中性色为主',
      '约会':
          '🎯 约会造型推荐\n\n👕 上装：温柔针织开衫，增添亲和力\n👖 下装：A字半身裙，优雅又显瘦\n👟 鞋履：细带凉鞋或玛丽珍鞋\n🎒 配饰：珍珠耳环+链条小包\n💡 搭配要点：柔和的色调，突出女性魅力',
      'default':
          '收到你的需求！让我为你搭配一套时尚造型吧～\n\n🎯 今日推荐\n👕 上装：简约百搭款，舒适又有型\n👖 下装：修身剪裁，展现好比例\n👟 鞋履：时尚休闲鞋，百搭不出错\n🎒 配饰：点睛之笔，提升整体质感\n💡 搭配要点：保持整体色调协调，突出个人风格',
    };

    String response = responses['default']!;
    for (final key in responses.keys) {
      if (userMessage.contains(key)) {
        response = responses[key]!;
        break;
      }
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: response,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isWaitingForResponse = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  Widget _buildQuickSuggestions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '快捷选择',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _quickSuggestions.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _handleSubmitted(suggestion);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textMain,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primaryDark,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                '小搭',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length + (_isWaitingForResponse ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isWaitingForResponse && index == _messages.length) {
                    return _buildLoadingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            if (_messages.length <= 1 && !_isWaitingForResponse)
              _buildQuickSuggestions(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SelectableText(
                message.text,
                style: TextStyle(
                  fontSize: 15,
                  color: isUser ? Colors.white : AppColors.textMain,
                  height: 1.6,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 20, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '正在为你搭配...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? AppColors.primary.withOpacity(0.5)
                        : Colors.grey.shade200,
                    width: _focusNode.hasFocus ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: '告诉我你的穿搭需求...',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textMain,
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                _handleSubmitted(_textController.text);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
