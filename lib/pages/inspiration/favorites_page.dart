import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../widgets/app_widgets.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final storage = LocalStorage();
  final cards = const {
    'style_card_108': ('assets/cream_wide_leg_pants_product_v1.png', '奶油色通勤灵感', '温柔即气质'),
    'fashion_character_214': (
      'assets/outfit_beige_trench_coat_jeans_bag_sneakers.png',
      '雨天的轻盈',
      '干练舒适，不惧穿衣',
    ),
    'style_card_054': ('assets/female_avatar_bun_hair.png', '周末松弛感穿搭', '懒但有型'),
    'floral_dress_087': ('assets/outfit_set_floral_dress_beige_cardigan_v1.png', '春日温柔穿搭', '轻盈色系，治愈心情'),
  };
  Set<String> favorites = {};
  @override
  void initState() {
    super.initState();
    storage.readFavorites().then((v) {
      if (mounted) setState(() => favorites = v);
    });
  }

  Future<void> _remove(String id) async {
    setState(() => favorites.remove(id));
    await storage.saveFavorites(favorites);
  }

  @override
  Widget build(BuildContext context) {
    final visible = cards.entries
        .where((e) => favorites.contains(e.key))
        .toList();
    return PageFrame(
      title: '我的收藏',
      subtitle: '${visible.length} 条灵感',
      action: Icons.close_rounded,
      onAction: () => Navigator.pop(context),
      children: [
        if (visible.isEmpty) const EmptyState(message: '还没有收藏灵感'),
        for (int i = 0; i < visible.length; i++)
          SlideFadeIn(
            index: i,
            child: SoftCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    height: 100,
                    child: AssetImageWidget(visible[i].value.$1, boxFit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visible[i].value.$2,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          visible[i].value.$3,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _remove(visible[i].key),
                    icon: const Icon(Icons.bookmark, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
