import 'package:flutter/material.dart';

/// 印章组件
///
/// 古风印章样式的装饰组件，用于标题和认证标识。
class SealStamp extends StatelessWidget {
  /// 印章文字
  final String text;

  /// 印章颜色
  final Color color;

  /// 印章尺寸
  final double size;

  const SealStamp({
    super.key,
    required this.text,
    this.color = Colors.red,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SealStampPainter(text: text, color: color),
    );
  }
}

class _SealStampPainter extends CustomPainter {
  final String text;
  final Color color;

  _SealStampPainter({required this.text, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
