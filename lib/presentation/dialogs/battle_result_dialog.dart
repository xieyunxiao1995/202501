import 'package:flutter/material.dart';

/// 战斗结算弹窗
///
/// 战斗结束后的结算弹窗，展示胜负和获得奖励。
class BattleResultDialog {
  /// 显示战斗结算弹窗
  static Future<void> show({
    required BuildContext context,
    required bool isVictory,
    required Map<String, int> rewards,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isVictory ? '战斗胜利' : '战斗失败'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isVictory && rewards.isNotEmpty) ...[
              const Text('获得奖励:'),
              const SizedBox(height: 8),
              ...rewards.entries.map(
                (e) => ListTile(
                  title: Text(e.key),
                  trailing: Text('x${e.value}'),
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}
