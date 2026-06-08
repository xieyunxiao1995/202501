import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 充值页
///
/// 展示充值选项，包括不同档位的元宝充值。
class RechargePage extends ConsumerWidget {
  const RechargePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('充值')),
      body: const Center(
        child: Text('充值 - 待实现'),
      ),
    );
  }
}
