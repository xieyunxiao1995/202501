import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? const Color(0xFF1E293B) : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF475569),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
