import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 限时活动页
///
/// 限时活动页面，包含倒计时和专属奖励。
class LimitedEventPage extends ConsumerWidget {
  const LimitedEventPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('限时活动')),
      body: const Center(
        child: Text('限时活动 - 待实现'),
      ),
    );
  }
}
