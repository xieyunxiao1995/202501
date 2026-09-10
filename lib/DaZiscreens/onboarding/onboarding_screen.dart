import 'package:flutter/material.dart';
import '../../DaZitheme/app_colors.dart';
import '../../DaZitheme/app_text_styles.dart';
import '../../DaZitheme/app_decorations.dart';
import 'onboarding_step1.dart';
import 'onboarding_step2.dart';
import 'onboarding_step3.dart';
import 'onboarding_step4.dart';
import '../../DaZiconfig/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = const [
    OnboardingStep1(),
    OnboardingStep2(),
    OnboardingStep3(),
    OnboardingStep4(),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToEula();
    }
  }

  void _skipOnboarding() {
    _navigateToEula();
  }

  void _navigateToEula() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.eula);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) => _pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.accentGold
                              : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Buttons
                  Row(
                    children: [
                      if (_currentPage < _pages.length - 1)
                        Expanded(
                          child: TextButton(
                            onPressed: _skipOnboarding,
                            child: Text(
                              '跳过',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      if (_currentPage < _pages.length - 1)
                        const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _nextPage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: AppDecorations.primaryButton(),
                            child: Center(
                              child: Text(
                                _currentPage == _pages.length - 1
                                    ? '开始使用'
                                    : '下一步',
                                style: AppTextStyles.button,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
