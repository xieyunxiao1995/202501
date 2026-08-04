import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashPage({super.key, required this.onComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _SplashData(
      icon: Icons.inventory_2_rounded,
      title: '管理你的衣橱',
      subtitle: '轻松整理所有衣物\n分类清晰，一目了然',
      color: AppColors.lavender,
    ),
    _SplashData(
      icon: Icons.auto_awesome_rounded,
      title: 'AI 智能搭配',
      subtitle: '根据天气、场景和风格\n自动生成穿搭方案',
      color: AppColors.deepLavender,
    ),
    _SplashData(
      icon: Icons.calendar_month_rounded,
      title: '记录穿搭灵感',
      subtitle: '每日可伴\n回顾你的风格成长之路',
      color: Color(0xFF9B7BE0),
    ),
    _SplashData(
      icon: Icons.shield_outlined,
      title: '隐私至上',
      subtitle: '数据全部存储在本地\n不上传、不分享、绝对安全',
      color: Color(0xFF4CAF82),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 跳过按钮
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: widget.onComplete,
                  child: Text(
                    '跳过',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            // 页面内容
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 图标
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                page.color.withValues(alpha: 0.15),
                                page.color.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 64,
                            color: page.color,
                          ),
                        ),
                        const SizedBox(height: 48),
                        // 标题
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // 副标题
                        Text(
                          page.subtitle,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // 指示器和按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
              child: Column(
                children: [
                  // 指示器
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _DotIndicator(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.deepLavender
                              : AppColors.lavender.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 按钮
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _nextPage,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.deepLavender,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentPage < _pages.length - 1 ? '下一步' : '开始体验',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

class _DotIndicator extends StatelessWidget {
  final Duration duration;
  final EdgeInsetsGeometry margin;
  final double width;
  final double height;
  final BoxDecoration decoration;

  const _DotIndicator({
    required this.duration,
    required this.margin,
    required this.width,
    required this.height,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      margin: margin,
      width: width,
      height: height,
      decoration: decoration,
    );
  }
}

class _SplashData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SplashData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
