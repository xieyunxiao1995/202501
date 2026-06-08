import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 关卡详情页
///
/// 展示关卡详细信息，包括敌人阵容、掉落奖励和推荐战力。
class StageDetailPage extends ConsumerWidget {
  /// 关卡ID
  final String stageId;

  const StageDetailPage({super.key, required this.stageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('关卡详情')),
      body: Center(
        child: Text('关卡详情 - ID: $stageId - 待实现'),
      ),
    );
  }
}
