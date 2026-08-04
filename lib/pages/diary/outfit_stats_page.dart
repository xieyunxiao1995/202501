import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';

class OutfitStatsPage extends StatelessWidget {
  const OutfitStatsPage({super.key});
  @override
  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(
    future: Future.wait([
      LocalStorage().readDiaryEntries(),
      LocalStorage().readWardrobe(),
    ]),
    builder: (context, snapshot) {
      final entries = snapshot.hasData
          ? snapshot.data![0] as List<DiaryEntry>
          : <DiaryEntry>[];
      final items = snapshot.hasData
          ? snapshot.data![1] as List<ClothingItem>
          : <ClothingItem>[];
      final counts = <String, int>{};
      for (final entry in entries) {
        for (final id in entry.clothingIds) {
          counts[id] = (counts[id] ?? 0) + 1;
        }
      }
      final popular = counts.entries.isEmpty
          ? null
          : counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
      final popularItem = popular == null
          ? null
          : items.where((item) => item.id == popular.key).firstOrNull;
      final styleCounts = <String, int>{};
      for (final entry in entries) {
        for (final tag in entry.tags) {
          styleCounts[tag] = (styleCounts[tag] ?? 0) + 1;
        }
      }
      final popularStyle = styleCounts.entries.isEmpty
          ? '暂无'
          : styleCounts.entries
                .reduce((a, b) => a.value >= b.value ? a : b)
                .key;
      return PageFrame(
        title: '穿搭统计',
        subtitle: '基于本地可伴',
        action: Icons.close_rounded,
        onAction: () => Navigator.pop(context),
        children: [
          SlideFadeIn(
            index: 0,
            child: SoftCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stat('累计记录', '${entries.length}', '天'),
                  Stat('单品数量', '${items.length}', '件'),
                  Stat('常用风格', popularStyle, ''),
                ],
              ),
            ),
          ),
          SlideFadeIn(index: 1, child: const SectionTitle(title: '最高频单品')),
          SlideFadeIn(
            index: 2,
            child: SoftCard(
            child: popularItem == null
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        '记录几次穿搭后，这里会显示统计',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: SmartImageWidget(
                          path: popularItem.image,
                          isLocal: popularItem.isLocalImage,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${popularItem.name}\n已穿 ${popular!.value} 次',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
          ),
          ),
          SlideFadeIn(index: 3, child: const SectionTitle(title: '常用标签')),
          SlideFadeIn(
            index: 4,
            child: SoftCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag
                    in styleCounts.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value)))
                  Pill('${tag.key} ${tag.value}次'),
              ],
            ),
          ),
          ),
        ],
      );
    },
  );
}
