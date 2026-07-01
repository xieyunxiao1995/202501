import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../models/clothing_item.dart';
import '../../models/outfit_entry.dart';
import '../../widgets/ambient_background.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/local_image.dart';
import 'edit_outfit_page.dart';
import 'outfit_detail_page.dart';

enum _ViewMode { grid, timeline }

class OutfitsPage extends StatefulWidget {
  const OutfitsPage({
    super.key,
    required this.outfits,
    required this.clothingItems,
    required this.onSave,
    required this.onDelete,
  });

  final List<OutfitEntry> outfits;
  final List<ClothingItem> clothingItems;
  final Future<void> Function(OutfitEntry entry) onSave;
  final Future<void> Function(String id) onDelete;

  @override
  State<OutfitsPage> createState() => _OutfitsPageState();
}

class _OutfitsPageState extends State<OutfitsPage> {
  static const _filters = ['全部', '通勤', '休闲', '约会', '运动', '旅行'];
  String _filter = '全部';
  _ViewMode _viewMode = _ViewMode.timeline;

  List<OutfitEntry> get _visibleOutfits {
    final sorted = [...widget.outfits]
      ..sort((a, b) => b.date.compareTo(a.date));
    if (_filter == '全部') return sorted;
    return sorted.where((entry) => entry.occasion == _filter).toList();
  }

  Future<void> _openEditor([OutfitEntry? entry]) async {
    final result = await Navigator.of(context).push<OutfitEntry>(
      MaterialPageRoute(
        builder: (_) => EditOutfitPage(
          initialEntry: entry,
          clothingItems: widget.clothingItems,
        ),
      ),
    );
    if (result != null) await widget.onSave(result);
  }

  Future<void> _openDetail(OutfitEntry entry) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => OutfitDetailPage(
          entry: entry,
          clothingItems: widget.clothingItems,
          onSave: widget.onSave,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleOutfits;
    return AmbientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 顶部栏：动态 / 最新 + 发布
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 14, 4),
              child: Row(
                children: [
                  const Text(
                    '动态',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    '最新',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  // 视图切换
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _ViewToggle(
                          icon: Icons.view_stream_rounded,
                          selected: _viewMode == _ViewMode.timeline,
                          onTap: () =>
                              setState(() => _viewMode = _ViewMode.timeline),
                        ),
                        _ViewToggle(
                          icon: Icons.grid_view_rounded,
                          selected: _viewMode == _ViewMode.grid,
                          onTap: () =>
                              setState(() => _viewMode = _ViewMode.grid),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _openEditor,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '发布',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 筛选栏
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final label = _filters[index];
                  final selected = label == _filter;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color:
                              selected ? AppColors.primaryLight : AppColors.muted,
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // 内容区域
            Expanded(
              child: widget.outfits.isEmpty
                  ? EmptyState(
                      assetPath: 'assets/images/outfit_empty.png',
                      title: '还没有穿搭记录',
                      message: '把喜欢的搭配、当时的心情和生活片段一起留下。',
                      actionLabel: '记录第一套穿搭',
                      onAction: _openEditor,
                    )
                  : visible.isEmpty
                  ? Center(
                      child: Text(
                        '这个场合还没有记录',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                        ),
                      ),
                    )
                  : _viewMode == _ViewMode.grid
                      ? _buildGridView(visible)
                      : _buildTimelineView(visible),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<OutfitEntry> visible) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 28),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: visible.length,
      itemBuilder: (_, index) {
        final entry = visible[index];
        return _GridCard(
          entry: entry,
          onTap: () => _openDetail(entry),
        );
      },
    );
  }

  Widget _buildTimelineView(List<OutfitEntry> visible) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 28),
      itemCount: visible.length,
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (_, index) {
        final entry = visible[index];
        return _FeedCard(
          entry: entry,
          clothingItems: widget.clothingItems,
          onTap: () => _openDetail(entry),
        );
      },
    );
  }
}

// ─── 视图切换按钮
class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 16,
          color: selected ? Colors.white : AppColors.muted,
        ),
      ),
    );
  }
}

// ─── 网格卡片：图片为主，文字小而低调 ─────────────────────────────
class _GridCard extends StatelessWidget {
  const _GridCard({required this.entry, required this.onTap});

  final OutfitEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LocalImage(
                    path: entry.imagePath,
                    icon: Icons.style_rounded,
                  ),
                  // 底部微渐变
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.55, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 日期标签（右上角，小而淡）
                  Positioned(
                    right: 7,
                    top: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${entry.date.month}.${entry.date.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 下方文字
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${entry.occasion} · ${entry.mood}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 动态流卡片：社交动态风格 ───────────────────────────────────
class _FeedCard extends StatelessWidget {
  const _FeedCard({
    required this.entry,
    required this.clothingItems,
    required this.onTap,
  });

  final OutfitEntry entry;
  final List<ClothingItem> clothingItems;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final linked = clothingItems
        .where((item) => entry.clothingItemIds.contains(item.id))
        .toList();

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 大图
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.82,
                    child: LocalImage(
                      path: entry.imagePath,
                      icon: Icons.style_rounded,
                    ),
                  ),
                  // 日期标签（右上角）
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '${entry.date.month}.${entry.date.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 用户信息行
            Row(
              children: [
                // 头像占位（用穿搭图片做头像）
                ClipOval(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: LocalImage(
                      path: entry.imagePath,
                      fit: BoxFit.cover,
                      icon: Icons.person_rounded,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC4899).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${entry.occasion} · ${entry.mood}',
                          style: const TextStyle(
                            color: Color(0xFFF472B6),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Hi 按钮
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Hi',
                    style: TextStyle(
                      color: Color(0xFF1A1230),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            // 笔记文字
            if (entry.notes.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                entry.notes,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
            // 关联单品（小图）
            if (linked.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: linked.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 6),
                    itemBuilder: (_, index) {
                      final item = linked[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 140,
                          child: LocalImage(path: item.imagePath),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


