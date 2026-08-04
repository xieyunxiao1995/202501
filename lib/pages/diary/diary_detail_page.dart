import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../models/outfit_models.dart';
import '../../data/local_storage.dart';
import '../../widgets/app_widgets.dart';
import 'diary_edit_page.dart';

class DiaryDetailPage extends StatelessWidget {
  final DiaryEntry entry;
  const DiaryDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppBackground.base,
    body: AppBackground(
    child: SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部标题栏
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.date} 穿搭',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '今日穿搭记录',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.ink),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 穿搭图片卡片
            RevealUp(
              child: SoftCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFF8F4), Color(0xFFF8F5FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          SmartImageWidget(
                            path: entry.image,
                            isLocal: entry.isLocalImage,
                            boxFit: entry.isLocalImage
                                ? BoxFit.cover
                                : BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _InfoChip(icon: Icons.wb_sunny_outlined, label: entry.weather),
                        const SizedBox(width: 8),
                        _InfoChip(icon: Icons.emoji_emotions_outlined, label: entry.mood),
                        if (entry.source == 'ai') ...[
                          const SizedBox(width: 8),
                          _InfoChip(icon: Icons.auto_awesome_outlined, label: 'AI生成'),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
            const SizedBox(height: 12),

            // 今日标签
            _sectionHeader('今日标签'),
            const SizedBox(height: 6),
            Wrap(spacing: 8, runSpacing: 6, children: [
              for (final tag in entry.tags) Pill(tag),
            ]),
            const SizedBox(height: 12),

            // 搭配说明
            _sectionHeader('搭配说明'),
            const SizedBox(height: 6),
            SoftCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.lavender.withValues(alpha: .10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.format_quote_rounded,
                      size: 14,
                      color: AppColors.deepLavender,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.note.isEmpty
                          ? '今天用柔和的奶油色搭配利落剪裁，适合通勤，也保留了轻松自在的感觉。'
                          : entry.note,
                      style: const TextStyle(
                        height: 1.6,
                        fontSize: 13,
                        color: AppColors.ink,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 操作按钮
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final updated = await Navigator.push<DiaryEntry>(
                    context,
                    FadeSlideRoute(builder: (_) => DiaryEditPage(entry: entry)),
                  );
                  if (updated != null && context.mounted) {
                    Navigator.pop(context, updated);
                  }
                },
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: const Text(
                  '编辑记录',
                  style: TextStyle(decoration: TextDecoration.none),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text('删除记录', style: TextStyle(decoration: TextDecoration.none)),
                      content: const Text(
                        '确定要删除这条穿搭记录吗？删除后无法恢复。',
                        style: TextStyle(decoration: TextDecoration.none),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('取消', style: TextStyle(decoration: TextDecoration.none)),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('删除', style: TextStyle(decoration: TextDecoration.none)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true) return;
                  await LocalStorage().deleteDiaryEntry(entry.id);
                  if (context.mounted) Navigator.pop(context, true);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 16),
                label: const Text(
                  '删除记录',
                  style: TextStyle(color: Colors.red, fontSize: 13, decoration: TextDecoration.none),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    ),
  );
}

Widget _sectionHeader(String title) => Text(
  title,
  style: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    decoration: TextDecoration.none,
  ),
);

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F3FA),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.lavender),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    ),
  );
}
