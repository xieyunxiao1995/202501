import 'package:flutter/material.dart';
import 'about_us_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_screen.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: isSmallScreen ? 20 : 24),
          onPressed: onClose,
        ),
        title: Text(
          "设置与信息",
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("游戏设置", [
              _buildMenuItem(
                icon: Icons.help_outline,
                title: "使用帮助",
                subtitle: "查看游戏指南和常见问题",
                isSmallScreen: isSmallScreen,
                onTap: () => _openScreen(
                  context,
                  HelpScreen(onClose: () => Navigator.pop(context)),
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              _buildMenuItem(
                icon: Icons.feedback_outlined,
                title: "反馈和建议",
                subtitle: "提交您的宝贵意见",
                isSmallScreen: isSmallScreen,
                onTap: () => _openScreen(
                  context,
                  FeedbackScreen(onClose: () => Navigator.pop(context)),
                ),
              ),
            ], isSmallScreen),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection("法律信息", [
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: "隐私协议",
                subtitle: "了解我们的隐私政策",
                isSmallScreen: isSmallScreen,
                onTap: () => _openScreen(
                  context,
                  PrivacyPolicyScreen(onClose: () => Navigator.pop(context)),
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: "用户协议",
                subtitle: "查看服务条款和使用规则",
                isSmallScreen: isSmallScreen,
                onTap: () => _openScreen(
                  context,
                  UserAgreementScreen(onClose: () => Navigator.pop(context)),
                ),
              ),
            ], isSmallScreen),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection("关于", [
              _buildMenuItem(
                icon: Icons.info_outline,
                title: "关于我们",
                subtitle: "了解开发团队和版本信息",
                isSmallScreen: isSmallScreen,
                onTap: () => _openScreen(
                  context,
                  AboutUsScreen(onClose: () => Navigator.pop(context)),
                ),
              ),
            ], isSmallScreen),
            SizedBox(height: isSmallScreen ? 24 : 32),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber, size: isSmallScreen ? 24 : 32),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    "温馨提示",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    "如有任何问题或建议，欢迎通过反馈页面联系我们。我们会认真阅读每一条建议，持续改进游戏体验。",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 12 : 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.amber,
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 40 : 48,
              height: isSmallScreen ? 40 : 48,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.amber, size: isSmallScreen ? 20 : 24),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white54, fontSize: isSmallScreen ? 11 : 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white38, size: isSmallScreen ? 20 : 24),
          ],
        ),
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
}
