import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 排行榜主页
///
/// 展示各类排行榜入口，包括战力、竞技场、爬塔等。
class RankMainPage extends ConsumerWidget {
  const RankMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('排行榜')),
      body: const Center(
        child: Text('排行榜主页 - 待实现'),
      ),
    );
  }
}
