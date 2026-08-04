import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import 'inspiration_detail_page.dart';
import 'favorites_page.dart';

class InspirationPage extends StatefulWidget {
  const InspirationPage({super.key});
  @override
  State<InspirationPage> createState() => _InspirationPageState();
}

class _InspirationPageState extends State<InspirationPage> {
  final cards = const [
    ('style_card_108', 'assets/cream_wide_leg_pants_product_v1.png', '奶油色通勤灵感', '温柔即气质'),
    (
      'fashion_character_214',
      'assets/outfit_beige_trench_coat_jeans_bag_sneakers.png',
      '雨天的轻盈',
      '干练舒适，不惧穿衣',
    ),
    ('style_card_054', 'assets/female_avatar_bun_hair.png', '周末松弛感穿搭', '懒但有型'),
    ('floral_dress_087', 'assets/outfit_set_floral_dress_beige_cardigan_v1.png', '春日温柔穿搭', '轻盈色系，治愈心情'),
  ];
  int selectedCategory = 0;
  final categories = const ['全部', '通勤', '休闲', '约会', '旅行'];
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '灵感首页',
    action: Icons.bookmark_border_rounded,
    onAction: () => Navigator.push(
      context,
      FadeSlideRoute(builder: (_) => const FavoritesPage()),
    ),
    children: [
      TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchQuery = value.trim()),
        decoration: InputDecoration(
          hintText: '搜索穿搭灵感、单品或风格',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isEmpty
              ? IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 36,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '筛选分类',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  for (var i = 0; i < categories.length; i++)
                                    ChoiceChip(
                                      label: Text(categories[i]),
                                      selected: selectedCategory == i,
                                      onSelected: (_) {
                                        setState(() => selectedCategory = i);
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() => searchQuery = '');
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: ChoiceRow(
              items: categories,
              selected: selectedCategory,
              onSelect: (value) => setState(() => selectedCategory = value),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Builder(builder: (context) {
        final filtered = cards
            .where(
              (card) =>
                  (selectedCategory == 0 ||
                      _categoryFor(card.$1) == categories[selectedCategory]) &&
                  (searchQuery.isEmpty ||
                      card.$3.contains(searchQuery) ||
                      card.$4.contains(searchQuery)),
            )
            .toList();
        if (filtered.isEmpty) {
          return const EmptyState(message: '没有找到匹配的灵感');
        }
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          childAspectRatio: .68,
          children: [
            for (final card in filtered)
              InspirationCard(
                asset: card.$2,
                title: card.$3,
                caption: card.$4,
                onTap: () => Navigator.push(
                  context,
                  FadeSlideRoute(
                    builder: (_) => InspirationDetailPage(
                      asset: card.$2,
                      title: card.$3,
                      caption: card.$4,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    ],
  );

  String _categoryFor(String id) => switch (id) {
    'fashion_character_214' => '休闲',
    'style_card_054' => '旅行',
    'floral_dress_087' => '约会',
    _ => '通勤',
  };
}
