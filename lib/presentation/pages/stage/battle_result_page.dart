import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 战斗结算页
///
/// 展示战斗结果，包括胜负、获得奖励和战斗数据统计。
class BattleResultPage extends ConsumerWidget {
  /// 是否胜利
  final bool isVictory;

  const BattleResultPage({super.key, required this.isVictory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('战斗结算')),
      body: Center(
        child: Text(
          isVictory ? '战斗胜利 - 待实现' : '战斗失败 - 待实现',
        ),
      ),
    );
  }
}
