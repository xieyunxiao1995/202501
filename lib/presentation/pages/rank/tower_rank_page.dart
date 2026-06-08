import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 爬塔排行页
///
/// 展示无尽之塔最高层数排行榜。
class TowerRankPage extends ConsumerWidget {
  const TowerRankPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('爬塔排行')),
      body: const Center(
        child: Text('爬塔排行 - 待实现'),
      ),
    );
  }
}
