import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/common_widgets.dart';
import 'about_page.dart';
import 'user_agreement_page.dart';
import 'privacy_policy_page.dart';
import 'help_page.dart';
import 'feedback_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                padding: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
                child: _buildSettingsList(isSmallScreen),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: isSmallScreen ? 20 : 40),
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
        '设置',
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
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.settings_outlined,
                  size: isSmallScreen ? 120 : 150,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('关于与协议', isSmallScreen),
        _buildAboutSection(isSmallScreen),
        SizedBox(height: isSmallScreen ? 16 : 24),
        _buildSectionHeader('帮助与反馈', isSmallScreen),
        _buildSupportSection(isSmallScreen),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, isSmallScreen ? 8 : 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: isSmallScreen ? 12 : 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAboutSection(bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: '关于我们',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            ),
            isSmallScreen: isSmallScreen,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: '用户协议',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserAgreementPage()),
            ),
            isSmallScreen: isSmallScreen,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: '隐私政策',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
            ),
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: '使用帮助',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpPage()),
            ),
            isSmallScreen: isSmallScreen,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.feedback_outlined,
            title: '反馈建议',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackPage()),
            ),
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textMain, size: isSmallScreen ? 20 : 24),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmallScreen ? 14 : 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSub, size: 20),
      onTap: onTap,
      dense: isSmallScreen,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: Colors.white.withValues(alpha: 0.05),
    );
  }
}
