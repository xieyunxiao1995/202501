import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 招募卡池页
///
/// 展示特定卡池信息，包括UP武将、保底机制和抽卡按钮。
class RecruitPoolPage extends ConsumerWidget {
  /// 卡池ID
  final String poolId;

  const RecruitPoolPage({super.key, required this.poolId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('招募卡池')),
      body: Center(
        child: Text('招募卡池 - ID: $poolId - 待实现'),
      ),
    );
  }
}
