import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 战令进度页
///
/// 展示战令各等级奖励和当前进度。
class BattlePassProgressPage extends ConsumerWidget {
  const BattlePassProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('战令进度')),
      body: const Center(
        child: Text('战令进度 - 待实现'),
      ),
    );
  }
}
