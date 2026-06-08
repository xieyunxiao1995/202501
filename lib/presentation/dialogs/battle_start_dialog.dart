import 'package:flutter/material.dart';

/// 战斗开始弹窗
///
/// 战斗开始前的确认弹窗，展示敌我阵容对比。
class BattleStartDialog {
  /// 显示战斗开始弹窗
  static Future<bool?> show({
    required BuildContext context,
    required String stageName,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stageName),
        content: const Text('确认进入战斗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('开战'),
          ),
        ],
      ),
    );
  }
}
