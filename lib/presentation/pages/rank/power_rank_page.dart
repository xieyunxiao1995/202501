import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 战力排行页
///
/// 展示全服战力排行榜。
class PowerRankPage extends ConsumerWidget {
  const PowerRankPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('战力排行')),
      body: const Center(
        child: Text('战力排行 - 待实现'),
      ),
    );
  }
}
