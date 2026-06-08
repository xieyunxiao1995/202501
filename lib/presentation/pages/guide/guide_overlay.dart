import 'package:flutter/material.dart';

/// 引导遮罩组件
///
/// 新手引导的高亮遮罩组件，用于突出显示目标UI元素，
/// 并在旁边显示引导提示文字。
class GuideOverlay extends StatelessWidget {
  /// 引导提示文字
  final String message;

  /// 高亮目标的方向
  final GuideDirection direction;

  /// 点击回调
  final VoidCallback? onTap;

  const GuideOverlay({
    super.key,
    required this.message,
    this.direction = GuideDirection.bottom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

/// 引导方向枚举
enum GuideDirection {
  /// 目标上方
  top,

  /// 目标下方
  bottom,

  /// 目标左方
  left,

  /// 目标右方
  right,
}
