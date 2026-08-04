import 'package:flutter/material.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';
import 'quick_record_page.dart';
import 'ai_quick_result_page.dart';
import 'diary_preview_page.dart';
import '../wardrobe/wardrobe_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onRecordSaved;
  const HomePage({super.key, this.onRecordSaved});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int recommendationIndex = 0;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: '今日穿搭',
    subtitle: _todayLabel(),
    children: [
      SlideFadeIn(
        index: 0,
        child: const WeatherCard(),
      ),
      SectionTitle(
        title: '今日推荐搭配',
        action: '换一换',
        onAction: () =>
            setState(() => recommendationIndex = (recommendationIndex + 1) % 3),
      ),
      SlideFadeIn(
        index: 1,
        child: OutfitHeroCard(index: recommendationIndex),
      ),
      SlideFadeIn(
        index: 2,
        child: Row(
          children: [
            Expanded(
              child: QuickCard(
                icon: Icons.camera_alt_rounded,
                title: '快速记录',
                caption: '记录今天的好搭',
                color: const Color(0xFFFFE8E5),
                onTap: () async {
                  final result = await Navigator.push<DiaryEntry>(
                    context,
                    FadeSlideRoute(builder: (_) => const QuickRecordPage()),
                  );
                  if (result != null) {
                    widget.onRecordSaved?.call();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickCard(
                icon: Icons.auto_awesome_rounded,
                title: '一键生成搭配',
                caption: 'AI为你生成搭配',
                color: const Color(0xFFEFE6FF),
                onTap: () async {
                  final nav = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final wardrobe = await LocalStorage().readWardrobe();
                  if (!mounted) return;
                  if (wardrobe.isEmpty) {
                    messenger
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: const Text('请先添加衣物，AI 才能为你推荐搭配'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: AppColors.ink.withValues(alpha: .88),
                          elevation: 0,
                          action: SnackBarAction(
                            label: '去添加',
                            textColor: AppColors.lavender,
                            onPressed: () => nav.push(
                              FadeSlideRoute(
                                builder: (_) => const WardrobePage(),
                              ),
                            ),
                          ),
                        ),
                      );
                    return;
                  }
                  final result = await nav.push<DiaryEntry>(
                    FadeSlideRoute(builder: (_) => const AiQuickResultPage()),
                  );
                  if (result != null) {
                    widget.onRecordSaved?.call();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      SlideFadeIn(
        index: 3,
        child: Row(
          children: [
            Expanded(
              child: QuickCard(
                icon: Icons.checkroom_rounded,
                title: '查看衣橱',
                caption: '管理我的衣物',
                color: const Color(0xFFFFF0DD),
                onTap: () => Navigator.push(
                  context,
                  FadeSlideRoute(builder: (_) => const WardrobePage()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickCard(
                icon: Icons.menu_book_rounded,
                title: '最近记录',
                caption: '回顾可伴',
                color: const Color(0xFFFFE7EF),
                onTap: () => Navigator.push(
                  context,
                  FadeSlideRoute(builder: (_) => const DiaryPreviewPage()),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  String _todayLabel() {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final now = DateTime.now();
    return '${now.month}月${now.day}日 · 星期${weekdays[now.weekday - 1]}';
  }
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});
  @override
  Widget build(BuildContext context) => SoftCard(
    padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '今日晴爽',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8EE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '适合出门',
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFF4C9A67),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Image.asset(AssetPaths.sunny, width: 28, height: 28),
                  const SizedBox(width: 7),
                  const Flexible(
                    child: Text(
                      '云少晴朗  ·  18~26°C',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '温柔泡泡色系的一天，简约舒适，元气满满。',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Image.asset(
          AssetPaths.tulips,
          width: 76,
          height: 76,
          fit: BoxFit.contain,
        ),
      ],
    ),
  );
}

class OutfitHeroCard extends StatelessWidget {
  final int index;
  const OutfitHeroCard({super.key, this.index = 0});

  String _getOutfitImage() {
    switch (index) {
      case 1:
        return 'assets/fashion_character_lavender_cardigan_skirt.png'; // 紫色开衫+裙装休闲穿搭
      case 2:
        return 'assets/fashion_character_floral_dress_lavender_cardigan.png'; // 碎花裙温柔穿搭
      default:
        return 'assets/fashion_character_cream_top_blue_jeans.png'; // 奶油色上衣+牛仔裤通勤穿搭
    }
  }

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () => Navigator.push(
      context,
      FadeSlideRoute(builder: (_) => const AiQuickResultPage()),
    ),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.06, 0),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: SoftCard(
        key: ValueKey(index),
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight = (constraints.maxWidth * .78).clamp(190.0, 270.0);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFF8F4), Color(0xFFF8F5FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Image.asset(_getOutfitImage(), fit: BoxFit.contain),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .82),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '今日主推',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.deepLavender,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 14, 6, 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _tags.map((tag) => Pill(tag)).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: AppColors.lavender,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );

  String get _title => index == 1
      ? '轻松自在休闲风'
      : index == 2
      ? '温柔约会风'
      : '奶油色轻盈通勤风';

  List<String> get _tags => index == 1
      ? ['休闲', '舒适', '浅色']
      : index == 2
      ? ['约会', '温柔', '浅色']
      : ['通勤', '简约', '奶油色'];
}
