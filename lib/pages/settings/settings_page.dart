import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import 'about_page.dart';
import 'user_agreement_page.dart';
import 'privacy_policy_page.dart';
import 'help_page.dart';
import 'feedback_page.dart';
import 'size_profile_page.dart';
import '../wardrobe/style_preferences_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _tappable(VoidCallback onTap, Widget child) => InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    // 作为底部导航 Tab 时不可 pop，不显示关闭按钮；从其他页面 push 进入时显示
    final canPop = Navigator.canPop(context);
    return PageFrame(
    title: '设置',
    subtitle: '管理应用偏好',
    action: canPop ? Icons.close_rounded : null,
    onAction: canPop ? () => Navigator.pop(context) : null,
    children: [
      const SectionTitle(title: '偏好'),
      SoftCard(
        child: Column(
          children: [
            _tappable(
              () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const StylePreferencesPage()),
              ),
              const SettingRow(
                icon: Icons.auto_awesome,
                title: '风格偏好',
                caption: '管理我的风格与颜色偏好',
              ),
            ),
            _tappable(
              () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const SizeProfilePage()),
              ),
              const SettingRow(
                icon: Icons.straighten,
                title: '尺码管理',
                caption: '更新我的尺码信息',
              ),
            ),
          ],
        ),
      ),
      const SectionTitle(title: '帮助'),
      SoftCard(
        child: Column(
          children: [
            _tappable(
              () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const HelpPage()),
              ),
              const SettingRow(
                icon: Icons.help_outline,
                title: '使用帮助',
                caption: '常见问题与操作指南',
              ),
            ),
            _tappable(
              () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const AboutPage()),
              ),
              const SettingRow(
                icon: Icons.info_outline,
                title: '关于我们',
                caption: '版本信息与团队介绍',
              ),
            ),
            _tappable(
              () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const FeedbackPage()),
              ),
              const SettingRow(
                icon: Icons.rate_review_outlined,
                title: '反馈与建议',
                caption: '告诉我们你的想法',
              ),
            ),
          ],
        ),
      ),
      const SectionTitle(title: '法律信息'),
      SoftCard(
        child: Column(
          children: [
            _tappable(
              () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const UserAgreementPage()),
              ),
              const SettingRow(
                icon: Icons.description_outlined,
                title: '用户协议',
                caption: '阅读服务条款与使用规范',
              ),
            ),
            _tappable(
              () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const PrivacyPolicyPage()),
              ),
              const SettingRow(
                icon: Icons.lock_outline,
                title: '隐私协议',
                caption: '了解我们如何保护你的数据',
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Center(
        child: Text(
          '可伴 AI · v1.0.0',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 11,
          ),
        ),
      ),
    ],
    );
  }
}
