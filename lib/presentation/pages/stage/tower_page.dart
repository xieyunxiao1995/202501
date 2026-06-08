import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 爬塔页
///
/// 无尽之塔挑战，层数越高难度越大，奖励越丰厚。
class TowerPage extends ConsumerWidget {
  const TowerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('无尽之塔')),
      body: const Center(
        child: Text('无尽之塔 - 待实现'),
      ),
    );
  }
}
