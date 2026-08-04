import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import '../../data/local_storage.dart';

class InspirationDetailPage extends StatefulWidget {
  final String asset, title, caption;
  const InspirationDetailPage({
    super.key,
    required this.asset,
    required this.title,
    required this.caption,
  });
  @override
  State<InspirationDetailPage> createState() => _InspirationDetailPageState();
}

class _InspirationDetailPageState extends State<InspirationDetailPage> {
  bool favorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final favorites = await LocalStorage().readFavorites();
    if (mounted) setState(() => favorited = favorites.isNotEmpty);
  }

  Future<void> _toggleFavorite() async {
    final storage = LocalStorage();
    final favorites = await storage.readFavorites();
    // 使用标题作为收藏标识
    final id = widget.asset.replaceAll('assets/', '').replaceAll('.png', '');
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await storage.saveFavorites(favorites);
    if (mounted) {
      setState(() => favorited = favorites.contains(id));
      showAppSnackBar(
        context,
        favorites.contains(id) ? '已收藏到灵感库' : '已取消收藏',
        icon: favorites.contains(id) ? Icons.bookmark : Icons.bookmark_border,
      );
    }
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.title,
    subtitle: '灵感详情',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      RevealUp(
        child: SoftCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 270,
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
                AssetImageWidget(widget.asset, boxFit: BoxFit.contain),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.caption,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.deepLavender,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
      SlideFadeIn(index: 1, child: const SectionTitle(title: '风格关键词')),
      SlideFadeIn(
        index: 2,
        child: const Wrap(spacing: 8, runSpacing: 8, children: [
          Pill('简约'),
          Pill('低饱和'),
          Pill('通勤'),
          Pill('温柔'),
        ]),
      ),
      SlideFadeIn(index: 3, child: const SectionTitle(title: '推荐单品')),
      SlideFadeIn(
        index: 4,
        child: SoftCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [Pill('米色西装'), Pill('白衬衫'), Pill('百褶裙'), Pill('浅色手提包')],
          ),
        ),
      ),
      SlideFadeIn(index: 5, child: const SectionTitle(title: '搭配建议')),
      SlideFadeIn(
        index: 6,
        child: SoftCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.lavender.withValues(alpha: .10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: AppColors.deepLavender,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '整体色调柔和统一，适合日常通勤和轻社交场合。可以用浅色手提包提升精致感，鞋子选择裸色或米色保持整体协调。',
                style: TextStyle(height: 1.7, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      ),
      const SizedBox(height: 8),
      SlideFadeIn(
        index: 7,
        child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _toggleFavorite,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: favorited ? Colors.deepPurple : AppColors.lavender,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                favorited ? Icons.bookmark : Icons.bookmark_border_rounded,
                color: favorited ? Colors.deepPurple : AppColors.deepLavender,
              ),
              label: Text(
                favorited ? '已收藏' : '收藏灵感',
                style: TextStyle(
                  color: favorited ? Colors.deepPurple : AppColors.deepLavender,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Expanded(child: Text('已加入 AI 搭配参考，去 AI 穿搭页生成方案吧')),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: const Color(0xFF28252D).withValues(alpha: .88),
                      elevation: 0,
                      duration: const Duration(milliseconds: 2200),
                    ),
                  );
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('加入 AI 搭配'),
            ),
          ),
        ],
      ),
      ),
    ],
  );
}
