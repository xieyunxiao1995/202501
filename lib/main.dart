import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'level_select_screen.dart';
import 'achievement_screen.dart';
import 'settings_screen.dart';
import 'daily_tasks_screen.dart';
import 'character_upgrade_screen.dart';
import 'card_upgrade_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Enable edge-to-edge, hide status bar feel for immersion
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const OrbitMergeApp());
}

class OrbitMergeApp extends StatelessWidget {
  const OrbitMergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '星轨防线 Orbit Defense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030408),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00F0FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'sans-serif',
      ),
      home: const SplashScreen(),
    );
  }
}

// ===================== 3页闪屏 =====================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _autoTimer;

  final List<SplashPage> _pages = const [
    SplashPage(
      icon: '🌌',
      title: '星轨防线',
      subtitle: 'Orbit Defense',
      description: '在浩瀚宇宙中，合并能量节点\n守护你的星际基地',
    ),
    SplashPage(
      icon: '🔗',
      title: '合并升级',
      subtitle: 'Merge & Upgrade',
      description: '拖拽相同节点进行合并\n解锁更高阶的能量形态',
    ),
    SplashPage(
      icon: '🛡️',
      title: '星际防御',
      subtitle: 'Defend & Conquer',
      description: '部署防御塔抵御入侵\n挑战81个星际关卡',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        _autoTimer?.cancel();
        _navigateToNameInput();
      }
    });
  }

  void _navigateToNameInput() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const NameInputScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      body: GestureDetector(
        onTap: () {
          if (_currentPage < _pages.length - 1) {
            _currentPage++;
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            _autoTimer?.cancel();
            _autoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
              if (!mounted) return;
              if (_currentPage < _pages.length - 1) {
                _currentPage++;
                _pageController.animateToPage(
                  _currentPage,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              } else {
                _autoTimer?.cancel();
                _navigateToNameInput();
              }
            });
          } else {
            _autoTimer?.cancel();
            _navigateToNameInput();
          }
        },
        child: Stack(
          children: [
            // Background stars
            CustomPaint(painter: _SplashStarPainter()),
            // Pages
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index];
              },
            ),
            // Page indicator
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF00F0FF)
                          : const Color(0xFF334455),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: _currentPage == index
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00F0FF).withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
              ),
            ),
            // Skip button
            Positioned(
              bottom: 40,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  _autoTimer?.cancel();
                  _navigateToNameInput();
                },
                child: Text(
                  '跳过 >',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF667788),
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

class SplashPage extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String description;
  const SplashPage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00F0FF).withOpacity(0.3),
                  const Color(0xFF00F0FF).withOpacity(0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F0FF).withOpacity(0.2),
                  blurRadius: 50,
                ),
              ],
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 70)),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00F0FF),
              letterSpacing: 4,
              shadows: [Shadow(color: Color(0xFF00F0FF), blurRadius: 15)],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF667788),
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFFAABBCC),
              height: 1.8,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _SplashStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = _seededRandom(42);
    for (var i = 0; i < 80; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color = const Color(0xFFAABBCC).withOpacity(rng.nextDouble() * 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _seededRandom {
  _seededRandom(int seed) : _seed = seed;
  int _seed;
  double nextDouble() {
    _seed = (_seed * 16807 + 0) % 2147483647;
    return _seed / 2147483647;
  }
}

// ===================== 用户名输入页面 =====================

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入角色名'),
          backgroundColor: Color(0xFFFF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (name.length > 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('角色名不能超过12个字符'),
          backgroundColor: Color(0xFFFF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainHubScreen(playerName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00F0FF).withOpacity(0.4),
                      const Color(0xFF00F0FF).withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withOpacity(0.3),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🌌', style: TextStyle(fontSize: 50)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '星轨防线',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00F0FF),
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Orbit Defense',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667788),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 60),

              // 输入区域
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const Text(
                      '请输入你的角色名',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8899AA),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1628),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF00F0FF).withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F0FF).withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        maxLength: 12,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF00F0FF),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: '输入角色名',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF334455),
                          ),
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _submitName(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitName,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 14,
                        ),
                        backgroundColor: const Color(0xFF00F0FF),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: const Color(0xFF00F0FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '确 定',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
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

// ===================== 主导航中心 =====================

class MainHubScreen extends StatefulWidget {
  final String playerName;
  const MainHubScreen({super.key, required this.playerName});

  @override
  State<MainHubScreen> createState() => _MainHubScreenState();
}

class _MainHubScreenState extends State<MainHubScreen>
    with TickerProviderStateMixin {
  late AnimationController _starTwinkleController;

  // Player stats
  final int _energyCrystals = 1250;
  final int _stars = 48;

  @override
  void initState() {
    super.initState();
    _starTwinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _starTwinkleController.dispose();
    super.dispose();
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated star field background
              AnimatedBuilder(
                animation: _starTwinkleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _AnimatedStarPainter(
                      twinkle: _starTwinkleController.value,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
              // Nebula gradient overlays
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6600FF).withOpacity(0.15),
                        const Color(0xFF6600FF).withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                left: -100,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00F0FF).withOpacity(0.1),
                        const Color(0xFF00F0FF).withOpacity(0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Main content
              Column(
                children: [
                  // Enhanced header with stats
                  _buildEnhancedHeader(),
                  const SizedBox(height: 20),

                  // Feature buttons grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _EnhancedHubButton(
                            icon: '🗺️',
                            title: '关卡选择',
                            subtitle: '81关挑战',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C3FF), Color(0xFF0088FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () =>
                                _navigateTo(context, const LevelSelectScreen()),
                          ),
                          _EnhancedHubButton(
                            icon: '🏆',
                            title: '成就殿堂',
                            subtitle: '查看成就',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFEA00), Color(0xFFFFAA00)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () =>
                                _navigateTo(context, const AchievementScreen()),
                          ),
                          _EnhancedHubButton(
                            icon: '📋',
                            title: '每日任务',
                            subtitle: '领取奖励',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB700FF), Color(0xFF8800FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () =>
                                _navigateTo(context, const DailyTasksScreen()),
                          ),
                          _EnhancedHubButton(
                            icon: '⬆️',
                            title: '角色升级',
                            subtitle: '提升属性',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF00AA), Color(0xFFFF0066)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () => _navigateTo(
                              context,
                              const CharacterUpgradeScreen(),
                            ),
                          ),
                          _EnhancedHubButton(
                            icon: '🃏',
                            title: '卡片升级',
                            subtitle: '收集强化',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6644), Color(0xFFFF3300)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () =>
                                _navigateTo(context, const CardUpgradeScreen()),
                          ),
                          _EnhancedHubButton(
                            icon: '⚙️',
                            title: '设置',
                            subtitle: '系统配置',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF44DDFF), Color(0xFF00AAFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () =>
                                _navigateTo(context, const SettingsScreen()),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom version info with decorative line
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xFF00F0FF).withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '星轨防线 v1.0.0',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF445566),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 14),
          // Player name - large and centered
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00F0FF).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F0FF).withOpacity(0.08),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              widget.playerName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00F0FF),
                letterSpacing: 4,
                shadows: [Shadow(color: Color(0xFF00F0FF), blurRadius: 12)],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 14),
          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: '🔮',
                  value: _energyCrystals.toString(),
                  label: '能量水晶',
                  color: const Color(0xFF00F0FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: '⭐',
                  value: _stars.toString(),
                  label: '星际之星',
                  color: const Color(0xFFFFEA00),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: '🎯',
                  value: '12/50',
                  label: '当前等级',
                  color: const Color(0xFFFF00AA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF667788)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _EnhancedHubButton extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _EnhancedHubButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_EnhancedHubButton> createState() => _EnhancedHubButtonState();
}

class _EnhancedHubButtonState extends State<_EnhancedHubButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        setState(() => _isHovered = true);
      },
      onTapUp: (_) {
        _controller.reverse();
        setState(() => _isHovered = false);
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
        setState(() => _isHovered = false);
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildButtonContent(),
          );
        },
      ),
    );
  }

  Widget _buildButtonContent() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isHovered
              ? const Color(0xFF00F0FF).withOpacity(0.6)
              : const Color(0xFF00F0FF).withOpacity(0.2),
          width: _isHovered ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isHovered
                ? const Color(0xFF00F0FF).withOpacity(0.2)
                : const Color(0xFF00F0FF).withOpacity(0.08),
            blurRadius: _isHovered ? 20 : 12,
            spreadRadius: _isHovered ? 2 : 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient shimmer at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                gradient: widget.gradient.withOpacity(_isHovered ? 0.15 : 0.08),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with glow
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered
                            ? const Color(0xFF00F0FF).withOpacity(0.4)
                            : const Color(0xFF00F0FF).withOpacity(0.15),
                        blurRadius: _isHovered ? 15 : 8,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.icon,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _isHovered ? const Color(0xFF00F0FF) : Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                // Subtitle
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF667788),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== Animated Star Painter =====================

class _AnimatedStarPainter extends CustomPainter {
  final double twinkle;

  _AnimatedStarPainter({required this.twinkle});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = _seededRandom(42);
    final stars = <_Star>[];

    // Generate stars
    for (var i = 0; i < 100; i++) {
      stars.add(
        _Star(
          x: rng.nextDouble() * size.width,
          y: rng.nextDouble() * size.height,
          size: rng.nextDouble() * 1.8 + 0.5,
          opacity: rng.nextDouble(),
          speed: rng.nextDouble() * 0.5 + 0.5,
        ),
      );
    }

    // Draw stars with twinkling effect
    for (var star in stars) {
      final twinkleOpacity =
          0.3 +
          0.7 * (0.5 + 0.5 * math.sin(twinkle * math.pi * 2 * star.speed));
      final alpha = star.opacity * twinkleOpacity;

      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size,
        Paint()
          ..color = const Color(0xFFAABBCC).withOpacity(alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedStarPainter oldDelegate) =>
      oldDelegate.twinkle != twinkle;
}

class _Star {
  final double x, y, size, opacity, speed;
  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
  });
}
