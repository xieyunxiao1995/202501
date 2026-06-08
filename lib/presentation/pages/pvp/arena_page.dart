import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 竞技场页
///
/// PVP竞技场入口，展示排名、对手列表和挑战按钮。
class ArenaPage extends ConsumerWidget {
  const ArenaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('竞技场')),
      body: const Center(
        child: Text('竞技场 - 待实现'),
      ),
    );
  }
}
