import 'package:flutter/material.dart';

/// 阵型图标组件
///
/// 显示阵型类型的图标，如锋矢阵、鱼鳞阵等。
class FormationIcon extends StatelessWidget {
  /// 阵型ID
  final String formationId;

  /// 阵型名称
  final String name;

  /// 图标尺寸
  final double size;

  /// 是否选中
  final bool isSelected;

  /// 点击回调
  final VoidCallback? onTap;

  const FormationIcon({
    super.key,
    required this.formationId,
    required this.name,
    this.size = 48,
    this.isSelected = false,
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
          color: isSelected ? Colors.orange.shade700 : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.orangeAccent, width: 2)
              : null,
        ),
        child: Center(
          child: Text(name[0]),
        ),
      ),
    );
  }
}
