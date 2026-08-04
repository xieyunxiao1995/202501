import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../models/outfit_models.dart';
import '../../data/local_storage.dart';
import '../../widgets/app_widgets.dart';
import 'edit_clothing_page.dart';
import 'clothing_history_page.dart';

class ItemDetailPage extends StatelessWidget {
  final ClothingItem item;
  const ItemDetailPage({super.key, required this.item});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: item.name,
    subtitle: '单品详情',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      SoftCard(
        child: SizedBox(
          height: 250,
          child: SmartImageWidget(path: item.image, isLocal: item.isLocalImage),
        ),
      ),
      FutureBuilder<List<DiaryEntry>>(
        future: LocalStorage().readDiaryEntries(),
        builder: (context, snapshot) {
          final entries = (snapshot.data ?? const <DiaryEntry>[])
              .where((entry) => entry.clothingIds.contains(item.id))
              .toList();
          return SoftCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stat('穿搭次数', '${entries.length}', '次'),
                Stat('最近一次', entries.isEmpty ? '暂无' : entries.first.date, ''),
              ],
            ),
          );
        },
      ),
      SoftCard(
        child: Column(
          children: [
            DetailRow(label: '分类', value: item.type),
            DetailRow(label: '颜色', value: item.color),
            DetailRow(label: '适合', value: '${item.occasion} · ${item.season}'),
          ],
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            FadeSlideRoute(builder: (_) => ClothingHistoryPage(item: item)),
          ),
          icon: const Icon(Icons.history),
          label: const Text('查看穿搭记录'),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () async {
            final updated = await Navigator.push<ClothingItem>(
              context,
              FadeSlideRoute(builder: (_) => EditClothingPage(item: item)),
            );
            if (updated != null && context.mounted) {
              Navigator.pop(context, updated);
            }
          },
          icon: const Icon(Icons.edit_outlined),
          label: const Text('编辑单品'),
        ),
      ),
    ],
  );
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const DetailRow({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
