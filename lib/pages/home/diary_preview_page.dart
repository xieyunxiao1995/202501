import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';
import '../diary/diary_detail_page.dart';

class DiaryPreviewPage extends StatefulWidget {
  const DiaryPreviewPage({super.key});
  @override
  State<DiaryPreviewPage> createState() => _DiaryPreviewPageState();
}

class _DiaryPreviewPageState extends State<DiaryPreviewPage> {
  List<DiaryEntry> entries = [];

  @override
  void initState() {
    super.initState();
    LocalStorage.diaryChanged.addListener(_load);
    _load();
  }

  @override
  void dispose() {
    LocalStorage.diaryChanged.removeListener(_load);
    super.dispose();
  }

  void _load() {
    LocalStorage().readDiaryEntries().then((v) {
      if (mounted) setState(() => entries = v.take(7).toList());
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppBackground.base,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: AppColors.ink),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        '最近穿搭',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            '关闭',
            style: TextStyle(
              color: AppColors.deepLavender,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
    body: AppBackground(
      child: entries.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  '还没有穿搭记录',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '去首页点击「快速记录」开始吧',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 统计概览
                SoftCard(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    children: [
                      _MiniStat(
                        icon: Icons.calendar_today,
                        label: '最近记录',
                        value: '${entries.length}天',
                      ),
                      const SizedBox(width: 16),
                      _MiniStat(
                        icon: Icons.favorite_outline,
                        label: '常用标签',
                        value: _topTag,
                      ),
                      const SizedBox(width: 16),
                      _MiniStat(
                        icon: Icons.wb_sunny_outlined,
                        label: '本周天气',
                        value: '晴为主',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 记录列表
                for (final entry in entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        final deleted = await Navigator.push<Object?>(
                          context,
                          FadeSlideRoute(
                            builder: (_) => DiaryDetailPage(entry: entry),
                          ),
                        );
                        if (deleted == true && mounted) {
                          setState(
                            () => entries.removeWhere(
                              (item) => item.id == entry.id,
                            ),
                          );
                        }
                      },
                      child: SoftCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // 日期
                            SizedBox(
                              width: 50,
                              child: Column(
                                children: [
                                  Text(
                                    entry.date,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _weekdayFrom(entry.date),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 图片
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: SmartImageWidget(
                                  path: entry.image,
                                  isLocal: entry.isLocalImage,
                                  boxFit: entry.isLocalImage
                                      ? BoxFit.cover
                                      : BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 信息
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '穿搭 · ${entry.mood}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.weather,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 4,
                                    children: [
                                      for (final tag in entry.tags.take(3))
                                        Pill(tag),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                // 查看全部按钮
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.lavender),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: AppColors.deepLavender,
                    ),
                    label: const Text(
                      '返回查看可伴 Tab',
                      style: TextStyle(
                        color: AppColors.deepLavender,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
  );

  String get _topTag {
    final tagCount = <String, int>{};
    for (final entry in entries) {
      for (final tag in entry.tags) {
        tagCount[tag] = (tagCount[tag] ?? 0) + 1;
      }
    }
    if (tagCount.isEmpty) return '暂无';
    final top = tagCount.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    return top.key;
  }

  String _weekdayFrom(String date) {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final parts = date.split('.');
    if (parts.length != 2) return '';
    final now = DateTime.now();
    try {
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final dt = DateTime(now.year, month, day);
      if (dt.day == now.day && dt.month == now.month) return '今日';
      return '星期${weekdays[dt.weekday - 1]}';
    } catch (_) {
      return '';
    }
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Icon(icon, size: 18, color: AppColors.lavender),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    ),
  );
}
