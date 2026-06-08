import 'package:flutter/material.dart';

/// 武将卡片组件
///
/// 用于列表展示的武将卡片，包含头像、名称、等级和阵营信息。
class GeneralCard extends StatelessWidget {
  /// 武将名称
  final String name;

  /// 武将等级
  final int level;

  /// 稀有度（1-5星）
  final int rarity;

  /// 阵营
  final String kingdom;

  /// 点击回调
  final VoidCallback? onTap;

  const GeneralCard({
    super.key,
    required this.name,
    required this.level,
    required this.rarity,
    required this.kingdom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(name),
        subtitle: Text('Lv.$level | $kingdom'),
        trailing: Text('${'★' * rarity}'),
        onTap: onTap,
      ),
    );
  }
}
