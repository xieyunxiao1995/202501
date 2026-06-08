import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 每周任务页
///
/// 展示每周任务列表和完成进度。
class WeeklyQuestPage extends ConsumerWidget {
  const WeeklyQuestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('每周任务')),
      body: const Center(
        child: Text('每周任务 - 待实现'),
      ),
    );
  }
}
