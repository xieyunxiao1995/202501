import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 招募记录页
///
/// 展示历史招募记录，包括时间、卡池和获得物品。
class RecruitHistoryPage extends ConsumerWidget {
  const RecruitHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('招募记录')),
      body: const Center(
        child: Text('招募记录 - 待实现'),
      ),
    );
  }
}
