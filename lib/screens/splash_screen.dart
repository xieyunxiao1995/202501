import 'package:flutter/material.dart';
import 'dart:async';
import 'settings_screen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _showTapText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _showTapText = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_showTapText) {
      widget.onFinish();
    } else {
      // Skip animation on tap
      _controller.value = 1.0;
      setState(() {
        _showTapText = true;
      });
    }
  }

  void _showPrivacyPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827), // Gray-900
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Center Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Breathing Logo
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: 1.05),
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      onEnd:
                          () {}, // Handled by repeating tween if needed, but simple scale is fine for splash
                      child: const Text(
                        "山海遁根",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          letterSpacing: 6,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.black,
                              offset: Offset(4, 4),
                            ),
                            Shadow(
                              blurRadius: 10,
                              color: Colors.red,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "山 海 奇 谭",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        letterSpacing: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Lore / Subtitle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        "混沌初开，乾坤未定，\n山海异兽，盘踞八荒。\n\n入大荒深处，\n求长生造化。",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.8,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tap to Start (Bottom Center)
            if (_showTapText)
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: const Text(
                          "- 点击进入 -",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Legal Disclaimer (Bottom) - Clickable
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _showPrivacyPolicy,
                  child: Opacity(
                    opacity: 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "入世即代表您已阅并同意大荒协议与遁世密约。",
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
