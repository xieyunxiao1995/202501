import 'package:flutter/material.dart';

/// 资源显示组件
///
/// 显示游戏资源的图标和数量，如木材、铁矿、粮食等。
class ResourceDisplay extends StatelessWidget {
  /// 资源名称
  final String name;

  /// 资源数量
  final int amount;

  /// 资源图标
  final IconData icon;

  /// 图标颜色
  final Color color;

  const ResourceDisplay({
    super.key,
    required this.name,
    required this.amount,
    required this.icon,
    this.color = Colors.brown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(width: 2),
        Text(
          amount.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
