import 'package:flutter/material.dart';

/// 兵种图标组件
///
/// 显示兵种类型（步兵、骑兵、弓兵等）的图标。
class TroopTypeIcon extends StatelessWidget {
  /// 兵种类型
  final String troopType;

  /// 图标尺寸
  final double size;

  const TroopTypeIcon({
    super.key,
    required this.troopType,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getTroopTypeIcon(),
      size: size,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  IconData _getTroopTypeIcon() {
    switch (troopType) {
      case '步兵':
        return Icons.hiking;
      case '骑兵':
        return Icons.directions_run;
      case '弓兵':
        return Icons.gps_fixed;
      case '枪兵':
        return Icons.trip_origin;
      default:
        return Icons.groups;
    }
  }
}
