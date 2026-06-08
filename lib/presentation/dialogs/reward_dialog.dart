import 'package:flutter/material.dart';

/// 奖励弹窗
///
/// 展示获得奖励的弹窗，包含奖励物品列表和确认按钮。
class RewardDialog {
  /// 显示奖励弹窗
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Map<String, int> rewards,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: rewards.entries
              .map((e) => ListTile(
                    title: Text(e.key),
                    trailing: Text('x${e.value}'),
                  ))
              .toList(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('收下'),
          ),
        ],
      ),
    );
  }
}
