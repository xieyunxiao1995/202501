import 'package:flutter/material.dart';

import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import 'about_us_screen.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';
import 'settings_info_screen.dart';
import 'user_agreement_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _entries = <_SettingsEntry>[
    _SettingsEntry(
      title: 'About Us',
      subtitle: 'Learn about Solitaire Journey',
      icon: Icons.info_outline_rounded,
      page: AboutUsScreen(),
    ),
    _SettingsEntry(
      title: 'User Agreement',
      subtitle: 'Read the rules for using the app',
      icon: Icons.handshake_outlined,
      page: UserAgreementScreen(),
    ),
    _SettingsEntry(
      title: 'Privacy Policy',
      subtitle: 'Understand how local data is handled',
      icon: Icons.privacy_tip_outlined,
      page: PrivacyPolicyScreen(),
    ),
    _SettingsEntry(
      title: 'Help',
      subtitle: 'Learn how to play and solve common issues',
      icon: Icons.help_outline_rounded,
      page: HelpScreen(),
    ),
    _SettingsEntry(
      title: 'Feedback & Suggestions',
      subtitle: 'Share ideas for future improvements',
      icon: Icons.feedback_outlined,
      page: FeedbackScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) => FeltScaffold(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const SettingsPageHeader(
          title: 'Settings',
          icon: Icons.settings_rounded,
        ),
        const SizedBox(height: 16),
        GoldPanel(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              for (var index = 0; index < _entries.length; index++) ...[
                _SettingsTile(
                  key: ValueKey('settings-entry-${_entries[index].title}'),
                  entry: _entries[index],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _entries[index].page,
                    ),
                  ),
                ),
                if (index != _entries.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0x44FFE7A3),
                  ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _SettingsEntry {
  const _SettingsEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({super.key, required this.entry, required this.onTap});

  final _SettingsEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(entry.icon, color: const Color(0xFFFFD44D), size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  entry.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFC7D3BA),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFFFE7A3)),
        ],
      ),
    ),
  );
}
