import 'package:flutter/material.dart';

/// 战法触发弹窗
///
/// 战斗中战法触发时的提示弹窗，展示战法效果。
class TacticTriggeredDialog {
  /// 显示战法触发弹窗
  static Future<void> show({
    required BuildContext context,
    required String tacticName,
    required String generalName,
    required String effect,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('战法触发'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$generalName 发动战法'),
            const SizedBox(height: 8),
            Text(tacticName, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
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
