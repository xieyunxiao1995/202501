import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dual_glow_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '关于我们',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: DualGlowBackground(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo 和应用名
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.calm.withValues(alpha: 0.8),
                          AppColors.joy.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.calm.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '心屿 MindFlow',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.calm.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'v2.1.0',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.calm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // 应用介绍
            _buildSection(
              title: '应用简介',
              icon: Icons.info_outline,
              content: '心屿是一款基于"记忆牌桌"概念的沉浸式日记应用。我们相信，每一段记忆都值得被珍藏，每一个情绪都值得被理解。\n\n通过独特的卡片式设计和AI智能分析，心屿帮助你更好地记录生活、整理思绪、理解自己。',
            ),
            
            const SizedBox(height: 24),
            
            // 核心功能
            _buildSection(
              title: '核心功能',
              icon: Icons.star_outline,
              content: '',
              children: [
                _buildFeatureItem('📝', '记忆卡片', '用卡片记录每一个值得铭记的瞬间'),
                _buildFeatureItem('🎨', '心情追踪', '四种心情色彩，映射你的情绪变化'),
                _buildFeatureItem('✨', 'AI 洞察', '智能分析日记，提供温暖的情感回应'),
                _buildFeatureItem('💬', 'AI 伴侣小忆', '随时倾听你的心声，陪你聊天解忧'),
                _buildFeatureItem('🌍', '记忆广场', '分享你的故事，感受他人的温度'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 设计理念
            _buildSection(
              title: '设计理念',
              icon: Icons.palette_outlined,
              content: '我们追求简约而不简单的设计。温暖的色调、流畅的动画、精致的细节，每一处都经过精心打磨，只为给你最舒适的使用体验。',
            ),
            
            const SizedBox(height: 24),
            
            // 团队信息
            _buildSection(
              title: '开发团队',
              icon: Icons.people_outline,
              content: '心屿由一群热爱生活、关注心理健康的开发者打造。我们希望通过技术的力量，让每个人都能更好地认识自己、关爱自己。',
            ),
            
            const SizedBox(height: 48),
            
            // 底部标语
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '让记忆在时间中流淌',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: AppColors.ink,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '© 2024 MindFlow Team',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.inkLight.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
    List<Widget>? children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: AppColors.calm),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.8,
                color: AppColors.ink.withValues(alpha: 0.8),
                letterSpacing: 0.3,
              ),
            ),
          ],
          if (children != null) ...[
            const SizedBox(height: 12),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.inkLight.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
