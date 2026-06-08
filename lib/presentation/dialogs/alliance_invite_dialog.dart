import 'package:flutter/material.dart';

/// 联盟邀请弹窗
///
/// 收到联盟邀请时的确认弹窗。
class AllianceInviteDialog {
  /// 显示联盟邀请弹窗
  static Future<bool?> show({
    required BuildContext context,
    required String allianceName,
    required String inviterName,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('联盟邀请'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$inviterName 邀请你加入联盟'),
            const SizedBox(height: 8),
            Text(
              allianceName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('拒绝'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('同意'),
          ),
        ],
      ),
    );
  }
}
