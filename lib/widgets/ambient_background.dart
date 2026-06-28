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
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: -100 + topPadding,
            right: -90,
            child: const _Glow(size: 260, color: AppColors.mistBlue),
          ),
          Positioned(
            top: 230 + topPadding,
            left: -130,
            child: _Glow(
              size: 250,
              color: AppColors.blush.withValues(alpha: 0.72),
            ),
          ),
          Positioned(
            bottom: -170,
            right: -120,
            child: _Glow(
              size: 310,
              color: AppColors.mistBlue.withValues(alpha: 0.72),
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
