import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 活动详情页
///
/// 展示单个活动的详细信息和参与入口。
class ActivityDetailPage extends ConsumerWidget {
  /// 活动ID
  final String activityId;

  const ActivityDetailPage({super.key, required this.activityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('活动详情')),
      body: Center(
        child: Text('活动详情 - ID: $activityId - 待实现'),
      ),
    );
  }
}
