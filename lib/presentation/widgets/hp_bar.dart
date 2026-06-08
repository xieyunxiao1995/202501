import 'package:flutter/material.dart';

/// 生命条组件
///
/// 战斗中显示武将生命值的进度条组件。
class HpBar extends StatelessWidget {
  /// 当前生命值
  final double current;

  /// 最大生命值
  final double max;

  /// 进度条宽度
  final double width;

  /// 进度条高度
  final double height;

  const HpBar({
    super.key,
    required this.current,
    required this.max,
    this.width = 100,
    this.height = 8,
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
                color: _getHpColor(ratio),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHpColor(double ratio) {
    if (ratio > 0.5) return Colors.green;
    if (ratio > 0.25) return Colors.orange;
    return Colors.red;
  }
}
