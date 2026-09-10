import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../models/chat_message.dart';
import '../../services/storage_service.dart';
import '../../services/ai_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  late StorageService _storageService;
  late AIService _aiService;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);
    _aiService = AIService();

    final history = await _storageService.getChatHistory();
    if (mounted) {
      setState(() {
        _messages = history;
        _isInitialized = true;
      });

      // Add welcome message if no history
      if (_messages.isEmpty) {
        _addWelcomeMessage();
      }
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: const Uuid().v4(),
      content: '欢迎，匠人。每一道裂痕都是一个等待用金线讲述的故事。我该如何指引您的修复之旅？',
      isUser: false,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _focusNode.unfocus();

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _aiService.AppendNewestCenterArray(
        text,
        history: _messages.take(_messages.length - 1).toList(),
      );

      if (mounted) {
        final aiMessage = ChatMessage(
          id: const Uuid().v4(),
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        );

        setState(() {
          _messages.add(aiMessage);
          _isLoading = false;
        });

        // Save both messages
        await _storageService.addChatMessage(userMessage);
        await _storageService.addChatMessage(aiMessage);

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get response: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _sendPresetPrompt(String prompt) {
    _messageController.text = prompt;
    _sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('清空聊天记录？', style: AppTextStyles.headline3),
        content: Text('这将删除您与金绪的所有对话。', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _storageService.clearChatHistory();
              setState(() {
                _messages.clear();
              });
              _addWelcomeMessage();
            },
            child: Text(
              '清空',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final headerVerticalPadding = isSmallScreen ? 10.0 : 12.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: !_isInitialized
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: headerVerticalPadding,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: isSmallScreen ? 44 : 48,
                            height: isSmallScreen ? 44 : 48,
                            decoration: BoxDecoration(
                              gradient: AppColors.purpleGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.purpleStart.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: isSmallScreen ? 10 : 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                              size: isSmallScreen ? 22 : 24,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 12 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '金绪',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 15 : 16,
                                  ),
                                ),
                                Text(
                                  '金缮大师向导',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _clearHistory,
                            child: Container(
                              width: isSmallScreen ? 36 : 40,
                              height: isSmallScreen ? 36 : 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(
                                  isSmallScreen ? 10 : 12,
                                ),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: AppColors.textSecondary,
                                size: isSmallScreen ? 18 : 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Messages
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        itemCount: _messages.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _messages.length && _isLoading) {
                            return _buildTypingIndicator(isSmallScreen);
                          }
                          return _buildMessageBubble(
                            _messages[index],
                            isSmallScreen,
                          );
                        },
                      ),
                    ),

                    // Preset Prompts
                    if (_messages.length <= 2)
                      Container(
                        height: isSmallScreen ? 44 : 50,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppConstants.aiPresetPrompts.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: isSmallScreen ? 6 : 8),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _sendPresetPrompt(
                                AppConstants.aiPresetPrompts[index],
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 12 : 16,
                                  vertical: isSmallScreen ? 8 : 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.coolGradient,
                                  borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 16 : 20,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.purpleStart.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    AppConstants.aiPresetPrompts[index],
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: isSmallScreen ? 11 : 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    // Input
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withAlpha(13),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                focusNode: _focusNode,
                                decoration: AppDecorations.inputDecoration(
                                  hintText: '向金绪提问...',
                                ),
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendMessage(),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 10 : 12),
                            GestureDetector(
                              onTap: _isLoading ? null : _sendMessage,
                              child: Container(
                                width: isSmallScreen ? 44 : 48,
                                height: isSmallScreen ? 44 : 48,
                                decoration: BoxDecoration(
                                  gradient: AppColors.pinkGradient,
                                  borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 14 : 16,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: isSmallScreen ? 18 : 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isSmallScreen) {
    final isUser = message.isUser;
    final bubblePadding = isSmallScreen ? 12.0 : 14.0;
    final avatarSize = isSmallScreen ? 28.0 : 32.0;
    final avatarIconSize = isSmallScreen ? 14.0 : 16.0;
    final spacing = isSmallScreen ? 6.0 : 8.0;

    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: avatarIconSize,
              ),
            ),
            SizedBox(width: spacing),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(bubblePadding),
              decoration: isUser
                  ? AppDecorations.userBubble()
                  : AppDecorations.aiBubble(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                      fontSize: isSmallScreen ? 13 : 14,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 3 : 4),
                  Text(
                    AppFormatters.formatTime(message.timestamp),
                    style: AppTextStyles.caption.copyWith(
                      color: isUser
                          ? Colors.white.withAlpha(179)
                          : AppColors.textLight,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) SizedBox(width: spacing),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isSmallScreen) {
    final avatarSize = isSmallScreen ? 28.0 : 32.0;
    final avatarIconSize = isSmallScreen ? 14.0 : 16.0;
    final spacing = isSmallScreen ? 6.0 : 8.0;
    final bubblePadding = isSmallScreen ? 12.0 : 14.0;
    final dotSize = isSmallScreen ? 6.0 : 8.0;

    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Row(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: avatarIconSize,
            ),
          ),
          SizedBox(width: spacing),
          Container(
            padding: EdgeInsets.all(bubblePadding),
            decoration: AppDecorations.aiBubble(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 1.5 : 2,
                  ),
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
