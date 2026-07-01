import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../models/clothing_item.dart';
import '../../widgets/ambient_background.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/local_image.dart';
import 'clothing_detail_page.dart';
import 'edit_clothing_page.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({
    super.key,
    required this.items,
    required this.onSave,
    required this.onDelete,
  });

  final List<ClothingItem> items;
  final Future<void> Function(ClothingItem item) onSave;
  final Future<void> Function(String id) onDelete;

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  static const _categories = ['全部', '上衣', '裤装', '裙装', '外套', '鞋履', '包袋', '配饰'];
  String _category = '全部';

  List<ClothingItem> get _visibleItems {
    final sorted = [...widget.items]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (_category == '全部') return sorted;
    return sorted.where((item) => item.category == _category).toList();
  }

  Future<void> _openEditor([ClothingItem? item]) async {
    final result = await Navigator.of(context).push<ClothingItem>(
      MaterialPageRoute(builder: (_) => EditClothingPage(initialItem: item)),
    );
    if (result != null) await widget.onSave(result);
  }

  Future<void> _openDetail(ClothingItem item) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ClothingDetailPage(
          item: item,
          onSave: widget.onSave,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleItems;
    return AmbientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 14, 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURATED BY YOU',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '${widget.items.length} 件单品 · 让每件衣服都被看见',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    tooltip: '添加衣物',
                    onPressed: _openEditor,
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final label = _categories[index];
                  final selected = _category == label;
                  return FilterChip(
                    selected: selected,
                    onSelected: (_) => setState(() => _category = label),
                    label: Text(label),
                    showCheckmark: false,
                    side: BorderSide.none,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surfaceElevated,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: widget.items.isEmpty
                  ? EmptyState(
                      assetPath: 'assets/images/wardrobe_empty.png',
                      title: '衣橱还是空的',
                      message: '从最常穿的一件开始，慢慢整理属于你的风格地图。',
                      actionLabel: '添加第一件衣物',
                      onAction: _openEditor,
                    )
                  : visible.isEmpty
                  ? Center(
                      child: Text(
                        '这个分类还没有单品',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.72,
                          ),
                      itemCount: visible.length,
                      itemBuilder: (_, index) {
                        final item = visible[index];
                        return _ClothingCard(
                          item: item,
                          onTap: () => _openDetail(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClothingCard extends StatelessWidget {
  const _ClothingCard({required this.item, required this.onTap});

  final ClothingItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardIndex = item.name.hashCode;
    final usePurple = cardIndex.abs() % 2 == 0;
    final gradientColors = usePurple
        ? AppColors.cardGradientPurple
        : AppColors.cardGradientTeal;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (usePurple
                        ? const Color(0xFF6D28D9)
                        : const Color(0xFF0891B2))
                    .withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LocalImage(path: item.imagePath),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            color: Color(0xFF1A1230),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 12, 13, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${item.color} · ${item.season}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
