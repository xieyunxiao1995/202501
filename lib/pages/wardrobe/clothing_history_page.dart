import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';

class ClothingHistoryPage extends StatelessWidget {
  final ClothingItem item;
  const ClothingHistoryPage({super.key, required this.item});
  @override
  Widget build(BuildContext context) => FutureBuilder<List<DiaryEntry>>(
    future: LocalStorage().readDiaryEntries(),
    builder: (context, snapshot) {
      final entries = (snapshot.data ?? const <DiaryEntry>[])
          .where((entry) => entry.clothingIds.contains(item.id))
          .toList();
      return PageFrame(
        title: '${item.name} 的搭配记录',
        subtitle: '共 ${entries.length} 次',
        action: Icons.close_rounded,
        onAction: () => Navigator.pop(context),
        children: [
          if (entries.isEmpty) const EmptyState(message: '还没有使用这件单品的记录'),
          for (int i = 0; i < entries.length; i++)
            SlideFadeIn(
              index: i,
              child: SoftCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: SmartImageWidget(
                          path: entries[i].image,
                          isLocal: entries[i].isLocalImage,
                          boxFit:
                              entries[i].isLocalImage ? BoxFit.cover : BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entries[i].date} · ${entries[i].occasion}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${entries[i].mood} · ${entries[i].tags.join(' / ')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}
