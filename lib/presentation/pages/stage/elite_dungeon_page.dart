import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 精英副本页
///
/// 高难度精英副本，需要特定阵容和策略才能通关。
class EliteDungeonPage extends ConsumerWidget {
  const EliteDungeonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('精英副本')),
      body: const Center(
        child: Text('精英副本 - 待实现'),
      ),
    );
  }
}
