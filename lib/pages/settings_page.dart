import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/dual_glow_background.dart';
import 'settings/about_page.dart';
import 'settings/user_agreement_page.dart';
import 'settings/privacy_policy_page.dart';
import 'settings/help_page.dart';
import 'settings/feedback_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DualGlowBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Transform.rotate(
              angle: 0.02,
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
                child: Stack(
                  children: [
                    // 纸张纹理
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.2,
                        child: CustomPaint(
                          painter: LinedPaperPainter(),
                        ),
                      ),
                    ),
                    
                    // 内容
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          // 标题
                          const Text(
                            '设置',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 4,
                            width: 64,
                            decoration: BoxDecoration(
                              color: AppColors.ink.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // 菜单项
                          _buildMenuItem(
                            context,
                            icon: Icons.info_outline,
                            label: '关于我们',
                            onTap: () => _navigateToPage(context, const AboutPage()),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.description,
                            label: '用户协议',
                            onTap: () => _navigateToPage(context, const UserAgreementPage()),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.privacy_tip,
                            label: '隐私协议',
                            onTap: () => _navigateToPage(context, const PrivacyPolicyPage()),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.help_outline,
                            label: '使用帮助',
                            onTap: () => _navigateToPage(context, const HelpPage()),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.feedback,
                            label: '反馈与建议',
                            onTap: () => _navigateToPage(context, const FeedbackPage()),
                          ),

                          const SizedBox(height: 32),
                          Text(
                            '让记忆在时间中流淌 · MindFlow',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: AppColors.ink.withValues(alpha: 0.3),
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
    );
  }

  static Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.05)
                    : AppColors.ink.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.8)
                    : AppColors.ink,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDestructive
                      ? Colors.red.withValues(alpha: 0.8)
                      : AppColors.ink,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.inkLight.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  static void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class LinedPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ink.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += 32) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
