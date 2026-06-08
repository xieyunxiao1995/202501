import 'package:flutter/material.dart';

/// 武将详情弹窗
///
/// 快速查看武将基本信息的弹窗，不跳转页面。
class GeneralDetailDialog {
  /// 显示武将详情弹窗
  static Future<void> show({
    required BuildContext context,
    required String generalId,
    required String generalName,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(generalName),
        content: const Text('武将详情 - 待实现'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 跳转到武将详情页
            },
            child: const Text('查看详情'),
          ),
        ],
      ),
    );
  }
}
