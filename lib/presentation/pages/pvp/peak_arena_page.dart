import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 巅峰竞技场页
///
/// 高阶PVP玩法，支持Ban/Pick和实时对战。
class PeakArenaPage extends ConsumerWidget {
  const PeakArenaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('巅峰竞技场')),
      body: const Center(
        child: Text('巅峰竞技场 - 待实现'),
      ),
    );
  }
}
