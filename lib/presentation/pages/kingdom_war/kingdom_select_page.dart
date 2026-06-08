import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 国家选择页
///
/// 玩家首次进入国战时选择所属国家（魏蜀吴）。
class KingdomSelectPage extends ConsumerWidget {
  const KingdomSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择国家')),
      body: const Center(
        child: Text('选择国家 - 待实现'),
      ),
    );
  }
}
