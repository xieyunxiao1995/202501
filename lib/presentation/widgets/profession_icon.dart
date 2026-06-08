import 'package:flutter/material.dart';

/// 职业图标组件
///
/// 显示武将职业类型（武将、谋士、弓手等）的图标。
class ProfessionIcon extends StatelessWidget {
  /// 职业类型
  final String profession;

  /// 图标尺寸
  final double size;

  const ProfessionIcon({
    super.key,
    required this.profession,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getProfessionIcon(),
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  IconData _getProfessionIcon() {
    switch (profession) {
      case '武将':
        return Icons.shield;
      case '谋士':
        return Icons.auto_stories;
      case '弓手':
        return Icons.gps_fixed;
      case '骑兵':
        return Icons.directions_run;
      default:
        return Icons.person;
    }
  }
}
