import 'package:flutter/material.dart';

/// 空视图组件
///
/// 列表为空时显示的占位视图。
class EmptyView extends StatelessWidget {
  /// 提示文字
  final String message;

  /// 图标
  final IconData icon;

  /// 操作按钮文字
  final String? actionText;

  /// 操作按钮回调
  final VoidCallback? onAction;

  const EmptyView({
    super.key,
    this.message = '暂无数据',
    this.icon = Icons.inbox,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          if (actionText != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}
