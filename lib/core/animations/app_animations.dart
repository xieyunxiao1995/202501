import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 自定义页面转场路由：淡入 + 轻微上滑，退出时轻微缩放
class FadeSlideRoute<T> extends PageRouteBuilder<T> {
  FadeSlideRoute({required WidgetBuilder builder})
      : super(
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 1, curve: Curves.easeOutCubic),
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// 列表项交错入场动画包装器
class SlideFadeIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration? delay;
  const SlideFadeIn({super.key, required this.child, this.index = 0, this.delay});

  @override
  State<SlideFadeIn> createState() => _SlideFadeInState();
}

class _SlideFadeInState extends State<SlideFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    final delayed = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        (widget.delay?.inMilliseconds ?? widget.index * 60) / 600.0 > 0.6
            ? 0.6
            : (widget.delay?.inMilliseconds ?? widget.index * 60) / 600.0,
        1,
        curve: Curves.easeOutCubic,
      ),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(delayed);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(delayed);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: SlideTransition(position: _offset, child: widget.child),
  );
}

/// 可按压卡片：按下时轻微缩放，松开回弹
class PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  const PressableCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1, end: 0.965).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    _pressed = value;
    if (value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(18);
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Material(
          type: MaterialType.transparency,
          borderRadius: radius,
          child: widget.child,
        ),
      ),
    );
  }
}

/// AI 生成中的呼吸光效占位卡片
class GeneratingShimmer extends StatefulWidget {
  final double height;
  const GeneratingShimmer({super.key, this.height = 200});

  @override
  State<GeneratingShimmer> createState() => _GeneratingShimmerState();
}

class _GeneratingShimmerState extends State<GeneratingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      return Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [
              Color(0xFFF6F0FF),
              Color(0xFFEDE4FA),
              Color(0xFFF6F0FF),
            ],
            stops: [
              (_controller.value - 0.3).clamp(0.0, 1.0),
              _controller.value,
              (_controller.value + 0.3).clamp(0.0, 1.0),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.lavender.withValues(alpha: .6),
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                'AI 正在为你搭配…',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepLavender.withValues(alpha: .7),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 内容出现动画：从下方淡入上移
class RevealUp extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const RevealUp({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 420),
  });

  @override
  State<RevealUp> createState() => _RevealUpState();
}

class _RevealUpState extends State<RevealUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: SlideTransition(position: _offset, child: widget.child),
  );
}

/// 美化的 SnackBar 工具
void showAppSnackBar(BuildContext context, String message, {IconData? icon}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: AppColors.ink.withValues(alpha: .88),
        elevation: 0,
        duration: const Duration(milliseconds: 2200),
      ),
    );
}
