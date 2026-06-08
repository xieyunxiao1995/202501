import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 成就页
///
/// 展示成就系统，包括已达成和未达成成就及奖励。
class AchievementPage extends ConsumerWidget {
  const AchievementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('成就')),
      body: const Center(
        child: Text('成就系统 - 待实现'),
      ),
    );
  }
}
