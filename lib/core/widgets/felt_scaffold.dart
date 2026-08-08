import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/home_controller.dart';
import '../storage/game_storage.dart';

class FeltScaffold extends StatefulWidget {
  const FeltScaffold({
    super.key,
    required this.child,
    this.safeArea = true,
    this.accent,
    this.backgroundAsset,
  });

  final Widget child;
  final bool safeArea;
  final Color? accent;
  final String? backgroundAsset;

  @override
  State<FeltScaffold> createState() => _FeltScaffoldState();
}

class _FeltScaffoldState extends State<FeltScaffold> {
  ThemeOption? _selectedTheme;

  @override
  void initState() {
    super.initState();
    _loadSelectedTheme();
  }

  Future<void> _loadSelectedTheme() async {
    final progress = await GameStorage(
      await SharedPreferences.getInstance(),
    ).loadProgress();
    if (!mounted) return;
    setState(() => _selectedTheme = ThemeOption.byId(progress.selectedTheme));
  }

  @override
  Widget build(BuildContext context) {
    final theme = _selectedTheme ?? ThemeOption.all.first;
    final base = widget.accent ?? Color(theme.tableColor);
    final backgroundAsset = widget.backgroundAsset ?? theme.backgroundAsset;
    final content = Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          backgroundAsset,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => ColoredBox(color: base),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-.18, -.35),
                radius: 1.35,
                colors: [
                  Color.lerp(base, Colors.white, .14)!.withValues(alpha: .62),
                  base.withValues(alpha: .62),
                  Color.lerp(base, Colors.black, .58)!.withValues(alpha: .8),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: .2,
              child: CustomPaint(painter: _FeltPattern()),
            ),
          ),
        ),
        widget.child,
      ],
    );
    return Scaffold(
      backgroundColor: const Color(0xFF071A10),
      body: widget.safeArea ? SafeArea(child: content) : content,
    );
  }
}

class _FeltPattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB9D37A).withValues(alpha: .12);
    for (double x = -30; x < size.width + 50; x += 32) {
      for (double y = -30; y < size.height + 50; y += 32) {
        canvas.drawCircle(Offset(x + (y / 32 % 2) * 8, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
