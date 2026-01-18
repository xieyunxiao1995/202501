import 'package:flutter/material.dart';
import '../screens/about_us_screen.dart';
import '../screens/user_agreement_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/help_screen.dart';
import '../screens/feedback_screen.dart';

class SettingsDialog extends StatefulWidget {
  final VoidCallback onClose;

  const SettingsDialog({super.key, required this.onClose});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.settings, color: Colors.white70, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    "设置与信息",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: "使用帮助",
                    subtitle: "查看游戏指南和常见问题",
                    onTap: () => _openScreen(HelpScreen(onClose: () => Navigator.pop(context))),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.feedback_outlined,
                    title: "反馈和建议",
                    subtitle: "提交您的宝贵意见",
                    onTap: () => _openScreen(FeedbackScreen(onClose: () => Navigator.pop(context))),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: "隐私协议",
                    subtitle: "了解我们的隐私政策",
                    onTap: () => _openScreen(PrivacyPolicyScreen(onClose: () => Navigator.pop(context))),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: "用户协议",
                    subtitle: "查看服务条款和使用规则",
                    onTap: () => _openScreen(UserAgreementScreen(onClose: () => Navigator.pop(context))),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: "关于我们",
                    subtitle: "了解开发团队和版本信息",
                    onTap: () => _openScreen(AboutUsScreen(onClose: () => Navigator.pop(context))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.amber,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  void _openScreen(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}
