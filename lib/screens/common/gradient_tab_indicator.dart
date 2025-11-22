import 'package:flutter/material.dart';

class GradientTabIndicator extends Decoration {
  final Gradient gradient;
  final double height;
  final double width;
  final double radius;
  final double bottomMargin;
  final double left;

  const GradientTabIndicator({
    required this.gradient,
    required this.height,
    required this.width,
    required this.radius,
    required this.bottomMargin,
    required this.left,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientPainter(this, onChanged);
  }
}

class _GradientPainter extends BoxPainter {
  final GradientTabIndicator decoration;

  _GradientPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect =
        Offset(
          offset.dx + decoration.left,
          configuration.size!.height -
              decoration.height -
              decoration.bottomMargin,
        ) &
        Size(decoration.width, decoration.height);

    final Paint paint = Paint()
      ..shader = decoration.gradient.createShader(rect);

    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(decoration.radius),
    );
    canvas.drawRRect(rrect, paint);
  }
}
