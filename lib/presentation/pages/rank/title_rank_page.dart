import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 称号排行页
///
/// 展示称号收集数量排行榜。
class TitleRankPage extends ConsumerWidget {
  const TitleRankPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('称号排行')),
      body: const Center(
        child: Text('称号排行 - 待实现'),
      ),
    );
  }
}
