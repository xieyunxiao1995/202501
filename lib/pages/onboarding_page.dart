import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _autoSlideController;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.wb_sunny_outlined,
      title: '记录每日穿搭',
      description: '用照片记录你的每日穿搭，建立专属的穿搭日记本',
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
    ),
    OnboardingData(
      icon: Icons.favorite_border,
      title: '追踪心情变化',
      description: '关联穿搭与心情，发现哪些穿搭让你感觉最好',
      gradient: [Color(0xFF059669), Color(0xFF047857)],
    ),
    OnboardingData(
      icon: Icons.auto_awesome,
      title: 'AI 穿搭建议',
      description: '智能 AI 根据你的风格和场合，提供个性化穿搭建议',
      gradient: [Color(0xFF047857), Color(0xFF065F46)],
    ),
    OnboardingData(
      icon: Icons.people_outline,
      title: '社区分享',
      description: '与志同道合的朋友分享穿搭灵感，互相点赞评论',
      gradient: [Color(0xFF065F46), Color(0xFF064E3B)],
    ),
    OnboardingData(
      icon: Icons.style,
      title: '打造个人风格',
      description: '通过数据分析，找到最适合你的个人穿搭风格',
      gradient: [Color(0xFF064E3B), Color(0xFF10B981)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoSlideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _autoSlideController.addStatusListener(_onAutoSlideStatus);
    _startAutoSlide();
  }

  void _onAutoSlideStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_currentPage < _pages.length - 1) {
        _goToNextPage();
      } else {
        _autoSlideController.stop();
        _navigateToLogin();
      }
    }
  }

  void _startAutoSlide() {
    _autoSlideController.forward(from: 0);
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _startAutoSlide();
    }
  }

  void _goToPage(int index) {
    setState(() {
      _currentPage = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _autoSlideController.reset();
    _startAutoSlide();
  }

  void _skipToEnd() {
    _autoSlideController.stop();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _autoSlideController.reset();
              _startAutoSlide();
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], index == _currentPage);
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: TextButton(
              onPressed: _skipToEnd,
              child: Text(
                '跳过',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildIndicator(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              transform: Matrix4.identity()
                ..scale(isActive ? 1.0 : 0.8),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  data.icon,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.6,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final bool isActive = index == _currentPage;
    return GestureDetector(
      onTap: () => _goToPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: isActive ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
