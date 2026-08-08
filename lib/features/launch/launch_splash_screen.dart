import 'dart:async';

import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({super.key});

  @override
  State<LaunchSplashScreen> createState() => _LaunchSplashScreenState();
}

class _LaunchSplashScreenState extends State<LaunchSplashScreen> {
  static const _pages = <_SplashPageData>[
    _SplashPageData(
      icon: Icons.auto_awesome_rounded,
      eyebrow: 'SOLITAIRE JOURNEY',
      title: 'A quiet table.\nA new adventure.',
      body:
          'Take a breath, find the next move, and let the cards tell the story.',
    ),
    _SplashPageData(
      icon: Icons.map_rounded,
      eyebrow: 'THREE WAYS TO PLAY',
      title: 'Classic, Journey,\nand Creative.',
      body:
          'Play a relaxed deal, follow the chapter path, or try a twist on solitaire.',
    ),
    _SplashPageData(
      icon: Icons.play_circle_fill_rounded,
      eyebrow: 'YOUR NEXT MOVE',
      title: 'Ready when\nyou are.',
      body:
          'Your progress is saved on this device. Pick up the journey whenever you return.',
    ),
  ];

  final _pageController = PageController();
  Timer? _advanceTimer;
  var _page = 0;
  var _finishing = false;

  @override
  void initState() {
    super.initState();
    _advanceTimer = Timer.periodic(const Duration(milliseconds: 950), (_) {
      if (!mounted || _finishing) return;
      if (_page < _pages.length - 1) {
        _pageController.animateToPage(
          _page + 1,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
        );
      } else {
        _finish();
      }
    });
  }

  @override
  void dispose() {
    _advanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _finish() {
    if (_finishing || !mounted) return;
    _finishing = true;
    _advanceTimer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF071A10),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.style_rounded,
                        color: Color(0xFFFFD34F),
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SOLITAIRE JOURNEY',
                        style: TextStyle(
                          color: Color(0xFFE9E2C1),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        key: const ValueKey('splash-skip'),
                        onPressed: _finish,
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PageView.builder(
                      key: const ValueKey('launch-splash-pages'),
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (value) => setState(() => _page = value),
                      itemCount: _pages.length,
                      itemBuilder: (context, index) => _SplashPage(
                        key: ValueKey('splash-page-$index'),
                        data: _pages[index],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var index = 0; index < _pages.length; index++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _page ? 26 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == _page
                                ? const Color(0xFFFFD34F)
                                : const Color(0xFF8AA878),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${_page + 1} / ${_pages.length}',
                    style: const TextStyle(
                      color: Color(0xFFB6C5A8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _SplashPage extends StatelessWidget {
  const _SplashPage({super.key, required this.data});

  final _SplashPageData data;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF173C25),
              border: Border.all(
                color: const Color(0xFFFFD34F).withValues(alpha: .72),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x664F8C41),
                  blurRadius: 28,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(data.icon, color: const Color(0xFFFFD34F), size: 58),
          ),
          const SizedBox(height: 28),
          Text(
            data.eyebrow,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFE7A3),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF6F0D4),
              fontFamily: 'serif',
              fontSize: 37,
              height: 1.02,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 330),
            child: Text(
              data.body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFD5DECA),
                fontSize: 15,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SplashPageData {
  const _SplashPageData({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;
}
