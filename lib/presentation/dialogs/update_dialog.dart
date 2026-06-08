import 'package:flutter/material.dart';

/// 更新弹窗
///
/// 版本更新提示弹窗，包含更新内容和下载按钮。
class UpdateDialog {
  /// 显示更新弹窗
  static Future<void> show({
    required BuildContext context,
    required String version,
    required String changelog,
    required bool isForce,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: !isForce,
      builder: (context) => WillPopScope(
        onWillPop: () async => !isForce,
        child: AlertDialog(
          title: Text('发现新版本 v$version'),
          content: SingleChildScrollView(
            child: Text(changelog),
          ),
          actions: [
            if (!isForce)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('稍后更新'),
              ),
            ElevatedButton(
              onPressed: () {
                // TODO: 开始下载更新
                Navigator.of(context).pop();
              },
              child: const Text('立即更新'),
            ),
          ],
        ),
      ),
    );
  }
}
