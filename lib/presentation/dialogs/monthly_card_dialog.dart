import 'package:flutter/material.dart';

/// 月卡弹窗
///
/// 月卡购买和每日领取的弹窗。
class MonthlyCardDialog {
  /// 显示月卡弹窗
  static Future<void> show({
    required BuildContext context,
    required int remainingDays,
    required int dailyReward,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('月卡'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('剩余天数: $remainingDays'),
            const SizedBox(height: 8),
            Text('今日可领取: $dailyReward'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 领取月卡奖励
              Navigator.of(context).pop();
            },
            child: const Text('领取'),
          ),
        ],
      ),
    );
  }
}
