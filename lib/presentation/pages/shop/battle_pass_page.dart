import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 战令页
///
/// 展示战令（Battle Pass）进度和奖励。
class BattlePassPage extends ConsumerWidget {
  const BattlePassPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('战令')),
      body: const Center(
        child: Text('战令 - 待实现'),
      ),
    );
  }
}
