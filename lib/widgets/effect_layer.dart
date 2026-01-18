import 'dart:math';
import 'package:flutter/material.dart';

class ShakeWidget extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final double intensity;

  const ShakeWidget({
    super.key,
    required this.child,
    required this.controller,
    this.intensity = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double offset = sin(controller.value * pi * 4) * intensity * (1 - controller.value);
        return Transform.translate(
          offset: Offset(offset, 0), // Horizontal shake
          child: child,
        );
      },
      child: child,
    );
  }
}
