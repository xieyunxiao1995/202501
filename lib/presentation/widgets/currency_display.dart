import 'package:flutter/material.dart';

/// 货币显示组件
///
/// 显示游戏货币的图标和数量，如元宝、铜钱等。
class CurrencyDisplay extends StatelessWidget {
  /// 货币图标
  final IconData icon;

  /// 货币数量
  final int amount;

  /// 图标颜色
  final Color color;

  /// 是否显示加号按钮
  final bool showAddButton;

  /// 加号按钮回调
  final VoidCallback? onAddTap;

  const CurrencyDisplay({
    super.key,
    required this.icon,
    required this.amount,
    this.color = Colors.amber,
    this.showAddButton = false,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            _formatAmount(amount),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          if (showAddButton) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onAddTap,
              child: const Icon(Icons.add_circle, size: 14, color: Colors.amber),
            ),
          ],
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 10000) return '${(amount / 10000).toStringAsFixed(1)}万';
    return amount.toString();
  }
}
