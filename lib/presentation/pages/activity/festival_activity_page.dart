import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 节日活动页
///
/// 限时节日活动页面，包含专属玩法和奖励。
class FestivalActivityPage extends ConsumerWidget {
  const FestivalActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('节日活动')),
      body: const Center(
        child: Text('节日活动 - 待实现'),
      ),
    );
  }
}
