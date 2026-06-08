import 'package:flutter/material.dart';

/// 获得新武将弹窗
///
/// 首次获得武将时的展示弹窗，包含武将立绘和基本信息。
class GetNewGeneralDialog {
  /// 显示获得新武将弹窗
  static Future<void> show({
    required BuildContext context,
    required String generalName,
    required int rarity,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('获得新武将'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 64),
            const SizedBox(height: 8),
            Text(generalName),
            const SizedBox(height: 4),
            Text('${'★' * rarity}'),
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
