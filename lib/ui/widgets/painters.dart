import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class BodySchemaPainter extends CustomPainter {
  final double scale;

  BodySchemaPainter({this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.inkBlack.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    
    // Using relative coordinates compatible with CharacterSchemaWidget positioning
    // Widget Tops/Bottoms:
    // Head Top: 0.1 H -> Center: 0.1 H + R
    // Body Top: 0.35 H -> Center: 0.35 H + R
    // Leg Bottom: 0.15 H -> Top: 0.85 H - 2R -> Center: 0.85 H - R
    // Soul/Tail Bottom: 0.3 H -> Top: 0.7 H - 2R -> Center: 0.7 H - R
    
    final headY = size.height * 0.1;
    final bodyY = size.height * 0.35;
    final legY = size.height * 0.85;
    final soulTailBaseY = size.height * 0.7;
    
    final radius = 28.0 * scale;
    final offset20 = 20.0 * scale;
    final offset30 = 30.0 * scale;

    final headCenterY = headY + radius;
    final bodyCenterY = bodyY + radius;
    final legCenterY = legY - radius;
    final soulTailCenterY = soulTailBaseY - radius;

    // Head to Body
    canvas.drawLine(Offset(cx, headCenterY), Offset(cx, bodyCenterY), paint);
    
    // Body to Legs
    canvas.drawLine(Offset(cx, bodyCenterY), Offset(cx, legCenterY), paint);
    
    // Body to Tail (Curve)
    // Tail Widget Right: 0.1 W -> Center X: 0.9 W - R
    final tailCenterX = size.width * 0.9 - radius;
    
    final path = Path();
    path.moveTo(cx + offset20, bodyCenterY);
    path.quadraticBezierTo(size.width * 0.8, bodyCenterY + offset20, tailCenterX, soulTailCenterY);
    canvas.drawPath(path, paint);
    
    // Body to Soul (Dashed/Spiritual)
    final soulPaint = Paint()
      ..color = Colors.purple.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * scale
      ..strokeCap = StrokeCap.round;
      
    // Soul Widget Left: 0.1 W -> Center X: 0.1 W + R
    final soulCenterX = size.width * 0.1 + radius;
    
    canvas.drawCircle(Offset(soulCenterX, soulTailCenterY), offset30, soulPaint..style = PaintingStyle.stroke);
    canvas.drawLine(Offset(cx - offset20, bodyCenterY), Offset(soulCenterX + offset20, soulTailCenterY - offset20), soulPaint);
  }

  @override
  bool shouldRepaint(covariant BodySchemaPainter oldDelegate) => oldDelegate.scale != scale;
}
