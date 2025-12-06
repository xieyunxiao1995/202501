import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AppGuideScreen extends StatelessWidget {
  const AppGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.6, 1.0],
            colors: [
              Color(0xFFF8FAFF),
              Color(0xFFEDF4FF),
              Color(0xFFE8F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppConstants.spacing20),
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: AppConstants.spacing20),
                    _buildGuideCard(
                      icon: Icons.explore,
                      iconColor: const Color(0xFF4A90E2),
                      iconBg: const Color(0xFFE3F2FD),
                      title: '开始使用',
                      steps: [
                        '创建您的账户并设置个人资料',
                        '浏览发现标签页查找露营地点',
                        '加入社区与他人建立联系',
                        '开始您的第一个露营日志来追踪冒险',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildGuideCard(
                      icon: Icons.map,
                      iconColor: const Color(0xFF66BB6A),
                      iconBg: const Color(0xFFE8F5E9),
                      title: '规划您的旅行',
                      steps: [
                        '使用发现功能搜索露营地点',
                        '查看天气预报和路线状况',
                        '在"我的计划"部分创建计划',
                        '邀请朋友并分享您的行程',
                        '使用我们的清单功能打包装备',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildGuideCard(
                      icon: Icons.book,
                      iconColor: const Color(0xFFFF9800),
                      iconBg: const Color(0xFFFFF3E0),
                      title: '创建露营日志',
                      steps: [
                        '点击"+"按钮创建新日志',
                        '添加照片、视频和描述',
                        '标记您的位置和同伴',
                        '评价您的体验并添加提示',
                        '与社区分享或保持私密',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildGuideCard(
                      icon: Icons.camera_alt,
                      iconColor: const Color(0xFF9C27B0),
                      iconBg: const Color(0xFFF3E5F5),
                      title: '分享体验',
                      steps: [
                        '在社区发布照片和故事',
                        '使用标签触达更多人',
                        '通过评论与他人互动',
                        '关注您欣赏的创作者',
                        '建立您的露营作品集',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildGuideCard(
                      icon: Icons.smart_toy,
                      iconColor: const Color(0xFFE91E63),
                      iconBg: const Color(0xFFFCE4EC),
                      title: '使用 AI 助手',
                      steps: [
                        '从社区标签页访问露营助手',
                        '询问有关露营装备的问题',
                        '获取个性化推荐',
                        '学习安全提示和最佳实践',
                        '发现新的露营技巧',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildGuideCard(
                      icon: Icons.tips_and_updates,
                      iconColor: const Color(0xFF00BCD4),
                      iconBg: const Color(0xFFE0F7FA),
                      title: '专业提示',
                      steps: [
                        '启用天气警报通知',
                        '保存您喜欢的地点以便快速访问',
                        '在偏远地区使用离线模式',
                        '参加挑战赢取徽章',
                        '为社区百科做贡献',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing12,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppConstants.primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            '应用指南',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading3,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.menu_book, size: 48, color: Colors.white),
          const SizedBox(height: AppConstants.spacing16),
          const Text(
            '欢迎使用 真遇圈！',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            '通过我们的综合指南，学习如何充分利用您的露营冒险。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required List<String> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(width: AppConstants.spacing16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeHeading3,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacing12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacing12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        step,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
