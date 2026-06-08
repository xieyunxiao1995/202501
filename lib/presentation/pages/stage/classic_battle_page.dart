import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 经典战役页
///
/// 三国经典战役副本，重现历史名场面。
class ClassicBattlePage extends ConsumerWidget {
  const ClassicBattlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('经典战役')),
      body: const Center(
        child: Text('经典战役 - 待实现'),
      ),
    );
  }
}
