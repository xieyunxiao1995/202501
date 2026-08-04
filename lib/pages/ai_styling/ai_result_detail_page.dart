import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';

class AiResultDetailPage extends StatefulWidget {
  const AiResultDetailPage({super.key});
  @override
  State<AiResultDetailPage> createState() => _AiResultDetailPageState();
}

class _AiResultDetailPageState extends State<AiResultDetailPage> {
  bool saved = false;

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'AI搭配详情',
    subtitle: '简约通勤风 · 92%匹配',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      SlideFadeIn(
        index: 0,
        child: SoftCard(
          child: SizedBox(
            height: 210,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                AssetImageWidget('assets/cream_tweed_jacket_product.png'),
                AssetImageWidget('assets/cream_button_down_shirt_product.png'),
                AssetImageWidget('assets/black_wide_leg_trousers_v1.png'),
                AssetImageWidget('assets/lavender_purple_shoulder_bag_v1.png'),
              ],
            ),
          ),
        ),
      ),
      SlideFadeIn(index: 1, child: const SectionTitle(title: '为什么推荐')),
      SlideFadeIn(
        index: 2,
        child: const SoftCard(
          child: Column(
            children: [
              ReasonRow(text: '色彩协调，符合你的柔和色偏好'),
              ReasonRow(text: '适合 18~26°C 的通勤天气'),
              ReasonRow(text: '整体简约利落，方便日常复用'),
            ],
          ),
        ),
      ),
      SlideFadeIn(index: 3, child: const SectionTitle(title: '包含单品')),
      SlideFadeIn(
        index: 4,
        child: const Wrap(
          spacing: 8,
          children: [Pill('米色西装'), Pill('白衬衫'), Pill('阔腿裤'), Pill('浅色手提包')],
        ),
      ),
      const SizedBox(height: 8),
      SlideFadeIn(
        index: 5,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _wearToday(context),
                icon: const Icon(Icons.checkroom),
                label: const Text('今天就穿'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => setState(() => saved = !saved),
                icon: Icon(saved ? Icons.bookmark : Icons.bookmark_add_outlined),
                label: Text(saved ? '已保存' : '保存方案'),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Future<void> _wearToday(BuildContext context) async {
    final items = await LocalStorage().readWardrobe();
    final now = DateTime.now();
    await LocalStorage().saveDiaryEntry(
      DiaryEntry(
        id: '${now.year}-${now.month}-${now.day}',
        date: '${now.month}.${now.day}',
        image: 'assets/outfit_beige_trench_coat_jeans_bag_sneakers.png',
        mood: '期待',
        weather: '晴 18~26°C',
        tags: const ['通勤', '简约'],
        clothingIds: items.take(4).map((item) => item.id).toList(),
        note: '来自 AI 搭配方案',
        source: 'ai',
      ),
    );
    if (context.mounted) Navigator.pop(context, true);
  }
}

class ReasonRow extends StatelessWidget {
  final String text;
  const ReasonRow({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        const Icon(Icons.check_circle, size: 18, color: AppColors.lavender),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}
