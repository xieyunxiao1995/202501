import 'package:flutter/material.dart';

/// 觉醒弹窗
///
/// 武将觉醒成功后的展示弹窗，包含觉醒特效和新技能展示。
class AwakeDialog {
  /// 显示觉醒弹窗
  static Future<void> show({
    required BuildContext context,
    required String generalName,
    required String awakeSkill,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('觉醒成功'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(generalName),
            const SizedBox(height: 8),
            Text('觉醒技能: $awakeSkill'),
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
