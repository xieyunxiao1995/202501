import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AppPage { home, companion, square, settings }

class BottomNav extends StatelessWidget {
  final AppPage activePage;
  final Function(AppPage) onNavigate;
  final VoidCallback onOpenEditor;

  const BottomNav({
    super.key,
    required this.activePage,
    required this.onNavigate,
    required this.onOpenEditor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavButton(
                icon: Icons.layers,
                label: '记忆',
                isActive: activePage == AppPage.home,
                onTap: () => onNavigate(AppPage.home),
              ),
              const SizedBox(width: 8),
              _NavButton(
                icon: Icons.auto_awesome,
                label: '伴侣',
                isActive: activePage == AppPage.companion,
                onTap: () => onNavigate(AppPage.companion),
              ),
              const SizedBox(width: 16),
              
              // 中央添加按钮
              GestureDetector(
                onTap: onOpenEditor,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.cardFace,
                    size: 32,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              _NavButton(
                icon: Icons.public,
                label: '广场',
                isActive: activePage == AppPage.square,
                onTap: () => onNavigate(AppPage.square),
              ),
              const SizedBox(width: 8),
              _NavButton(
                icon: Icons.settings,
                label: '设置',
                isActive: activePage == AppPage.settings,
                onTap: () => onNavigate(AppPage.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? AppColors.ink
                  : AppColors.ink.withValues(alpha: 0.4),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
