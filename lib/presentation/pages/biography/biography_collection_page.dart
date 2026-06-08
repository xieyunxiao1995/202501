import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 传记收集页
///
/// 展示武将传记收集进度，解锁传记可获得专属奖励。
class BiographyCollectionPage extends ConsumerWidget {
  const BiographyCollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('传记')),
      body: const Center(
        child: Text('传记收集 - 待实现'),
      ),
    );
  }
}
