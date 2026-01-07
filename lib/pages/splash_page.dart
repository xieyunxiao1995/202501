import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'main_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final String _fullText = "混沌初开，乾坤始奠。\n山川异域，万兽奔腾。\n\n你，在这荒古大地上，\n将谱写怎样的传奇？";
  String _displayText = "";
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayText += _fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        _navigateToMain();
      }
    });
  }

  Future<void> _navigateToMain() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _displayText,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  height: 1.8,
                  shadows: [
                    Shadow(
                      color: AppColors.primary,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              if (_currentIndex < _fullText.length)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 2,
                  height: 18,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
