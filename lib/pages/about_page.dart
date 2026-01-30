import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/common_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.height < 600;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(isSmallScreen),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isSmallScreen ? 10 : 20),
                  _buildLogo(isSmallScreen),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Text(
                    '山海：洪荒纪元',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '版本 1.0.0',
                    style: TextStyle(
                      color: AppColors.textSub.withValues(alpha: 0.7),
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 40),
                  _buildInfoCard(
                    '我们的愿景',
                    '致力于打造一个充满想象力的山海经异兽世界，让玩家在探索中感受中国古代神话的魅力。',
                    Icons.auto_awesome_outlined,
                    isSmallScreen,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    '开发团队',
                    '由一群热爱神话故事和独立游戏的开发者共同打造。我们希望通过这款游戏，将古典文学与现代玩法完美结合。',
                    Icons.groups_outlined,
                    isSmallScreen,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    '联系我们',
                    '官方邮箱：contact@shanhai.com\n官方网站：www.shanhai.com',
                    Icons.alternate_email_outlined,
                    isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 30 : 60),
                  Text(
                    'Copyright © 2024 Shanhai Studio.\nAll Rights Reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSub.withValues(alpha: 0.4),
                      fontSize: isSmallScreen ? 10 : 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool isSmallScreen) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 100 : 120,
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '关于我们',
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isSmallScreen) {
    final double logoSize = isSmallScreen ? 80 : 100;
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.pets,
        size: isSmallScreen ? 40 : 50,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String content,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: isSmallScreen ? 18 : 20,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: isSmallScreen ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 13 : 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
