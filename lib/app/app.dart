import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';
import '../data/local_storage.dart';
import '../models/outfit_models.dart';
import '../widgets/app_widgets.dart';
import '../services/background_music_service.dart';
import '../pages/home/home_page.dart';
import '../pages/home/outfit_record_page.dart';
import '../pages/ai_styling/ai_styling_page.dart';
import '../pages/diary/diary_page.dart';
import '../pages/wardrobe/wardrobe_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/onboarding/splash_page.dart';
import '../pages/onboarding/welcome_page.dart';

class OutfitDiaryApp extends StatelessWidget {
  const OutfitDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '可伴 AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AppGate(),
    );
  }
}

/// 应用入口：每次启动均显示闪屏 + 知情同意页
class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) => const _OnboardingFlow();
}

/// 启动流程：闪屏 → 知情同意页 → 主界面
class _OnboardingFlow extends StatefulWidget {
  const _OnboardingFlow();
  @override
  State<_OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<_OnboardingFlow> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashPage(
        onComplete: () {
          setState(() => _showSplash = false);
        },
      );
    }
    return WelcomePage(
      onAccepted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Shell()),
        );
      },
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  int diaryCount = 7;
  bool savedToday = false;
  final LocalStorage storage = LocalStorage();
  late final List<Widget> pages;
  final labels = const ['今日穿搭', 'AI穿搭', '可伴', '我的衣橱', '设置'];
  final icons = const [
    Icons.checkroom_rounded,
    Icons.auto_awesome_rounded,
    Icons.calendar_month_rounded,
    Icons.inventory_2_rounded,
    Icons.settings_rounded,
  ];

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(onRecordSaved: _load),
      const AiStylingPage(),
      const DiaryPage(),
      const WardrobePage(),
      const SettingsPage(),
    ];
    _load();
    // 初始化背景音乐服务
    BackgroundMusicService().init();
  }

  Future<void> _load() async {
    final count = await storage.readDiaryCount();
    final saved = await storage.readSavedToday();
    if (!mounted) return;
    setState(() {
      diaryCount = count;
      savedToday = saved;
    });
  }

  Future<void> _saveToday() async {
    final messenger = ScaffoldMessenger.of(context);
    final entry = await Navigator.push<DiaryEntry>(
      context,
      FadeSlideRoute(builder: (_) => const OutfitRecordPage()),
    );
    if (entry == null || !mounted) return;
    await storage.saveToday();
    await _load();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Expanded(child: Text('已记录到可伴')),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: AppColors.ink.withValues(alpha: .88),
          elevation: 0,
          duration: const Duration(milliseconds: 2200),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBackground.base,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        height: 72,
        backgroundColor: Colors.white.withValues(alpha: .96),
        indicatorColor: AppColors.lavender.withValues(alpha: .14),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: [
          for (var i = 0; i < labels.length; i++)
            NavigationDestination(
              icon: Icon(icons[i]),
              selectedIcon: Icon(icons[i], color: AppColors.deepLavender),
              label: labels[i],
            ),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton.small(
              backgroundColor: AppColors.deepLavender,
              foregroundColor: Colors.white,
              elevation: 2,
              onPressed: _saveToday,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: Icon(
                  savedToday ? Icons.check : Icons.add,
                  key: ValueKey(savedToday),
                ),
              ),
            )
          : null,
    );
  }
}
