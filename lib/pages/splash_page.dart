import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/route_paths.dart';

/// 闪屏页
///
/// 展示"三国天下"四个大字的开场动画，包含：
/// - 暗红渐变背景
/// - 背景光晕装饰
/// - 逐字浮现 + 微动效果
/// - 红色扫光掠过文字
/// - 动画结束后跳转到登录页
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _sweepAnimation;
  bool _hasNavigated = false;

  static const _titleChars = ['三', '国', '天', '下'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 40,
      ),
    ]).animate(_controller);
    _sweepAnimation = Tween<double>(begin: -1.35, end: 1.35).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.14, 0.9, curve: Curves.easeInOutCubic),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_hasNavigated && mounted) {
        _hasNavigated = true;
        context.go(RoutePaths.login);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF120D0D), Color(0xFF241616), Color(0xFF090909)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _BackgroundGlow(
              alignment: Alignment(-0.85, -0.8),
              size: 180,
              color: Color(0x33A11717),
            ),
            const _BackgroundGlow(
              alignment: Alignment(0.82, 0.75),
              size: 220,
              color: Color(0x226A0F0F),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final progress = _controller.value;
                  final pulse = 1 + math.sin(progress * math.pi * 5) * 0.018;

                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: pulse,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (
                            var index = 0;
                            index < _titleChars.length;
                            index++
                          ) ...[
                            _TitleChar(
                              char: _titleChars[index],
                              charIndex: index,
                              progress: progress,
                              sweepAlignment: _sweepAnimation.value,
                            ),
                            if (index != _titleChars.length - 1)
                              const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 单个标题字符
///
/// 每个字符有独立的微动漂浮动画和红色扫光效果。
class _TitleChar extends StatelessWidget {
  const _TitleChar({
    required this.char,
    required this.charIndex,
    required this.progress,
    required this.sweepAlignment,
  });

  final String char;
  final int charIndex;
  final double progress;
  final double sweepAlignment;

  static const _fontFallbacks = [
    'HanziPen SC',
    'STKaiti',
    'Kaiti SC',
    'KaiTi',
    'DFKai-SB',
    'serif',
  ];

  TextStyle _fillStyle(Color color) {
    return TextStyle(
      fontSize: 82,
      height: 0.92,
      fontWeight: FontWeight.w700,
      color: color,
      fontFamily: _fontFallbacks.first,
      fontFamilyFallback: _fontFallbacks.sublist(1),
      shadows: const [
        Shadow(color: Color(0xCC7A0D0D), blurRadius: 18, offset: Offset(0, 0)),
        Shadow(color: Color(0xE6000000), blurRadius: 2, offset: Offset(3, 4)),
      ],
    );
  }

  TextStyle _strokeStyle() {
    return TextStyle(
      fontSize: 82,
      height: 0.92,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFallbacks.first,
      fontFamilyFallback: _fontFallbacks.sublist(1),
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = const Color(0xFF2A1616),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phase = progress * math.pi * 2;
    final offsetX = math.cos(phase * 2 + charIndex * 0.7) * 1.6;
    final offsetY = math.sin(phase * 3 + charIndex * 0.9) * 2.8;
    final baseAngle = char == '尸' ? -0.03 : 0.02;
    final wobble = math.sin(phase * 1.7 + charIndex) * 0.028;

    return Transform.rotate(
      angle: baseAngle + wobble,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(char, style: _strokeStyle()),
            Text(char, style: _fillStyle(const Color(0xFFE2D9CD))),
            ClipRect(
              child: Align(
                alignment: Alignment(0, sweepAlignment),
                heightFactor: 0.34,
                child: Text(char, style: _fillStyle(const Color(0xFFE14F4F))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 背景光晕装饰
///
/// 不可交互的圆形渐变光斑，营造暗红氛围。
class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({
    required this.alignment,
    required this.size,
    required this.color,
  });

  final Alignment alignment;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color, Colors.transparent]),
          ),
        ),
      ),
    );
  }
}
