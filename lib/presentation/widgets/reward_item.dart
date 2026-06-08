import 'package:flutter/material.dart';

/// 奖励项组件
///
/// 显示单个奖励物品的图标、名称和数量。
class RewardItem extends StatelessWidget {
  /// 物品名称
  final String name;

  /// 物品数量
  final int count;

  /// 物品图标
  final IconData icon;

  /// 稀有度
  final int rarity;

  /// 点击回调
  final VoidCallback? onTap;

  const RewardItem({
    super.key,
    required this.name,
    this.count = 1,
    this.icon = Icons.card_giftcard,
    this.rarity = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 11)),
          if (count > 1)
            Text('x$count', style: const TextStyle(fontSize: 10, color: Colors.amber)),
        ],
      ),
    );
  }
}
