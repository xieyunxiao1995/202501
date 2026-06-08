import 'package:flutter/material.dart';

/// 加载遮罩组件
///
/// 全屏加载遮罩，显示加载动画和提示文字。
class LoadingOverlay extends StatelessWidget {
  /// 提示文字
  final String message;

  const LoadingOverlay({
    super.key,
    this.message = '加载中...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
