import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../models/clothing_item.dart';
import '../../models/outfit_entry.dart';
import '../../widgets/local_image.dart';
import 'edit_outfit_page.dart';

class OutfitDetailPage extends StatefulWidget {
  const OutfitDetailPage({
    super.key,
    required this.entry,
    required this.clothingItems,
    required this.onSave,
    required this.onDelete,
  });

  final OutfitEntry entry;
  final List<ClothingItem> clothingItems;
  final Future<void> Function(OutfitEntry entry) onSave;
  final Future<void> Function(String id) onDelete;

  @override
  State<OutfitDetailPage> createState() => _OutfitDetailPageState();
}

class _OutfitDetailPageState extends State<OutfitDetailPage> {
  late OutfitEntry _entry = widget.entry;

  Future<void> _edit() async {
    final result = await Navigator.of(context).push<OutfitEntry>(
      MaterialPageRoute(
        builder: (_) => EditOutfitPage(
          initialEntry: _entry,
          clothingItems: widget.clothingItems,
        ),
      ),
    );
    if (result != null) {
      await widget.onSave(result);
      if (mounted) setState(() => _entry = result);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除这条穿搭？'),
        content: const Text('删除后无法恢复，但不会删除衣橱中的单品。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.onDelete(_entry.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final linked = widget.clothingItems
        .where((item) => _entry.clothingItemIds.contains(item.id))
        .toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _edit, icon: const Icon(Icons.edit_outlined)),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _delete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('删除穿搭')),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LocalImage(path: _entry.imagePath, icon: Icons.style_rounded),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Color(0x66000000), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 44),
            sliver: SliverList.list(
              children: [
                Text(
                  _entry.title,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _DetailPill(
                      icon: Icons.calendar_today_rounded,
                      label:
                          '${_entry.date.year}.${_entry.date.month}.${_entry.date.day}',
                    ),
                    _DetailPill(
                      icon: Icons.place_outlined,
                      label: _entry.occasion,
                    ),
                    _DetailPill(
                      icon: Icons.favorite_border_rounded,
                      label: _entry.mood,
                    ),
                  ],
                ),
                if (_entry.notes.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text('这一天', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(
                    _entry.notes,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                if (linked.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  Text('用到的单品', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 94,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: linked.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final item = linked[index];
                        return Container(
                          width: 190,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: SizedBox(
                                  width: 64,
                                  height: 74,
                                  child: LocalImage(path: item.imagePath),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    Text(
                                      item.category,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailPill extends StatelessWidget {
  const _DetailPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryLight),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
