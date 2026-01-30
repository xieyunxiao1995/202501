import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final double overlayOpacity;

  const AppBackground({
    super.key,
    required this.child,
    this.backgroundImage,
    this.overlayOpacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            backgroundImage ?? 'assets/Bg/Bg1.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        // Overlay
        Positioned.fill(
          child: Container(
            color: AppColors.bg.withOpacity(overlayOpacity),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  final String title;
  final String message;

  const ErrorDisplay({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "⚠️ $title\n",
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: message,
              style: const TextStyle(color: AppColors.textMain, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class PulsingOrb extends StatefulWidget {
  const PulsingOrb({super.key});

  @override
  State<PulsingOrb> createState() => _PulsingOrbState();
}

class _PulsingOrbState extends State<PulsingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer rings
        ...List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 150 + (i * 30) * _animation.value,
                height: 150 + (i * 30) * _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.1 - (i * 0.03)),
                    width: 1,
                  ),
                ),
              );
            },
          );
        }),
        ScaleTransition(
          scale: _animation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.4),
                  AppColors.secondary.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "🧘",
                style: TextStyle(
                  fontSize: 48,
                  shadows: [Shadow(color: AppColors.secondary, blurRadius: 20)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScanningGrid extends StatelessWidget {
  const ScanningGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: GridPainter(), child: Container());
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withOpacity(0.05)
      ..strokeWidth = 1.0;

    const spacing = 30.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FloatingGainText extends StatefulWidget {
  final String text;
  final Offset position;
  final VoidCallback onComplete;

  const FloatingGainText({
    super.key,
    required this.text,
    required this.position,
    required this.onComplete,
  });

  @override
  State<FloatingGainText> createState() => _FloatingGainTextState();
}

class _FloatingGainTextState extends State<FloatingGainText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _move;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _move = Tween<Offset>(
      begin: widget.position,
      end: widget.position + const Offset(0, -50),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _move.value.dx,
          top: _move.value.dy,
          child: Opacity(
            opacity: _opacity.value,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        );
      },
    );
  }
}
