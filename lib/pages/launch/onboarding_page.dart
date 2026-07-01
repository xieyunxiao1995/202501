import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../widgets/ambient_background.dart';
import 'onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    required this.onSkip,
    required this.onFinished,
  });

  final VoidCallback onSkip;
  final VoidCallback onFinished;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _slides = [
    OnboardingSlideData(
      eyebrow: '01  STYLE JOURNAL',
      title: '把穿搭，写成生活的注脚',
      description: '用照片和文字留住每天的选择。多年以后，仍能想起那一天的光线与步伐。',
      assetPath: 'assets/images/onboarding/journal.png',
      semanticLabel: '穿搭手账、蓝色开衫与衣架的水彩插画',
    ),
    OnboardingSlideData(
      eyebrow: '02  YOUR WARDROBE',
      title: '看见衣橱真正的秩序',
      description: '整理不是为了拥有更多，而是让真正喜欢的衣服，被重新看见、再次穿上。',
      assetPath: 'assets/images/onboarding/wardrobe.png',
      semanticLabel: '晨光下整齐衣橱的水彩插画',
    ),
    OnboardingSlideData(
      eyebrow: '03  MINDFUL ASSISTANT',
      title: '少买一点，更会搭一点',
      description: 'AI 会先理解你的衣橱，再给出搭配、理性购物与衣物养护建议。',
      assetPath: 'assets/images/onboarding/assistant.png',
      semanticLabel: '针织衫、围巾与克制购物意象的水彩插画',
    ),
    OnboardingSlideData(
      eyebrow: '04  CLOSER TO YOU',
      title: '每一次选择，都更接近自己',
      description: '你的记录默认留在本机。轻盈地开始，在日常里慢慢长出属于自己的风格。',
      assetPath: 'assets/images/onboarding/identity.png',
      semanticLabel: '晨光、蓝色长裙与纸张的水彩插画',
    ),
  ];

  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_currentPage == _slides.length - 1) {
      widget.onFinished();
      return;
    }
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    await _controller.animateToPage(
      _currentPage + 1,
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 430),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _slides.length - 1;
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 14, 4),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'CP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
                    const Text(
                      'CLOTH',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: widget.onSkip,
                      child: const Text('跳过'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (_, index) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: OnboardingSlide(
                        key: ValueKey(index),
                        data: _slides[index],
                        index: index,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                child: Row(
                  children: [
                    Semantics(
                      label: '当前第 ${_currentPage + 1} 页，共 ${_slides.length} 页',
                      child: Row(
                        children: List.generate(_slides.length, (index) {
                          final selected = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            width: selected ? 28 : 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }),
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _next,
                      icon: Icon(
                        isLast
                            ? Icons.arrow_forward_rounded
                            : Icons.arrow_right_alt_rounded,
                      ),
                      label: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          isLast ? '开始使用' : '下一页',
                          key: ValueKey(isLast),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
