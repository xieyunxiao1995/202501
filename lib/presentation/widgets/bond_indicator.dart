import 'package:flutter/material.dart';

/// 缘分指示器组件
///
/// 显示武将之间缘分的连接线和激活状态。
class BondIndicator extends StatelessWidget {
  /// 缘分名称
  final String bondName;

  /// 是否已激活
  final bool isActive;

  /// 参与武将数量
  final int generalCount;

  /// 已参与武将数量
  final int activeCount;

  const BondIndicator({
    super.key,
    required this.bondName,
    this.isActive = false,
    required this.generalCount,
    required this.activeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.orange.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? Colors.orange : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.link : Icons.link_off,
            size: 16,
            color: isActive ? Colors.orange : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            bondName,
            style: TextStyle(
              color: isActive ? Colors.orange : Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$activeCount/$generalCount',
            style: TextStyle(
              color: isActive ? Colors.orange : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
