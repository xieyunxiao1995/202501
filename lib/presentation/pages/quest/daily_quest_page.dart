import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 每日任务页
///
/// 展示每日任务列表和完成进度。
class DailyQuestPage extends ConsumerWidget {
  const DailyQuestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('每日任务')),
      body: const Center(
        child: Text('每日任务 - 待实现'),
      ),
    );
  }
}
