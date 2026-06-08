import 'package:flutter/material.dart';

/// 维护弹窗
///
/// 服务器维护通知弹窗，包含维护时间和补偿信息。
class MaintenanceDialog {
  /// 显示维护弹窗
  static Future<void> show({
    required BuildContext context,
    required String message,
    String? endTime,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('服务器维护'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            if (endTime != null) ...[
              const SizedBox(height: 8),
              Text('预计结束时间: $endTime'),
            ],
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
