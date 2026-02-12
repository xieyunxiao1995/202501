import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/map_config.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import 'map_intro_screen.dart';

class MapSelectionScreen extends StatelessWidget {
  final GameService gameService;

  const MapSelectionScreen({super.key, required this.gameService});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '选择征途',
          style: GoogleFonts.maShanZheng(
            color: AppColors.inkBlack,
            fontSize: isSmallScreen ? 26 : 32,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.inkBlack),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg/A_circular_fantasy_floating_island.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay for readability
          Positioned.fill(
            child: Container(color: AppColors.bgPaper.withOpacity(0.85)),
          ),
          // Content
          SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              itemCount: GameMaps.all.length,
              itemBuilder: (context, index) {
                final map = GameMaps.all[index];
                return _buildMapCard(context, map, isSmallScreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(
    BuildContext context,
    MapConfig map,
    bool isSmallScreen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MapIntroScreen(gameService: gameService, mapConfig: map),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        height: isSmallScreen ? 160 : 180,
        decoration: BoxDecoration(
          color: const Color(0xFFF3EFE6),
          border: Border.all(color: map.themeColor, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Watermark
            Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.1,
                child: Text(
                  map.name.substring(0, 1),
                  style: GoogleFonts.maShanZheng(
                    fontSize: isSmallScreen ? 140 : 180,
                    color: map.themeColor,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        map.name,
                        style: GoogleFonts.maShanZheng(
                          fontSize: isSmallScreen ? 26 : 32,
                          color: AppColors.inkBlack,
                        ),
                      ),
                      _buildDifficulty(map.difficulty),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, width: 60, color: map.themeColor),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      map.description,
                      style: GoogleFonts.notoSerifSc(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: AppColors.inkBlack.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '点击出征 >>',
                        style: GoogleFonts.notoSerifSc(
                          fontSize: 14,
                          color: AppColors.inkRed,
                          fontWeight: FontWeight.bold,
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

  Widget _buildDifficulty(int level) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < level ? Icons.star : Icons.star_border,
          color: AppColors.inkRed,
          size: 16,
        );
      }),
    );
  }
}
