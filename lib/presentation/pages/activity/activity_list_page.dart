import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 活动列表页
///
/// 展示当前进行中的所有活动入口。
class ActivityListPage extends ConsumerWidget {
  const ActivityListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('活动')),
      body: const Center(
        child: Text('活动列表 - 待实现'),
      ),
    );
  }
}
