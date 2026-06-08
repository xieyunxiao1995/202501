import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 竞技场排行页
///
/// 展示竞技场排名排行榜。
class ArenaRankPage extends ConsumerWidget {
  const ArenaRankPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('竞技场排行')),
      body: const Center(
        child: Text('竞技场排行 - 待实现'),
      ),
    );
  }
}
