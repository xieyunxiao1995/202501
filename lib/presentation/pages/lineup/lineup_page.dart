import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 阵容页
///
/// 配置战斗阵容，包括武将上阵、阵型选择和缘分查看。
class LineupPage extends ConsumerWidget {
  const LineupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('阵容')),
      body: const Center(
        child: Text('阵容配置 - 待实现'),
      ),
    );
  }
}
