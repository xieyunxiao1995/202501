import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 国战任务页
///
/// 展示国战相关的日常和阶段任务。
class KingdomTaskPage extends ConsumerWidget {
  const KingdomTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('国战任务')),
      body: const Center(
        child: Text('国战任务 - 待实现'),
      ),
    );
  }
}
