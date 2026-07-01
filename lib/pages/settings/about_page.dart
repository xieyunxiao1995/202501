import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于我们')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 44),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: AspectRatio(
              aspectRatio: 1.15,
              child: Image.asset(
                'assets/images/app_about.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('认真穿衣，也认真生活。', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          Text(
            'CPDD小屋 是一本属于你的数字穿搭手账。我们希望记录衣服不只是整理物品，而是看见自己的审美、生活节奏，以及每一次更了解自己的选择。',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(Icons.favorite_rounded, color: AppColors.accent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '少一点冲动购买，多一点真正喜欢。',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'CPDD小屋  ·  Version 1.0.0',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
