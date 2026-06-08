import 'package:flutter/material.dart';

/// 公告弹窗
///
/// 游戏公告展示弹窗，支持图片和富文本内容。
class AnnouncementDialog {
  /// 显示公告弹窗
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}
