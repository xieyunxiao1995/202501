import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';
import 'item_detail_page.dart';
import 'add_clothing_page.dart';

class WardrobeItemsPage extends StatefulWidget {
  const WardrobeItemsPage({super.key});
  @override
  State<WardrobeItemsPage> createState() => _WardrobeItemsPageState();
}

class _WardrobeItemsPageState extends State<WardrobeItemsPage> {
  final storage = LocalStorage();
  List<ClothingItem> items = [];
  String filter = '全部';
  final types = ['全部', '上衣', '裙装', '裤装', '外套', '鞋包', '配饰'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await storage.readWardrobe();
    if (mounted) setState(() => items = value);
  }

  Future<void> _add() async {
    final result = await Navigator.push<ClothingItem>(
      context,
      FadeSlideRoute(builder: (_) => const AddClothingPage()),
    );
    if (result == null) return;
    items = [result, ...items];
    await storage.saveWardrobe(items);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final visible = filter == '全部'
        ? items
        : items.where((e) => e.type == filter).toList();
    return PageFrame(
      title: '我的衣物',
      subtitle: '${items.length} 件单品',
      action: Icons.add_rounded,
      onAction: () async {
        await Navigator.push(
          context,
          FadeSlideRoute(builder: (_) => const AddClothingPage()),
        );
        _load();
      },
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final type in types)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: filter == type,
                    onSelected: (_) => setState(() => filter = type),
                  ),
                ),
            ],
          ),
        ),
        if (visible.isEmpty) const EmptyState(message: '这个分类还没有衣物'),
        for (final item in visible)
          Dismissible(
            key: ValueKey(item.id),
            background: Container(
              color: Colors.red.shade50,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            onDismissed: (_) async {
              await storage.deleteClothingItem(item.id);
              items.removeWhere((e) => e.id == item.id);
              if (mounted) setState(() {});
            },
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                final updated = await Navigator.push<ClothingItem>(
                  context,
                  FadeSlideRoute(builder: (_) => ItemDetailPage(item: item)),
                );
                if (updated != null && mounted) {
                  setState(() {
                    final index = items.indexWhere(
                      (value) => value.id == updated.id,
                    );
                    if (index >= 0) items[index] = updated;
                  });
                }
              },
              child: SoftCard(
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: SmartImageWidget(
                        path: item.image,
                        isLocal: item.isLocalImage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Pill(item.type),
                        ],
                      ),
                    ),
                    const Icon(Icons.drag_handle_rounded, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add),
            label: const Text('添加衣物'),
          ),
        ),
      ],
    );
  }
}
