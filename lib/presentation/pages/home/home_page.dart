import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// 主城页面
///
/// 游戏主界面，包含主城视图、玩家信息栏、货币栏和主菜单入口。
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部信息栏
            _buildTopBar(context),
            // 主城内容区
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '主城',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '天下大势，合久必分，分久必合',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x80000000), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // 玩家头像和等级
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '主公',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                'Lv.1',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.accent,
                    ),
              ),
            ],
          ),
          const Spacer(),
          // 货币显示
          _CurrencyChip(icon: Icons.monetization_on, label: '1000', color: AppColors.accent),
          const SizedBox(width: 8),
          _CurrencyChip(icon: Icons.diamond, label: '100', color: Colors.purpleAccent),
          const SizedBox(width: 8),
          _CurrencyChip(icon: Icons.bolt, label: '120/120', color: Colors.greenAccent),
        ],
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CurrencyChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
