import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF1A3A34),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '关于我们',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A34),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 48,
                  color: AppColors.textMain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'MoodStyle',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A34),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Version 2.0.4',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ),
            const SizedBox(height: 32),

            _buildSection(
              icon: Icons.info_outline,
              title: '我们的使命',
              content:
                  'MoodStyle 帮助你记录每日心情并发现独特的穿搭风格。我们相信时尚与情感紧密相连，我们的应用让你真实地表达自我。',
            ),
            const SizedBox(height: 20),

            _buildSection(
              icon: Icons.star_outline,
              title: '核心功能',
              content:
                  '• 心情记录：记录每日情绪\n• 风格推荐：AI 驱动的穿搭建议\n• 社区互动：分享与发现风格\n• 个人分析：了解你的心情模式',
              isList: true,
            ),
            const SizedBox(height: 20),

            _buildSection(
              icon: Icons.people_outline,
              title: '我们的团队',
              content: '我们是一支充满激情的设计师、开发者和时尚爱好者团队，致力于创造最佳的心情穿搭记录体验。',
            ),
            const SizedBox(height: 20),

            _buildSection(
              icon: Icons.email_outlined,
              title: '联系我们',
              content: '有问题？请通过 support@moodstyle.app 联系我们',
            ),
            const SizedBox(height: 32),

            Center(
              child: Text(
                '© 2024 MoodStyle。保留所有权利。',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    bool isList = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryDark, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A34),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isList)
            ...content
                .split('\n')
                .map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        Expanded(
                          child: Text(
                            line.substring(2),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
          else
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
