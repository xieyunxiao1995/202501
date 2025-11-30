import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dual_glow_background.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '使用帮助',
          style: TextStyle(color: AppColors.ink),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DualGlowBackground(
        child: Center(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Transform.rotate(
              angle: 0.01,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardFace,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '心屿使用指南',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildHelpItem(
                        icon: Icons.home,
                        title: '记忆牌桌',
                        description: '在首页，您的日记会以卡片形式展示在虚拟的牌桌上。最新的日记会显示在最上方。点击任意卡片即可查看详情。',
                      ),
                      
                      _buildHelpItem(
                        icon: Icons.edit,
                        title: '创建日记',
                        description: '点击右下角的"+"按钮开始写日记。您可以：\n• 输入标题和内容\n• 添加标签分类\n• 选择心情图标\n• 插入照片',
                      ),
                      
                      _buildHelpItem(
                        icon: Icons.grid_view,
                        title: '广场',
                        description: '在广场页面，您可以看到所有日记的网格视图，方便快速浏览和查找。',
                      ),
                      
                      _buildHelpItem(
                        icon: Icons.chat,
                        title: 'AI陪伴',
                        description: '在陪伴页面，您可以与AI助手聊天，分享心情，获得倾听和建议。需要配置DeepSeek API密钥才能使用此功能。',
                      ),
                      
                      _buildHelpItem(
                        icon: Icons.search,
                        title: '搜索日记',
                        description: '使用搜索功能可以快速找到特定的日记。支持按标题、内容、标签搜索。',
                      ),
                      
                      _buildHelpItem(
                        icon: Icons.label,
                        title: '标签管理',
                        description: '为日记添加标签可以更好地分类和管理。点击标签可以筛选相关日记。',
                      ),
                      
                      _buildHelpItem(
                        icon: Icons.delete,
                        title: '删除日记',
                        description: '在日记详情页面，长按或点击删除按钮可以删除日记。删除操作需要确认。',
                      ),
                      
                      _buildHelpItem(
                        icon: Icons.backup,
                        title: '数据备份',
                        description: '建议定期导出数据进行备份。所有数据存储在本地，卸载应用会导致数据丢失。',
                      ),
                      
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.ink.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.tips_and_updates, color: AppColors.ink, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  '小贴士',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '• 每天坚持记录，让记忆更完整\n'
                              '• 使用标签让日记更有条理\n'
                              '• 添加照片让回忆更生动\n'
                              '• 定期回顾过往日记，感受成长',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: AppColors.ink.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.ink, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.ink.withValues(alpha: 0.8),
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
