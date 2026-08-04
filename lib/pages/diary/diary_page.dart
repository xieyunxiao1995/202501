import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import 'diary_detail_page.dart';
import 'outfit_stats_page.dart';
import '../inspiration/inspiration_page.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<DiaryEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    LocalStorage.diaryChanged.addListener(_load);
    _load();
  }

  @override
  void dispose() {
    LocalStorage.diaryChanged.removeListener(_load);
    _tabController.dispose();
    super.dispose();
  }

  void _load() {
    LocalStorage().readDiaryEntries().then((v) {
      if (mounted) setState(() => entries = v);
    });
  }

  @override
  Widget build(BuildContext context) => AppBackground(
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '可伴',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '记录每一天的穿搭',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  FadeSlideRoute(builder: (_) => const OutfitStatsPage()),
                ),
                icon: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.deepLavender,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF0E6F6), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.deepLavender,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              indicatorColor: AppColors.deepLavender,
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: '我的记录'),
                Tab(text: '灵感收藏'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRecordsTab(),
                const _FavoritesTab(),
              ],
            ),
          ),
        ],
      ),
    ),
    ),
  );

  Widget _buildRecordsTab() => RefreshIndicator(
    color: AppColors.lavender,
    onRefresh: () async {
      final v = await LocalStorage().readDiaryEntries();
      if (mounted) setState(() => entries = v);
    },
    child: ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const CalendarStrip(),
        const SizedBox(height: 14),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: EmptyState(message: '还没有穿搭记录，去首页记录今天吧'),
          ),
        for (var i = 0; i < entries.length; i++)
          SlideFadeIn(
            index: i,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                final entry = entries[i];
                final deleted = await Navigator.push<Object?>(
                  context,
                  FadeSlideRoute(
                    builder: (_) => DiaryDetailPage(entry: entry),
                  ),
                );
                if (deleted is DiaryEntry && mounted) {
                  final index = entries.indexWhere((item) => item.id == entry.id);
                  if (index >= 0) setState(() => entries[index] = deleted);
                } else if (deleted == true && mounted) {
                  setState(
                    () => entries.removeWhere((item) => item.id == entry.id),
                  );
                }
              },
              child: DiaryRow(
                date: entries[i].date,
                week: _weekdayFrom(entries[i].date),
                asset: entries[i].image,
                weather: entries[i].weather,
                mood: entries[i].mood,
                tags: entries[i].tags,
                isLocal: entries[i].isLocalImage,
              ),
            ),
          ),
      ],
    ),
  );

  String _weekdayFrom(String date) {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final parts = date.split('.');
    if (parts.length != 2) return '';
    final now = DateTime.now();
    try {
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final dt = DateTime(now.year, month, day);
      if (dt.day == now.day && dt.month == now.month) return '今日';
      return '星期${weekdays[dt.weekday - 1]}';
    } catch (_) {
      return '';
    }
  }
}

class _FavoritesTab extends StatefulWidget {
  const _FavoritesTab();
  @override
  State<_FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<_FavoritesTab> {
  final LocalStorage _storage = LocalStorage();
  final Map<String, (String, String, String)> _cards = const {
    'style_card_108': ('assets/cream_wide_leg_pants_product_v1.png', '奶油色通勤灵感', '温柔即气质'),
    'fashion_character_214': (
      'assets/outfit_beige_trench_coat_jeans_bag_sneakers.png',
      '雨天的轻盈',
      '干练舒适，不惧穿衣',
    ),
    'style_card_054': ('assets/female_avatar_bun_hair.png', '周末松弛感穿搭', '懒但有型'),
    'floral_dress_087': ('assets/outfit_set_floral_dress_beige_cardigan_v1.png', '春日温柔穿搭', '轻盈色系，治愈心情'),
  };
  Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _storage.readFavorites().then((v) {
      if (mounted) setState(() => _favorites = v);
    });
  }

  Future<void> _remove(String id) async {
    setState(() => _favorites.remove(id));
    await _storage.saveFavorites(_favorites);
  }

  @override
  Widget build(BuildContext context) {
    final visible =
        _cards.entries.where((e) => _favorites.contains(e.key)).toList();
    if (visible.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyState(message: '还没有收藏灵感'),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const InspirationPage()),
              ),
              icon: const Icon(Icons.explore_outlined, size: 17),
              label: const Text('去发现灵感'),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        for (final card in visible)
          SoftCard(
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  height: 100,
                  child: AssetImageWidget(
                    card.value.$1,
                    boxFit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.value.$2,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        card.value.$3,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _remove(card.key),
                  icon: const Icon(Icons.bookmark, color: Colors.deepPurple),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              FadeSlideRoute(builder: (_) => const InspirationPage()),
            ),
            icon: const Icon(Icons.explore_outlined, size: 17),
            label: const Text('发现更多灵感'),
          ),
        ),
      ],
    );
  }
}
