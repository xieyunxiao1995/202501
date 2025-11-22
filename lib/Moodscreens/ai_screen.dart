import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../Moodmodels/chat_message.dart';
import '../Moodservices/storage_service.dart';
import '../Moodservices/ai_service.dart';

class AIScreen extends StatefulWidget {
  final StorageService storageService;
  const AIScreen({super.key, required this.storageService});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final TextEditingController _messageController = TextEditingController();
  final AIService _aiService = AIService();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _addWelcomeMessage();
  }

  Future<void> _loadMessages() async {
    final messages = await widget.storageService.getChatMessages();
    setState(() {
      _messages.addAll(messages);
    });
  }

  void _addWelcomeMessage() {
    if (_messages.isEmpty) {
      final welcomeMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '你好！我是 Mora，你的情绪陪伴者。今天感觉怎么样？',
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(welcomeMessage);
      });
      widget.storageService.saveChatMessage(welcomeMessage);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    widget.storageService.saveChatMessage(userMessage);

    try {
      final response = await _aiService.GetStaticVectorManager(messageText);

      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(aiMessage);
        _isTyping = false;
      });

      widget.storageService.saveChatMessage(aiMessage);
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('无法连接到 AI，请稍后再试'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白区域收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF000000),
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8A7CF5).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                              ).createShader(bounds),
                              child: const Text(
                                'Mora',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF50C878),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '在线 · 倾听中',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                 
                  ],
                ),
              ),
            ),
            // Messages list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  final message = _messages[index];
                  return _buildMessage(message);
                },
              ),
            ),
            // Bottom input area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quick emotion buttons
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildQuickEmotionButton('#疲惫'),
                        _buildQuickEmotionButton('#开心'),
                        _buildQuickEmotionButton('#迷茫'),
                        _buildQuickEmotionButton('#平静'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Input area
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.mic_none,
                              color: Colors.grey[500],
                              size: 22,
                            ),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              maxLines: null,
                              maxLength: 500,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE0E0E0),
                              ),
                              decoration: InputDecoration(
                                hintText: '和 Mora 聊聊你的感受...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                ),
                                border: InputBorder.none,
                                counterText: '',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF8A7CF5),
                                  Color(0xFF6B5BFF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8A7CF5).withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _sendMessage,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8A7CF5),
                    Color(0xFF6B5BFF),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A7CF5).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF8A7CF5),
                          Color(0xFF6B5BFF),
                        ],
                      )
                    : null,
                color: message.isUser ? null : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: message.isUser ? const Radius.circular(22) : const Radius.circular(6),
                  bottomRight: message.isUser ? const Radius.circular(6) : const Radius.circular(22),
                ),
                boxShadow: message.isUser
                    ? [
                        BoxShadow(
                          color: const Color(0xFF8A7CF5).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: message.isUser ? Colors.white : const Color(0xFFE0E0E0),
                  fontSize: 14,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF8A7CF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8A7CF5),
                  Color(0xFF6B5BFF),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(),
                const SizedBox(width: 4),
                _buildTypingDot(delay: 0.2),
                const SizedBox(width: 4),
                _buildTypingDot(delay: 0.4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot({double delay = 0}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      onEnd: () {},
      child: AnimatedBuilder(
        animation: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(
          parent: AlwaysStoppedAnimation(1),
          curve: Interval(0, 1),
        )),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, sin((delay) * pi) * 4),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF8A7CF5).withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickEmotionButton(String emotion) {
    return GestureDetector(
      onTap: () {
        _messageController.text = '$emotion ';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          emotion,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
