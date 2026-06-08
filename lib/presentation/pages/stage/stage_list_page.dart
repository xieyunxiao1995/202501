import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 关卡列表页
///
/// 展示某个章节下的所有关卡，包括普通和困难模式。
class StageListPage extends ConsumerWidget {
  /// 章节ID
  final String chapterId;

  const StageListPage({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('关卡列表')),
      body: Center(
        child: Text('关卡列表 - 章节: $chapterId - 待实现'),
      ),
    );
  }
}
