import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/theme.dart';

/// 通用标签组件，支持选中/未选中两种状态
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    this.horizontal = 18,
    this.vertical = 8,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;
  final double horizontal;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    final background = selected ? null : Colors.white.withOpacity(0.08);
    final borderColor = selected
        ? Colors.transparent
        : Colors.white.withOpacity(0.1);

    final child = Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      decoration: BoxDecoration(
        gradient: selected ? AppGradients.secondaryGradient : null,
        color: background,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontSize: 14,
        ),
      ),
    );

    if (!enabled) return child;

    return GestureDetector(onTap: onTap, child: child);
  }
}
