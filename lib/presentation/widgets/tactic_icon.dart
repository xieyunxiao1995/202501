import 'package:flutter/material.dart';

/// 战法图标组件
///
/// 显示战法图标，战法是武将的核心技能。
class TacticIcon extends StatelessWidget {
  /// 战法ID
  final String tacticId;

  /// 战法名称
  final String name;

  /// 战法等级
  final int level;

  /// 图标尺寸
  final double size;

  /// 点击回调
  final VoidCallback? onTap;

  const TacticIcon({
    super.key,
    required this.tacticId,
    required this.name,
    this.level = 1,
    this.size = 48,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.purple.shade700,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purpleAccent, width: 1),
        ),
        child: Center(
          child: Text(name[0]),
        ),
      ),
    );
  }
}
