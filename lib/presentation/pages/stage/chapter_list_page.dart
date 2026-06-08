import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 章节列表页
///
/// 展示战役章节列表，每个章节包含多个关卡。
class ChapterListPage extends ConsumerWidget {
  const ChapterListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('章节列表')),
      body: const Center(
        child: Text('章节列表 - 待实现'),
      ),
    );
  }
}
