import 'package:flutter/material.dart';

/// 错误视图组件
///
/// 加载失败时显示的错误提示视图，支持重试操作。
class ErrorView extends StatelessWidget {
  /// 错误信息
  final String message;

  /// 重试回调
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    this.message = '加载失败',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('重试'),
            ),
          ],
        ],
      ),
    );
  }
}
