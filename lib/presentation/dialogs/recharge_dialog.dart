import 'package:flutter/material.dart';

/// 充值弹窗
///
/// 充值确认弹窗，展示充值档位和支付确认。
class RechargeDialog {
  /// 显示充值弹窗
  static Future<bool?> show({
    required BuildContext context,
    required String productName,
    required String price,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认充值'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(productName),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认支付'),
          ),
        ],
      ),
    );
  }
}
