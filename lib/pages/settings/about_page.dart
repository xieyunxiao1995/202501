import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '关于我们',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      SlideFadeIn(
        index: 0,
        child: SoftCard(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.checkroom_rounded,
                  color: AppColors.deepLavender,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '可伴 AI',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      children: [
                        Pill('v1.0.0'),
                        SizedBox(width: 6),
                        Pill('官方正版'),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      '让每天的穿搭，都成为值得记录的小事',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SlideFadeIn(index: 1, child: const SectionTitle(title: '产品介绍')),
      SlideFadeIn(
        index: 2,
        child: SoftCard(
          padding: const EdgeInsets.all(16),
          child: const Text(
            '可伴 AI 是一款专注于个人穿搭管理的智能应用。我们通过 AI 技术帮助你轻松管理衣橱、生成个性化搭配方案、记录每日穿搭，并提供灵感参考，让每天的穿搭都充满自信。',
            style: TextStyle(fontSize: 14, height: 1.8, color: AppColors.ink),
          ),
        ),
      ),
      SlideFadeIn(index: 3, child: const SectionTitle(title: '核心功能')),
      SlideFadeIn(
        index: 4,
        child: SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: const [
            _FeatureRow(
              icon: Icons.auto_awesome_rounded,
              chipColor: Color(0xFFEFE6FF),
              title: 'AI 智能搭配',
              caption: '根据衣橱、天气和场景，一键生成搭配方案',
            ),
            _FeatureRow(
              icon: Icons.calendar_month_rounded,
              chipColor: Color(0xFFFFE7EF),
              title: '可伴',
              caption: '记录每天的穿搭，形成个人穿搭档案',
            ),
            _FeatureRow(
              icon: Icons.inventory_2_rounded,
              chipColor: Color(0xFFFFF0DD),
              title: '衣橱管理',
              caption: '分类管理所有单品，了解衣橱使用情况',
            ),
            _FeatureRow(
              icon: Icons.lightbulb_rounded,
              chipColor: Color(0xFFEAF8EE),
              title: '灵感建议',
              caption: '基于天气与使用习惯，提供每日穿搭灵感',
            ),
          ],
        ),
      ),
      ),
      SlideFadeIn(index: 5, child: const SectionTitle(title: '联系我们')),
      SlideFadeIn(
        index: 6,
        child: SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: const [
            _InfoRow(icon: Icons.language_rounded, label: '官方网站', value: 'www.kexingapp.com'),
            _InfoRow(icon: Icons.mail_outline_rounded, label: '客服邮箱', value: 'support@kexingapp.com'),
            _InfoRow(icon: Icons.chat_bubble_outline_rounded, label: '微信公众号', value: '可伴AI'),
          ],
        ),
      ),
      ),
      const SizedBox(height: 4),
      SlideFadeIn(
        index: 7,
        child: Center(
          child: Text(
            '© 2024 可星科技 版权所有',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ),
      ),
    ],
  );
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color chipColor;
  final String title, caption;

  const _FeatureRow({
    required this.icon,
    required this.chipColor,
    required this.title,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.deepLavender, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(height: 3),
              Text(
                caption,
                style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Icon(icon, size: 17, color: AppColors.lavender),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    ),
  );
}
