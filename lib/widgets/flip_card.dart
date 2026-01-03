import 'dart:math';
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool isRevealed;
  final VoidCallback onTap;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.isRevealed,
    required this.onTap,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isRevealed) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed != oldWidget.isRevealed) {
      if (widget.isRevealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFront = angle < pi / 2;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(isFront ? angle : angle + pi);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isFront ? widget.back : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi),
              child: widget.front,
            ),
          );
        },
      ),
    );
  }
}
