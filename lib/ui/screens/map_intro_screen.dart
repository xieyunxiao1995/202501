import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/map_config.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import 'map_screen.dart';

class MapIntroScreen extends StatefulWidget {
  final GameService gameService;
  final MapConfig mapConfig;

  const MapIntroScreen({
    super.key,
    required this.gameService,
    required this.mapConfig,
  });

  @override
  State<MapIntroScreen> createState() => _MapIntroScreenState();
}

class _MapIntroScreenState extends State<MapIntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _showButton = false;
  
  // Typewriter state
  String _displayedText = '';
  late Timer _timer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    
    // Start typewriter effect
    _startTypewriter();
  }

  void _startTypewriter() {
    const duration = Duration(milliseconds: 100);
    _timer = Timer.periodic(duration, (timer) {
      if (_charIndex < widget.mapConfig.description.length) {
        setState(() {
          _charIndex++;
          _displayedText = widget.mapConfig.description.substring(0, _charIndex);
        });
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _showButton = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 380;

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      body: Stack(
        children: [
          // Background Texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/paper-fibers.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: AppColors.bgPaper),
              ),
            ),
          ),
          
          // Large Watermark Character
          Positioned(
            right: -50,
            bottom: 100,
            child: Opacity(
              opacity: 0.05,
              child: Text(
                widget.mapConfig.name.substring(0, 1),
                style: GoogleFonts.maShanZheng(
                  fontSize: isSmallScreen ? 300 : 400,
                  color: widget.mapConfig.themeColor,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(flex: 1),
                  
                  // Map Title with Animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '即将前往',
                          style: GoogleFonts.notoSerifSc(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: AppColors.inkBlack.withOpacity(0.6),
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.mapConfig.name,
                          style: GoogleFonts.maShanZheng(
                            fontSize: isSmallScreen ? 48 : 64,
                            color: widget.mapConfig.themeColor,
                            height: 1.1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 16 : 24),
                          height: 2,
                          width: 100,
                          color: AppColors.inkBlack,
                        ),
                      ],
                    ),
                  ),

                  // Story Text (Typewriter effect)
                  SizedBox(
                    height: isSmallScreen ? 160 : 200,
                    child: Text(
                      _displayedText + (_charIndex < widget.mapConfig.description.length ? '｜' : ''),
                      style: GoogleFonts.notoSerifSc(
                        fontSize: isSmallScreen ? 16 : 20,
                        color: AppColors.inkBlack,
                        height: 1.8,
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Action Button
                  AnimatedOpacity(
                    opacity: _showButton ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MapScreen(
                                gameService: widget.gameService,
                                mapConfig: widget.mapConfig,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 32 : 48, vertical: isSmallScreen ? 12 : 16),
                          decoration: BoxDecoration(
                            color: widget.mapConfig.themeColor,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: widget.mapConfig.themeColor.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            '开启征程',
                            style: GoogleFonts.maShanZheng(
                              fontSize: isSmallScreen ? 20 : 24,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
