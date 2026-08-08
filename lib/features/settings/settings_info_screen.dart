import 'package:flutter/material.dart';

import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';

class InfoSection {
  const InfoSection({required this.title, required this.body});

  final String title;
  final String body;
}

class SettingsInfoScreen extends StatelessWidget {
  const SettingsInfoScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.sections,
  });

  final String title;
  final IconData icon;
  final List<InfoSection> sections;

  @override
  Widget build(BuildContext context) => FeltScaffold(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        SettingsPageHeader(title: title, icon: icon),
        const SizedBox(height: 16),
        GoldPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < sections.length; index++) ...[
                if (index > 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Color(0x44FFE7A3)),
                  ),
                Text(
                  sections[index].title,
                  style: const TextStyle(
                    color: Color(0xFFFFE7A3),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  sections[index].body,
                  style: const TextStyle(
                    color: Color(0xFFD8E3CC),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      Expanded(
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Icon(icon, color: const Color(0xFFFFD44D)),
      ),
    ],
  );
}
