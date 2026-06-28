import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../models/chat_message.dart';
import '../../models/clothing_item.dart';
import '../../models/outfit_entry.dart';
import '../../services/deepseek_service.dart';
import '../../widgets/ambient_background.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({
    super.key,
    required this.outfits,
    required this.clothingItems,
    required this.messages,
    required this.onMessagesChanged,
    this.service,
  });

  final List<OutfitEntry> outfits;
  final List<ClothingItem> clothingItems;
  final List<ChatMessage> messages;
  final Future<void> Function(List<ChatMessage> messages) onMessagesChanged;
  final DeepSeekService? service;

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  static const _quickQuestions = [
    '今天穿什么？',
    '衣橱缺什么？',
    '这件值得买吗？',
    '衣服怎么养护？',
    '一周搭配思路',
    '换季怎么收纳？',
  ];

  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final DeepSeekService _service = widget.service ?? DeepSeekService();
  late final List<ChatMessage> _messages = [...widget.messages];
  bool _sending = false;
  String? _lastQuestion;

  @override
  void didUpdateWidget(covariant AssistantPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sending && !identical(widget.messages, oldWidget.messages)) {
      _messages
        ..clear()
        ..addAll(widget.messages);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendQuestion(String raw, {bool addUserMessage = true}) async {
    final question = raw.trim();
    if (question.isEmpty || _sending) return;
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.clear();
    _lastQuestion = question;

    setState(() {
      _sending = true;
      _messages.removeWhere((message) => message.isError);
      if (addUserMessage) {
        _messages.add(
          ChatMessage(
            id: 'message_${DateTime.now().microsecondsSinceEpoch}',
            role: ChatRole.user,
            content: question,
            createdAt: DateTime.now(),
          ),
        );
      }
    });
    await widget.onMessagesChanged(_messages);
    _scrollToBottom();

    try {
      final answer = await _service.send(
        messages: _messages,
        clothingItems: widget.clothingItems,
        outfits: widget.outfits,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            id: 'message_${DateTime.now().microsecondsSinceEpoch}',
            role: ChatRole.assistant,
            content: answer,
            createdAt: DateTime.now(),
          ),
        );
      });
    } on DeepSeekException catch (error) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            id: 'error_${DateTime.now().microsecondsSinceEpoch}',
            role: ChatRole.assistant,
            content: error.message,
            createdAt: DateTime.now(),
            isError: true,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        await widget.onMessagesChanged(_messages);
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: AmbientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 20, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PERSONAL STYLIST',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'AI 穿搭助手',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '懂你的衣橱，也帮你理性购物',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickQuestions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final question = _quickQuestions[index];
                    return ActionChip(
                      label: Text(question),
                      avatar: Icon(
                        index == 3 ? Icons.eco_outlined : Icons.bolt_rounded,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      backgroundColor: Colors.white.withValues(alpha: 0.88),
                      side: const BorderSide(color: AppColors.divider),
                      onPressed: () => _sendQuestion(question),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _messages.isEmpty
                    ? _AssistantWelcome(
                        wardrobeCount: widget.clothingItems.length,
                        outfitCount: widget.outfits.length,
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                        itemCount: _messages.length + (_sending ? 1 : 0),
                        itemBuilder: (_, index) {
                          if (index == _messages.length) {
                            return const _TypingBubble();
                          }
                          final message = _messages[index];
                          return _MessageBubble(
                            message: message,
                            onRetry: message.isError && _lastQuestion != null
                                ? () => _sendQuestion(
                                    _lastQuestion!,
                                    addUserMessage: false,
                                  )
                                : null,
                          );
                        },
                      ),
              ),
              _ChatComposer(
                controller: _controller,
                sending: _sending,
                onSend: () => _sendQuestion(_controller.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistantWelcome extends StatelessWidget {
  const _AssistantWelcome({
    required this.wardrobeCount,
    required this.outfitCount,
  });

  final int wardrobeCount;
  final int outfitCount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: AspectRatio(
            aspectRatio: 2.4,
            child: Image.asset(
              'assets/images/ai_assistant_header.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('你好，我已经准备好了', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                wardrobeCount == 0
                    ? '衣橱还没有记录，我可以先帮你梳理购买清单和衣物养护问题。添加单品后，建议会更贴合你。'
                    : '我会结合你的 $wardrobeCount 件衣物和 $outfitCount 条穿搭记录，优先搭配已有单品，再给出克制的购物建议。',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, this.onRetry});

  final ChatMessage message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
        decoration: BoxDecoration(
          color: message.isError
              ? const Color(0xFFFFEEF0)
              : isUser
              ? AppColors.primary
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 6),
            bottomRight: Radius.circular(isUser ? 6 : 20),
          ),
          border: isUser
              ? null
              : Border.all(
                  color: message.isError
                      ? AppColors.danger.withValues(alpha: 0.2)
                      : AppColors.divider,
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isUser ? Colors.white : AppColors.ink,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 17),
                label: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14,
        10,
        14,
        MediaQuery.paddingOf(context).bottom + 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: '问搭配、购物或衣物养护……',
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 9),
          IconButton.filled(
            tooltip: '发送',
            onPressed: sending ? null : onSend,
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
        ],
      ),
    );
  }
}
