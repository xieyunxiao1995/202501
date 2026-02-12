import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../../services/game_service.dart';

class SplashScreen extends StatefulWidget {
  final GameService gameService;
  final VoidCallback onFinished;

  const SplashScreen({
    super.key,
    required this.gameService,
    required this.onFinished,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _checkReady();
  }

  Future<void> _checkReady() async {
    // Ensure animation plays for at least 2.5 seconds for branding
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2500)),
      // Wait for game service to finish loading
      _waitForGameService(),
    ]);

    if (mounted) {
      widget.onFinished();
    }
  }

  Future<void> _waitForGameService() async {
    while (widget.gameService.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/bg/A_circular_fantasy_floating_island.jpeg',
            fit: BoxFit.cover,
          ),
          // Overlay
          Container(
            color: AppColors.bgPaper.withOpacity(0.9),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Icon
                      Container(
                        width: isSmallScreen ? 100 : 120,
                        height: isSmallScreen ? 100 : 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.inkBlack, width: 4),
                        ),
                        child: Center(
                          child: Icon(Icons.brush, size: isSmallScreen ? 50 : 60, color: AppColors.inkBlack),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Title
                      Text(
                        '山海墨世',
                        style: GoogleFonts.maShanZheng(
                          fontSize: isSmallScreen ? 48 : 56,
                          color: AppColors.inkBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      Text(
                        'SHANHAI INK',
                        style: GoogleFonts.notoSerifSc(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: AppColors.inkBlack.withOpacity(0.6),
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // World Background Text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 32 : 48),
                        child: Text(
                          '上古之时，山海经卷散落人间，\n墨气浸染万物，异兽横行。\n\n你将化身旅者，踏入这片水墨幻境，\n寻灵言，铸神躯，\n于混沌中重绘山海秩序。',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSerifSc(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: AppColors.inkBlack.withOpacity(0.8),
                            height: 1.8,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Loading Indicator (subtle)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.inkBlack.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
