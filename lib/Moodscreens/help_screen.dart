import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            pinned: false,
            elevation: 0,
            backgroundColor: const Color(0xFF000000),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF000000),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      const SizedBox(width: 40),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                          ).createShader(bounds),
                          child: const Text(
                            '使用帮助',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHelpSection(
                    '快速开始',
                    [
                      _HelpItem(
                        question: '如何创建第一篇日记？',
                        answer: '点击首页底部的 "+" 按钮，输入你的心情和想法，'
                            '选择情绪标签，还可以添加图片。完成后点击发布即可。',
                      ),
                      _HelpItem(
                        question: '如何使用 AI 助手 Mora？',
                        answer: '进入 AI 页面，直接与 Mora 对话。她会倾听你的心情，'
                            '提供情绪支持和建议。你也可以让她分析你的情绪模式。',
                      ),
                      _HelpItem(
                        question: '什么是情绪广场？',
                        answer: '情绪广场是一个匿名分享空间，你可以看到其他用户公开分享的心情，'
                            '也可以选择将自己的日记分享到广场，与他人产生共鸣。',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildHelpSection(
                    '日记管理',
                    [
                      _HelpItem(
                        question: '如何编辑或删除日记？',
                        answer: '点击日记进入详情页，点击右上角的菜单按钮，'
                            '选择"编辑"或"删除"。删除后的日记无法恢复，请谨慎操作。',
                      ),
                      _HelpItem(
                        question: '如何设置日记的隐私？',
                        answer: '创建或编辑日记时，可以选择"仅自己可见"或"分享到广场"。'
                            '私密日记只有你自己能看到，不会出现在情绪广场。',
                      ),
                      _HelpItem(
                        question: '如何添加图片？',
                        answer: '在编辑日记时，点击图片图标，可以从相册选择或拍照。'
                            '每篇日记支持添加一张图片。',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildHelpSection(
                    'AI 功能',
                    [
                      _HelpItem(
                        question: 'AI 分析是如何工作的？',
                        answer: 'Mora 会分析你的日记内容和情绪标签，识别情绪模式，'
                            '提供个性化的情绪洞察和建议。所有分析都在保护隐私的前提下进行。',
                      ),
                      _HelpItem(
                        question: '如何关闭 AI 分析？',
                        answer: '进入设置 > 隐私 > AI 分析权限，关闭开关即可。'
                            '关闭后，Mora 将无法访问你的日记内容。',
                      ),
                      _HelpItem(
                        question: 'AI 建议可靠吗？',
                        answer: 'Mora 的建议仅供参考，不能替代专业的心理咨询。'
                            '如果你有严重的心理健康问题，请寻求专业医生的帮助。',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildHelpSection(
                    '账户与安全',
                    [
                      _HelpItem(
                        question: '如何修改个人资料？',
                        answer: '进入设置 > 账户 > 个人资料，可以修改昵称、头像等信息。',
                      ),
                      _HelpItem(
                        question: '忘记密码怎么办？',
                        answer: '在登录页面点击"忘记密码"，输入注册手机号，'
                            '我们会发送验证码帮助你重置密码。',
                      ),
                      _HelpItem(
                        question: '如何导出我的数据？',
                        answer: '进入设置 > 隐私 > 导出数据，可以导出你的所有日记和数据。'
                            '导出的文件会保存到你的设备。',
                      ),
                      _HelpItem(
                        question: '如何删除账户？',
                        answer: '进入设置，滑到底部点击"退出登录"，然后选择"删除账户"。'
                            '删除后所有数据将被永久清除，无法恢复。',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildHelpSection(
                    '常见问题',
                    [
                      _HelpItem(
                        question: '为什么收不到通知？',
                        answer: '请检查：1) 设置中是否开启了通知权限；'
                            '2) 手机系统设置中是否允许 Moodora 发送通知；'
                            '3) 是否开启了勿扰模式。',
                      ),
                      _HelpItem(
                        question: '应用闪退怎么办？',
                        answer: '尝试：1) 重启应用；2) 清除缓存；3) 更新到最新版本；'
                            '4) 如果问题持续，请联系客服并提供设备型号和系统版本。',
                      ),
                      _HelpItem(
                        question: '如何联系客服？',
                        answer: '邮箱：support@moodora.com\n'
                            '客服热线：400-123-4567（工作日 9:00-18:00）\n'
                            '或在"反馈和建议"页面提交问题。',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8A7CF5).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.help_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '还有其他问题？',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '我们随时为你提供帮助',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to feedback screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF8A7CF5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '联系客服',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<_HelpItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8A7CF5),
            ),
          ),
        ),
        ...items.map((item) => _buildHelpItem(item)),
      ],
    );
  }

  Widget _buildHelpItem(_HelpItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Text(
            item.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
            ),
          ),
          iconColor: const Color(0xFF8A7CF5),
          collapsedIconColor: Colors.grey[500],
          children: [
            Text(
              item.answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpItem {
  final String question;
  final String answer;

  _HelpItem({required this.question, required this.answer});
}
