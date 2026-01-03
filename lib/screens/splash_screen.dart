import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _storyLines = [
    "The world has forgotten...",
    "Only the Tower remains.",
    "Memories are power.",
    "Climb. Remember. Survive.",
  ];

  int _currentLineIndex = 0;
  double _opacity = 0.0;
  bool _showButton = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startStoryAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startStoryAnimation() {
    // Initial delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _fadeInLine();
    });
  }

  void _fadeInLine() {
    setState(() {
      _opacity = 1.0;
    });

    // Hold text, then fade out or switch
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        if (_currentLineIndex < _storyLines.length - 1) {
          setState(() {
            _opacity = 0.0;
          });
          // Wait for fade out to complete before showing next line
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _currentLineIndex++;
                _fadeInLine(); // Recursion for next line
              });
            }
          });
        } else {
          // Final line stays, show button
          setState(() {
            _showButton = true;
          });
        }
      }
    });
  }

  void _skipOrEnter() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [AppColors.accent.withOpacity(0.1), Colors.black],
                ),
              ),
            ),
          ),

          // Story Text
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  _storyLines[_currentLineIndex],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'serif',
                    height: 1.5,
                    shadows: [
                      BoxShadow(
                        color: AppColors.accent,
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Skip / Enter Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedOpacity(
                opacity: _showButton
                    ? 1.0
                    : 0.0, // Only show "Enter" at end, but user can tap screen anytime really
                duration: const Duration(milliseconds: 1000),
                child: TextButton(
                  onPressed: _skipOrEnter,
                  child: const Text(
                    "Tap to Enter the Void",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Invisible full screen tap detector for skipping
          Positioned.fill(
            child: GestureDetector(
              onTap: _skipOrEnter,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
