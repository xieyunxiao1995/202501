import 'package:flutter/material.dart';

/// 首充弹窗
///
/// 首次充值优惠弹窗，展示首充奖励内容。
class FirstPayDialog {
  /// 显示首充弹窗
  static Future<void> show({
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('首充礼包'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('首次充值享受超值奖励！'),
            SizedBox(height: 8),
            Text('奖励内容 - 待实现'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('稍后再说'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 跳转充值页面
              Navigator.of(context).pop();
            },
            child: const Text('立即充值'),
          ),
        ],
      ),
    );
  }
}
