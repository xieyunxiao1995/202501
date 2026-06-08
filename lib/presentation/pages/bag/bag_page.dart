import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 背包页
///
/// 展示玩家拥有的所有物品，支持筛选和使用。
class BagPage extends ConsumerWidget {
  const BagPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('背包')),
      body: const Center(
        child: Text('背包 - 待实现'),
      ),
    );
  }
}
