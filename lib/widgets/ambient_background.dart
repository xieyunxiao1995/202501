import 'package:flutter/material.dart';

import '../app/app_theme.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({
    super.key,
    required this.child,
    this.topPadding = 0,
  });

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned(
            top: -100 + topPadding,
            right: -90,
            child: const _Glow(size: 280, color: Color(0xFF4C1D95)),
          ),
          Positioned(
            top: 230 + topPadding,
            left: -130,
            child: _Glow(
              size: 260,
              color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
            ),
          ),
          Positioned(
            bottom: -170,
            right: -120,
            child: _Glow(
              size: 320,
              color: const Color(0xFFDB2777).withValues(alpha: 0.2),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
