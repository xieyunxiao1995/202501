import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import 'items_page.dart';
import 'style_preferences_page.dart';
import '../ai_styling/ai_history_page.dart';
import '../settings/settings_page.dart';
import '../settings/size_profile_page.dart';
import '../diary/outfit_stats_page.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});
  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  int wardrobeCount = 0;
  int diaryCount = 0;
  List<ClothingItem> items = [];
  @override
  void initState() {
    super.initState();
    LocalStorage.wardrobeChanged.addListener(_load);
    LocalStorage.diaryChanged.addListener(_load);
    _load();
  }

  @override
  void dispose() {
    LocalStorage.wardrobeChanged.removeListener(_load);
    LocalStorage.diaryChanged.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final values = await Future.wait([
      LocalStorage().readWardrobe(),
      LocalStorage().readDiaryEntries(),
    ]);
    if (mounted) {
      setState(() {
        items = values[0] as List<ClothingItem>;
        wardrobeCount = items.length;
        diaryCount = (values[1] as List<DiaryEntry>).length;
      });
    }
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '我的衣橱',
    action: Navigator.canPop(context) ? Icons.arrow_back_ios_new_rounded : null,
    onAction: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: () => Navigator.push(
            context,
            FadeSlideRoute(builder: (_) => const SettingsPage()),
          ),
          icon: const Icon(Icons.settings_outlined, color: Color(0xFF28252D)),
        ),
      ),
      SoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '衣橱概览',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stat('单品总数', '$wardrobeCount', '件'),
                Stat('本周记录', '$diaryCount', '天'),
                Stat('常用风格', '随心', ''),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      SectionTitle(
        title: '衣物分类',
        action: '查看全部',
        onAction: () => Navigator.push(
          context,
          FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
        ),
      ),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: .9,
        children: [
          _CategoryTile(
            asset: 'assets/cream_bow_blouse_product.png',
            title: '上衣',
            count: '${_count('上衣')}',
            onTap: () => Navigator.push(
              context,
              FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
            ),
          ),
          _CategoryTile(
            asset: 'assets/black_wide_leg_trousers_v1.png',
            title: '裤装',
            count: '${_count('裤装')}',
            onTap: () => Navigator.push(
              context,
              FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
            ),
          ),
          _CategoryTile(
            asset: 'assets/cream_pleated_midi_skirt_v1.png',
            title: '裙装',
            count: '${_count('裙装')}',
            onTap: () => Navigator.push(
              context,
              FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
            ),
          ),
          _CategoryTile(
            asset: 'assets/beige_cropped_trench_jacket_product.png',
            title: '外套',
            count: '${_count('外套')}',
            onTap: () => Navigator.push(
              context,
              FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
            ),
          ),
          _CategoryTile(
            asset: 'assets/beige_tote_bag_product.png',
            title: '鞋包',
            count: '${_count('鞋包')}',
            onTap: () => Navigator.push(
              context,
              FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
            ),
          ),
          _CategoryTile(
            asset: 'assets/gold_necklace_with_pink_pendant.png',
            title: '配饰',
            count: '${_count('配饰')}',
            onTap: () => Navigator.push(
              context,
              FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      SoftCard(
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const StylePreferencesPage()),
              ),
              child: const SettingRow(
                icon: Icons.auto_awesome,
                title: '我的偏好',
                caption: '管理我的风格与颜色偏好',
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const SizeProfilePage()),
              ),
              child: const SettingRow(
                icon: Icons.straighten,
                title: '尺码管理',
                caption: '记录我的尺码信息',
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const AiHistoryPage()),
              ),
              child: const SettingRow(
                icon: Icons.history,
                title: '搭配历史',
                caption: '查看最近生成的搭配方案',
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.push(
                context,
                FadeSlideRoute(builder: (_) => const OutfitStatsPage()),
              ),
              child: const SettingRow(
                icon: Icons.bar_chart_outlined,
                title: '穿搭统计',
                caption: '查看穿搭数据与趋势',
              ),
            ),
          ],
        ),
      ),
    ],
  );

  int _count(String type) => items.where((item) => item.type == type).length;
}

class _CategoryTile extends StatelessWidget {
  final String asset, title, count;
  final VoidCallback? onTap;
  const _CategoryTile({
    required this.asset,
    required this.title,
    required this.count,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8E68D9).withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Flexible(child: AssetImageWidget(asset, boxFit: BoxFit.contain)),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          Text(count, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    ),
  );
}
