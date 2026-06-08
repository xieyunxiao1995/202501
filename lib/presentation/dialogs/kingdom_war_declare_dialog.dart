import 'package:flutter/material.dart';

/// 国战宣战弹窗
///
/// 国战中的宣战确认弹窗，展示目标城池和出阵信息。
class KingdomWarDeclareDialog {
  /// 显示宣战弹窗
  static Future<bool?> show({
    required BuildContext context,
    required String cityName,
    required String ownerKingdom,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('宣战'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('目标城池: $cityName'),
            const SizedBox(height: 8),
            Text('当前占领: $ownerKingdom'),
            const SizedBox(height: 8),
            const Text('确认发起攻城战？'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('宣战'),
          ),
        ],
      ),
    );
  }
}
