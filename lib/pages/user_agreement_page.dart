import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/common_widgets.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

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
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '欢迎阅读《山海：洪荒纪元 用户协议》',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  _buildSection(
                    '1. 协议声明',
                    '本协议是您与《山海：洪荒纪元》游戏团队（以下简称“我们”）之间关于您下载、安装、使用本游戏所订立的协议。请务必审慎阅读、充分理解各条款内容。',
                    isSmallScreen,
                  ),
                  _buildSection(
                    '2. 账号注册',
                    '本游戏目前采用本地存储机制，不强制要求注册账号。您的所有游戏进度均保存在您的本地设备中。请妥善保管您的设备，防止数据丢失。',
                    isSmallScreen,
                  ),
                  _buildSection(
                    '3. 行为准则',
                    '用户在使用本游戏过程中应遵守法律法规，不得利用本游戏从事违法违规活动。禁止任何形式的作弊、利用漏洞（Bug）牟利或干扰游戏正常秩序的行为。',
                    isSmallScreen,
                  ),
                  _buildSection(
                    '4. 虚拟物品',
                    '游戏中获得的“灵气”、“血肉”等虚拟物品仅限在游戏内使用。我们不提供任何形式的虚拟物品交易或变现服务。',
                    isSmallScreen,
                  ),
                  _buildSection(
                    '5. 免责声明',
                    '由于本游戏主要运行于本地环境，因设备损坏、系统更新、误删应用等原因导致的数据丢失，我们不承担赔偿责任。我们将尽力维护游戏的稳定性，但不保证游戏永远不会出现技术问题。',
                    isSmallScreen,
                  ),
                  _buildSection(
                    '6. 协议修改',
                    '我们有权在必要时修改本协议条款。协议条款变更后，如果您继续使用本游戏，即视为您已接受修改后的协议。',
                    isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 40),
                  Center(
                    child: Text(
                      '生效日期：2024年12月25日',
                      style: TextStyle(
                        color: AppColors.textSub.withValues(alpha: 0.5),
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
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
        '用户协议',
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

  Widget _buildSection(String title, String content, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 20.0 : 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: isSmallScreen ? 14 : 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
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
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.03),
                width: 1,
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: isSmallScreen ? 13 : 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
