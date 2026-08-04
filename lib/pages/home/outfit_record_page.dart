import 'package:flutter/material.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';
import '../wardrobe/select_items_page.dart';

class OutfitRecordPage extends StatefulWidget {
  const OutfitRecordPage({super.key});
  @override
  State<OutfitRecordPage> createState() => _OutfitRecordPageState();
}

class _OutfitRecordPageState extends State<OutfitRecordPage> {
  final moodOptions = ['😊 开心', '😌 放松', '🙂 平静', '✨ 期待'];
  final tagOptions = ['通勤', '简约', '奶油色', '舒适', '约会'];
  String mood = '😊 开心';
  final tags = <String>{'通勤', '简约'};
  final storage = LocalStorage();
  List<ClothingItem> selectedItems = [];
  bool saving = false;
  @override
  void initState() {
    super.initState();
    LocalStorage().readWardrobe().then((items) {
      if (mounted && items.isNotEmpty) {
        setState(() => selectedItems = items.take(4).toList());
      }
    });
  }

  Future<void> _save() async {
    if (saving) return;
    setState(() => saving = true);
    final now = DateTime.now();
    final entry = DiaryEntry(
      id: now.millisecondsSinceEpoch.toString(),
      date: '${now.month}.${now.day}',
      image: selectedItems.isNotEmpty
          ? selectedItems.first.image
          : AssetPaths.blazer,
      isLocalImage:
          selectedItems.isNotEmpty && selectedItems.first.isLocalImage,
      mood: mood.substring(2),
      weather: '晴 18~26°C',
      tags: tags.toList(),
      clothingIds: selectedItems.map((item) => item.id).toList(),
      source: 'manual',
    );
    await storage.saveDiaryEntry(entry);
    if (!mounted) return;
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '今日穿搭记录',
    subtitle: '记录今天的穿搭与心情',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      SectionTitle(
        title: '今日选择单品',
        action: '从衣橱选择',
        onAction: () async {
          final items = await Navigator.push<List<ClothingItem>>(
            context,
            FadeSlideRoute(
              builder: (_) => SelectItemsPage(
                selectedIds: selectedItems.map((item) => item.id).toList(),
              ),
            ),
          );
          if (items != null && mounted) setState(() => selectedItems = items);
        },
      ),
      SoftCard(
        child: SizedBox(
          height: 130,
          child: selectedItems.isEmpty
              ? const EmptyState(message: '请从衣橱选择今日单品')
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final item in selectedItems)
                      Expanded(
                        child: SmartImageWidget(
                          path: item.image,
                          isLocal: item.isLocalImage,
                        ),
                      ),
                  ],
                ),
        ),
      ),
      const SectionTitle(title: '天气'),
      SoftCard(
        child: Row(
          children: [
            Image.asset(AssetPaths.sunny, width: 34, height: 34),
            const SizedBox(width: 12),
            const Text(
              '晴朗  18~26°C',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      const SectionTitle(title: '心情'),
      Material(
        type: MaterialType.transparency,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in moodOptions)
              ChoiceChip(
                label: Text(option),
                selected: mood == option,
                onSelected: (_) => setState(() => mood = option),
              ),
          ],
        ),
      ),
      const SectionTitle(title: '标签'),
      Material(
        type: MaterialType.transparency,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in tagOptions)
              FilterChip(
                label: Text(tag),
                selected: tags.contains(tag),
                onSelected: (value) =>
                    setState(() => value ? tags.add(tag) : tags.remove(tag)),
              ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: saving ? null : _save,
          icon: saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_rounded),
          label: Text(saving ? '保存中…' : '保存到可伴'),
        ),
      ),
    ],
  );
}
