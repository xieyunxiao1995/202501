import 'package:flutter/material.dart';

/// 稀有度边框组件
///
/// 根据稀有度显示不同颜色和样式的边框装饰。
class RarityFrame extends StatelessWidget {
  /// 稀有度（1-5星）
  final int rarity;

  /// 子组件
  final Widget child;

  const RarityFrame({
    super.key,
    required this.rarity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _getRarityColor(),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Color _getRarityColor() {
    switch (rarity) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
