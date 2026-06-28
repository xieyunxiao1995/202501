import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../models/clothing_item.dart';
import '../../models/outfit_entry.dart';
import '../../widgets/ambient_background.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/local_image.dart';
import 'edit_outfit_page.dart';
import 'outfit_detail_page.dart';

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
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 14, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MY STYLE NOTES',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '穿搭日记',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.outfits.length} 次认真穿衣的瞬间',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    tooltip: '添加穿搭',
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
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = _filters[index];
                  final selected = label == _filter;
                  return FilterChip(
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = label),
                    label: Text(label),
                    showCheckmark: false,
                    side: BorderSide.none,
                    backgroundColor: Colors.white.withValues(alpha: 0.78),
                    selectedColor: AppColors.ink,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
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
                            childAspectRatio: 0.68,
                          ),
                      itemCount: visible.length,
                      itemBuilder: (_, index) {
                        final entry = visible[index];
                        return _OutfitCard(
                          entry: entry,
                          onTap: () => _openDetail(entry),
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

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({required this.entry, required this.onTap});

  final OutfitEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LocalImage(path: entry.imagePath, icon: Icons.style_rounded),
                  Positioned(
                    left: 10,
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
                        '${entry.date.month}.${entry.date.day}',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 12,
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
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${entry.occasion} · ${entry.mood}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
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
