import 'package:flutter/material.dart';
import 'dart:async';
import 'story_splash_screen.dart';

/// ゲーム起動スプラッシュ - シンプルなブランド表示、その後ストーリー紹介ページへ遷移
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _navigateToStoryScreen();
  }

  Future<void> _navigateToStoryScreen() async {
    // アニメーション完了後に遷移
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // ストーリー紹介ページへ遷移
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const StorySplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1a1a2e),
              Color(0xff16213e),
              Color(0xff0f0f23),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 背景星装飾
            ..._buildBackgroundStars(),

            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ゲームアイコン
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xffd49d6a),
                                  Color(0xff8c6751)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xffd49d6a)
                                      .withValues(alpha: 0.5),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // ゲームメインタイトル
                          const Text(
                            '一界旅',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // サブタイトル
                          const Text(
                            'JOURNEY OF ONE REALM',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffd49d6a),
                              letterSpacing: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 下部ローディングヒント
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xffd49d6a),
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '異世界を接続中...',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundStars() {
    return List.generate(
      15,
      (index) => Positioned(
        left: (index * 17.5) % 100,
        top: (index * 23.7) % 100,
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 1500 + (index * 200)),
          tween: Tween(begin: 0.3, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value * 0.5,
              child: child,
            );
          },
          child: Icon(
            Icons.star,
            size: 8 + (index % 3) * 4,
            color: const Color(0xffd49d6a),
          ),
        ),
      ),
    );
  }
}
