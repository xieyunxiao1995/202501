import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 月卡页
///
/// 展示月卡购买和每日领取界面。
class MonthlyCardPage extends ConsumerWidget {
  const MonthlyCardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('月卡')),
      body: const Center(
        child: Text('月卡 - 待实现'),
      ),
    );
  }
}
