import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 联盟排行页
///
/// 展示联盟实力排行榜。
class AllianceRankPage extends ConsumerWidget {
  const AllianceRankPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('联盟排行')),
      body: const Center(
        child: Text('联盟排行 - 待实现'),
      ),
    );
  }
}
