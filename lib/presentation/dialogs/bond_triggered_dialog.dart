import 'package:flutter/material.dart';

/// 缘分激活弹窗
///
/// 战斗中缘分触发时的提示弹窗，展示激活的缘分效果。
class BondTriggeredDialog {
  /// 显示缘分激活弹窗
  static Future<void> show({
    required BuildContext context,
    required String bondName,
    required String effect,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('缘分激活'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(bondName),
            const SizedBox(height: 8),
            Text(effect),
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
