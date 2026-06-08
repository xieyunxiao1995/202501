import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 占卜页
///
/// 占卜玩法页面，消耗资源进行占卜获取随机奖励。
class DivinationPage extends ConsumerWidget {
  const DivinationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('占卜')),
      body: const Center(
        child: Text('占卜 - 待实现'),
      ),
    );
  }
}
