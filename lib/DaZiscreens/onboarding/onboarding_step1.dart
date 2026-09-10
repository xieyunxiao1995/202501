import 'package:flutter/material.dart';
import '../../DaZitheme/app_colors.dart';
import '../../DaZitheme/app_text_styles.dart';

class OnboardingStep1 extends StatelessWidget {
  const OnboardingStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: AppColors.surfaceGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(70),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withAlpha(26),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.circle_outlined,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
                CustomPaint(
                  size: const Size(120, 120),
                  painter: _GoldSeamPainter(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            '欢迎来到金缮艺术',
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '探索这项拥有400年历史的日本传统工艺，用金线修补破碎的陶器。每一道裂痕都是一个故事。',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentGold.withAlpha(77),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '将破碎的器物转化为金色的艺术',
                    style: AppTextStyles.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldSeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = AppColors.goldGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.4,
        size.width * 0.6,
        size.height * 0.35,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.3,
        size.width * 0.75,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.8,
        size.width * 0.5,
        size.height * 0.75,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
