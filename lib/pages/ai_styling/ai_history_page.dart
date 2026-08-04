import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';
import 'ai_history_detail_page.dart';

class AiHistoryPage extends StatefulWidget {
  const AiHistoryPage({super.key});
  @override
  State<AiHistoryPage> createState() => _AiHistoryPageState();
}

class _AiHistoryPageState extends State<AiHistoryPage> {
  List<AiHistoryEntry> entries = [];
  @override
  void initState() {
    super.initState();
    LocalStorage().readAiHistory().then((v) {
      if (mounted) setState(() => entries = v);
    });
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'AI搭配历史',
    subtitle: '最近生成的搭配方案',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      if (entries.isEmpty) const EmptyState(message: '还没有生成记录，去试试 AI 搭配吧'),
      for (final entry in entries)
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.push(
            context,
            FadeSlideRoute(
              builder: (_) => AiHistoryDetailPage(entry: entry),
            ),
          ),
          child: SoftCard(
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [AppColors.lavender, AppColors.deepLavender],
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${entry.date} · ${entry.scene} · ${entry.style}',
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
}
