import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 国战奖励页
///
/// 展示国战阶段奖励和赛季结算奖励。
class KingdomRewardPage extends ConsumerWidget {
  const KingdomRewardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('国战奖励')),
      body: const Center(
        child: Text('国战奖励 - 待实现'),
      ),
    );
  }
}
