import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// 跑马灯
class MarqueeText extends StatefulWidget {
  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.speed = 40,
    this.gapRatio = 0.3,
  });

  final String text;
  final TextStyle style;
  final double speed;
  final double gapRatio;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double>? _animation;
  double _textWidth = 0;
  double _textHeight = 0;
  double _containerWidth = 0;
  String _lastText = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scheduleConfigure();
  }

  @override
  void didUpdateWidget(covariant MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.style != widget.style ||
        oldWidget.speed != widget.speed ||
        oldWidget.gapRatio != widget.gapRatio) {
      _scheduleConfigure();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scheduleConfigure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _configureAnimation();
    });
  }

  void _configureAnimation() {
    final text = widget.text;
    if (text.isEmpty || _containerWidth <= 0) {
      _controller.stop();
      setState(() => _animation = null);
      return;
    }

    final painter = TextPainter(
      text: TextSpan(text: text, style: widget.style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
      ellipsis: '',
    )..layout();
    _textWidth = painter.width;
    _textHeight = painter.height;
    _lastText = text;

    if (_textWidth <= _containerWidth) {
      _controller.stop();
      setState(() => _animation = null);
      return;
    }

    final gap = _containerWidth * widget.gapRatio;
    final distance = _textWidth + gap;
    final speed = widget.speed <= 0 ? 40 : widget.speed;
    final durationMs = math.max((distance / speed * 1000).round(), 1000);

    _controller
      ..stop()
      ..duration = Duration(milliseconds: durationMs)
      ..reset();

    _animation = Tween<double>(
      begin: 0,
      end: distance,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.repeat();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (_containerWidth != maxWidth) {
          _containerWidth = maxWidth;
          _scheduleConfigure();
        } else if (_lastText != widget.text) {
          _scheduleConfigure();
        }

        final height = _textHeight > 0
            ? _textHeight
            : (widget.style.fontSize ?? 14) * 1.2;

        if (_animation == null) {
          return SizedBox(
            height: height,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.text, style: widget.style),
            ),
          );
        }

        final gap = _containerWidth * widget.gapRatio;

        return SizedBox(
          height: height,
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                final distance = _textWidth + gap;
                final offset = _animation!.value % distance;
                final firstLeft = -offset;
                final secondLeft = firstLeft + distance;
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      left: firstLeft,
                      width: _textWidth,
                      child: child!,
                    ),
                    Positioned(
                      left: secondLeft,
                      width: _textWidth,
                      child: child,
                    ),
                  ],
                );
              },
              child: Text(widget.text, style: widget.style),
            ),
          ),
        );
      },
    );
  }
}
