import 'package:flutter/material.dart';

class GoldPanel extends StatelessWidget {
  const GoldPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color ?? const Color(0xFF173C25).withValues(alpha: .88),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFBDAF62).withValues(alpha: .52)),
      boxShadow: const [
        BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 6)),
      ],
    ),
    child: child,
  );
}
