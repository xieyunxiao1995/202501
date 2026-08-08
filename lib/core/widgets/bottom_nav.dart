import 'package:flutter/material.dart';

class JourneyBottomNav extends StatelessWidget {
  const JourneyBottomNav({
    super.key,
    required this.onSettings,
    required this.onLevels,
    required this.onTheme,
  });

  final VoidCallback onSettings;
  final VoidCallback onLevels;
  final VoidCallback onTheme;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF092316).withValues(alpha: .75),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: .08)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _NavItem(
          icon: Icons.settings_rounded,
          label: 'Settings',
          onTap: onSettings,
        ),
        _NavItem(icon: Icons.map_rounded, label: 'Levels', onTap: onLevels),
        _NavItem(icon: Icons.palette_rounded, label: 'Themes', onTap: onTheme),
      ],
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFF1CA4F), size: 25),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFECE6C8), fontSize: 10),
          ),
        ],
      ),
    ),
  );
}
