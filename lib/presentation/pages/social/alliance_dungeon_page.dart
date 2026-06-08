import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 联盟副本页
///
/// 联盟合作副本，成员共同挑战Boss获取奖励。
class AllianceDungeonPage extends ConsumerWidget {
  const AllianceDungeonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('联盟副本')),
      body: const Center(
        child: Text('联盟副本 - 待实现'),
      ),
    );
  }
}
