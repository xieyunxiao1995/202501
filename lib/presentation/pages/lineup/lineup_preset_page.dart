import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 阵容预设页
///
/// 管理多套阵容预设，方便在不同场景快速切换。
class LineupPresetPage extends ConsumerWidget {
  const LineupPresetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('阵容预设')),
      body: const Center(
        child: Text('阵容预设管理 - 待实现'),
      ),
    );
  }
}
