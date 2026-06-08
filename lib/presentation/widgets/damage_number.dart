import 'package:flutter/material.dart';

/// 伤害数字组件
///
/// 战斗中显示飘字伤害/治疗数字的动画组件。
class DamageNumber extends StatelessWidget {
  /// 伤害数值
  final int value;

  /// 是否为治疗
  final bool isHeal;

  /// 是否为暴击
  final bool isCritical;

  const DamageNumber({
    super.key,
    required this.value,
    this.isHeal = false,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isHeal
        ? Colors.green
        : isCritical
            ? Colors.yellow
            : Colors.red;
    final fontSize = isCritical ? 24.0 : 18.0;

    return Text(
      '${isHeal ? '+' : '-'}$value',
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
