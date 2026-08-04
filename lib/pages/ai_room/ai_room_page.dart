import 'package:flutter/material.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import '../ai_styling/ai_history_page.dart';

class AiRoomPage extends StatefulWidget {
  const AiRoomPage({super.key});
  @override
  State<AiRoomPage> createState() => _AiRoomPageState();
}

class _AiRoomPageState extends State<AiRoomPage> {
  final controller = TextEditingController();
  final _scrollController = ScrollController();
  final messages = <_Message>[
    const _Message(text: '明天穿什么？', isUser: true),
    const _Message(text: '明天温度较低，可以尝试针织衫搭配半裙，外面加一件柔软的短外套。', isUser: false),
  ];
  bool replying = false;

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _send([String? preset]) async {
    final text = (preset ?? controller.text).trim();
    if (text.isEmpty || replying) return;
    controller.clear();
    setState(() {
      messages.add(_Message(text: text, isUser: true));
      replying = true;
    });
    _scrollToBottom();
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      replying = false;
      messages.add(_Message(text: _replyFor(text), isUser: false));
    });
    _scrollToBottom();
  }

  String _replyFor(String text) {
    if (text.contains('天气')) return '今天适合轻薄叠穿，建议选择浅色上衣和舒适的鞋子。';
    if (text.contains('颜色')) return '可以试试米色、浅紫或奶油白，和你的衣橱很容易搭配。';
    if (text.contains('复盘')) return '今天的搭配很完整：颜色统一、层次清楚，下次可以加一点小配饰。';
    return '我会优先从你的衣橱里找适合的单品，先从简约舒适的搭配开始吧。';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppBackground.base,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        '灵感陪聊房',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.history_rounded, color: AppColors.ink),
          onPressed: () => Navigator.push(
            context,
            FadeSlideRoute(builder: (_) => const AiHistoryPage()),
          ),
        ),
      ],
    ),
    body: AppBackground(
      child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.lavender, AppColors.deepLavender],
                          ),
                        ),
                        child: Image.asset(AssetPaths.robot, width: 34, height: 34),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI 穿搭助手',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '本地模拟对话 · 随时聊穿搭',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Pill('在线', green: true),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // 快捷提问
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.wb_sunny_outlined, size: 16),
                      label: const Text('明日天气'),
                      onPressed: () => _send('明日天气'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.palette_outlined, size: 16),
                      label: const Text('色彩推荐'),
                      onPressed: () => _send('给我色彩推荐'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.analytics_outlined, size: 16),
                      label: const Text('搭配复盘'),
                      onPressed: () => _send('帮我搭配复盘'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // 对话消息
                for (final message in messages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: message.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!message.isUser)
                          Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [AppColors.lavender, AppColors.deepLavender],
                              ),
                            ),
                            child: Image.asset(AssetPaths.robot, width: 20, height: 20),
                          ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 11,
                            ),
                            constraints: const BoxConstraints(maxWidth: 260),
                            decoration: BoxDecoration(
                              color: message.isUser
                                  ? const Color(0xFFEDE3FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                                bottomRight: Radius.circular(message.isUser ? 4 : 16),
                              ),
                              boxShadow: message.isUser
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: .04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Text(
                              message.text,
                              style: const TextStyle(fontSize: 13, height: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (replying)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.lavender, AppColors.deepLavender],
                            ),
                          ),
                          child: Image.asset(AssetPaths.robot, width: 20, height: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.lavender.withValues(alpha: .6),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '正在思考…',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        // 固定底部输入栏
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: '聊聊今天想穿什么…',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF6F3FA),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _send,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.deepLavender,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 20),
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

class _Message {
  final String text;
  final bool isUser;
  const _Message({required this.text, required this.isUser});
}
