import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_screen.dart';
import 'feedback_screen.dart';

/// 设置页面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  bool _showFPS = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('设置'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00F0FF),
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 音效设置分组
          const SizedBox(height: 20),

          // 帮助与支持分组
          _buildSectionTitle('帮助与支持'),
          _buildNavTile(
            icon: Icons.info_outline,
            title: '关于我们',
            onTap: () => _navigateTo(const AboutScreen()),
          ),
          _buildNavTile(
            icon: Icons.description_outlined,
            title: '用户协议',
            onTap: () => _navigateTo(const UserAgreementScreen()),
          ),
          _buildNavTile(
            icon: Icons.privacy_tip_outlined,
            title: '隐私政策',
            onTap: () => _navigateTo(const PrivacyPolicyScreen()),
          ),
          _buildNavTile(
            icon: Icons.help_outline,
            title: '使用帮助',
            onTap: () => _navigateTo(const HelpScreen()),
          ),
          _buildNavTile(
            icon: Icons.feedback_outlined,
            title: '反馈与建议',
            onTap: () => _navigateTo(const FeedbackScreen()),
          ),
          const SizedBox(height: 30),

          // 版本号
          Center(
            child: Text(
              '星轨防线 v1.0.0',
              style: const TextStyle(fontSize: 12, color: Color(0xFF445566)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00F0FF),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00F0FF), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8899AA),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00F0FF),
            activeTrackColor: const Color(0xFF00F0FF).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00F0FF), size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF445566),
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
