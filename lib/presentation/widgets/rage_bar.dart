import 'package:flutter/material.dart';

/// 怒气条组件
///
/// 战斗中显示武将怒气值的进度条，怒气满时可释放大招。
class RageBar extends StatelessWidget {
  /// 当前怒气值
  final double current;

  /// 最大怒气值
  final double max;

  /// 进度条宽度
  final double width;

  /// 进度条高度
  final double height;

  const RageBar({
    super.key,
    required this.current,
    required this.max,
    this.width = 100,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (current / max).clamp(0.0, 1.0);
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Stack(
          children: [
            Container(color: Colors.grey.shade700),
            FractionallySizedBox(
              widthFactor: ratio,
              child: Container(
                color: ratio >= 1.0 ? Colors.yellow : Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
