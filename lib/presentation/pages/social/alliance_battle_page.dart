import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 联盟战页
///
/// 联盟间对抗玩法，展示联盟战地图和对战信息。
class AllianceBattlePage extends ConsumerWidget {
  const AllianceBattlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('联盟战')),
      body: const Center(
        child: Text('联盟战 - 待实现'),
      ),
    );
  }
}
