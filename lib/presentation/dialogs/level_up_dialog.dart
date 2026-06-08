import 'package:flutter/material.dart';

/// 升级弹窗
///
/// 武将升级成功后的展示弹窗，包含属性变化对比。
class LevelUpDialog {
  /// 显示升级弹窗
  static Future<void> show({
    required BuildContext context,
    required String name,
    required int oldLevel,
    required int newLevel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('升级成功'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name),
            const SizedBox(height: 8),
            Text('Lv.$oldLevel -> Lv.$newLevel'),
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
