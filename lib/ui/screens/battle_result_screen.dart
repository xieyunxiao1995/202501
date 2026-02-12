
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../../services/game_service.dart';
import '../../models/item.dart';

class BattleResultScreen extends StatelessWidget {
  final bool isVictory;
  final GameService gameService;
  final int inkReward;
  final int xpReward;
  final bool leveledUp;
  final int sanityCost;
  final Item? droppedItem;

  const BattleResultScreen({
    super.key,
    required this.isVictory,
    required this.gameService,
    this.inkReward = 0,
    this.xpReward = 0,
    this.leveledUp = false,
    this.sanityCost = 0,
    this.droppedItem,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isVictory ? '大捷' : '败北',
              style: GoogleFonts.maShanZheng(
                fontSize: isSmallScreen ? 80 : 100,
                color: isVictory ? AppColors.inkRed : Colors.grey,
                shadows: [
                  BoxShadow(
                    color: (isVictory ? AppColors.inkRed : Colors.white).withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
              ),
            ).animate()
             .fadeIn(duration: 600.ms)
             .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), curve: Curves.easeOutBack),
             
            SizedBox(height: isSmallScreen ? 40 : 60),
            
            if (isVictory) ...[
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.inkRed.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 5)
                  ]
                ),
                child: Icon(Icons.water_drop, color: Colors.white, size: isSmallScreen ? 32 : 40)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1500.ms),
              ),
              SizedBox(height: isSmallScreen ? 8 : 10),
              Text(
                '获得墨韵: $inkReward',
                style: GoogleFonts.notoSerifSc(color: Colors.white, fontSize: isSmallScreen ? 20 : 24),
              ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0),
              
              if (xpReward > 0) ...[
                SizedBox(height: isSmallScreen ? 8 : 10),
                Text(
                  '获得修为: $xpReward',
                  style: GoogleFonts.notoSerifSc(color: Colors.amber, fontSize: isSmallScreen ? 16 : 20),
                ).animate().fadeIn(delay: 700.ms).moveY(begin: 20, end: 0),
              ],
              
              if (droppedItem != null) ...[
                SizedBox(height: isSmallScreen ? 8 : 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.purpleAccent, size: isSmallScreen ? 20 : 24),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Text(
                      '获得物品: ${droppedItem!.name}',
                      style: GoogleFonts.notoSerifSc(color: Colors.purpleAccent, fontSize: isSmallScreen ? 16 : 20),
                    ),
                  ],
                ).animate().fadeIn(delay: 900.ms).moveY(begin: 20, end: 0),
              ],
              
              if (leveledUp) ...[
                SizedBox(height: isSmallScreen ? 16 : 20),
                Text(
                  '境界突破！',
                  style: GoogleFonts.maShanZheng(color: Colors.amberAccent, fontSize: isSmallScreen ? 28 : 36, fontWeight: FontWeight.bold),
                ).animate()
                 .fadeIn(delay: 1000.ms)
                 .scale(begin: const Offset(2, 2), end: const Offset(1, 1), duration: 500.ms, curve: Curves.bounceOut)
                 .shimmer(duration: 2000.ms, color: Colors.white),
                Text(
                  '全属性提升，状态恢复',
                  style: GoogleFonts.notoSerifSc(color: Colors.white70, fontSize: isSmallScreen ? 14 : 16),
                ).animate().fadeIn(delay: 1500.ms),
              ],

              SizedBox(height: isSmallScreen ? 8 : 10),
              Text(
                '吞噬部分残魂...',
                style: GoogleFonts.notoSerifSc(color: Colors.grey, fontSize: isSmallScreen ? 14 : 16),
              ).animate().fadeIn(delay: 800.ms),
            ] else ...[
              Icon(Icons.broken_image, color: Colors.grey, size: isSmallScreen ? 40 : 50)
                  .animate().shake(duration: 500.ms),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                '理智受损: -$sanityCost',
                style: GoogleFonts.notoSerifSc(color: AppColors.inkRed, fontSize: isSmallScreen ? 20 : 24),
              ).animate().fadeIn(delay: 500.ms),
              
              SizedBox(height: isSmallScreen ? 8 : 10),
              Text(
                '仓皇逃离...',
                style: GoogleFonts.notoSerifSc(color: Colors.grey, fontSize: isSmallScreen ? 14 : 16),
              ).animate().fadeIn(delay: 800.ms),
            ],
            
            SizedBox(height: isSmallScreen ? 60 : 100),
            
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Return to Map
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 40 : 50, vertical: isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '返回',
                  style: GoogleFonts.notoSerifSc(color: Colors.white, fontSize: isSmallScreen ? 16 : 20, letterSpacing: 4),
                ),
              ),
            ).animate().fadeIn(delay: 1500.ms),
          ],
        ),
      ),
    );
  }
}
