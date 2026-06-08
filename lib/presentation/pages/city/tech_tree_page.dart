import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 科技树页
///
/// 展示科技研究树，包括已研究、正在研究和可研究的科技。
class TechTreePage extends ConsumerWidget {
  const TechTreePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('科技树')),
      body: const Center(
        child: Text('科技树 - 待实现'),
      ),
    );
  }
}
