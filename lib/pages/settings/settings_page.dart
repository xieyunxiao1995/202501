import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../widgets/ambient_background.dart';
import 'about_page.dart';
import 'feedback_page.dart';
import 'help_page.dart';
import 'privacy_policy_page.dart';
import 'user_agreement_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.outfitCount,
    required this.clothingCount,
    required this.onClearData,
  });

  final int outfitCount;
  final int clothingCount;
  final Future<void> Function() onClearData;

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.danger),
        title: const Text('清空所有本地数据？'),
        content: const Text('穿搭、衣橱和 AI 聊天记录都会被删除，操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认清空'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await onClearData();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('本地数据已清空。')));
    }
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return AmbientBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: [
            Text(
              'SETTINGS',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 7),
            Text('设置', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF172033), Color(0xFF315EA8)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22172033),
                    blurRadius: 26,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.insights_rounded, color: Colors.white),
                      SizedBox(width: 9),
                      Text(
                        '我的数据',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _Statistic(value: '$outfitCount', label: '穿搭记录'),
                      ),
                      Container(width: 1, height: 42, color: Colors.white24),
                      Expanded(
                        child: _Statistic(
                          value: '$clothingCount',
                          label: '衣橱单品',
                        ),
                      ),
                      Container(width: 1, height: 42, color: Colors.white24),
                      Expanded(
                        child: _Statistic(
                          value: '${outfitCount + clothingCount}',
                          label: '全部记录',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _SettingsGroup(
              title: '支持',
              children: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  color: const Color(0xFF4F83EA),
                  title: '使用帮助',
                  onTap: () => _open(context, const HelpPage()),
                ),
                _SettingsTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  color: const Color(0xFFF08AA6),
                  title: '反馈与建议',
                  onTap: () => _open(context, const FeedbackPage()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _SettingsGroup(
              title: '关于',
              children: [
                _SettingsTile(
                  icon: Icons.favorite_border_rounded,
                  color: const Color(0xFFED7C98),
                  title: '关于我们',
                  onTap: () => _open(context, const AboutPage()),
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  color: const Color(0xFF668CE5),
                  title: '用户协议',
                  onTap: () => _open(context, const UserAgreementPage()),
                ),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  color: const Color(0xFF56A79B),
                  title: '隐私协议',
                  onTap: () => _open(context, const PrivacyPolicyPage()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _SettingsGroup(
              title: '数据管理',
              children: [
                _SettingsTile(
                  icon: Icons.delete_outline_rounded,
                  color: AppColors.danger,
                  title: '清空本地数据',
                  titleColor: AppColors.danger,
                  onTap: () => _confirmClear(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'CPDD小屋 · Made for your everyday style',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 9),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.muted,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.divider),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final Color color;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 62,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 21),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
      onTap: onTap,
    );
  }
}
