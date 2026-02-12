import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 380;
    
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('关于我们', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: isSmallScreen ? 24 : 28)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          children: [
            SizedBox(height: isSmallScreen ? 24 : 40),
            Container(
              width: isSmallScreen ? 100 : 120,
              height: isSmallScreen ? 100 : 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inkBlack, width: 3),
                color: AppColors.bgPaper,
              ),
              child: Center(
                child: Icon(Icons.brush, size: isSmallScreen ? 48 : 60, color: AppColors.inkBlack),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Text(
              '山海墨世',
              style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 28 : 36, fontWeight: FontWeight.bold),
            ),
            Text(
              '版本 1.0.0',
              style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 14 : 16, color: Colors.grey),
            ),
            SizedBox(height: isSmallScreen ? 32 : 48),
            _buildSection(
              '墨世起源',
              '《山海墨世》是一款以中国上古神话《山海经》为背景的卡牌构筑类roguelike游戏。在这个水墨风格的世界中，玩家将扮演一位踏入山海世界的旅者，收集失落的“灵言”卡牌，组合强大的“肢体”部件，探索神秘的“经书”地图，挑战传说中的异兽。',
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              '开发团队',
              '我们是一群热爱中国传统文化与独立游戏的开发者。致力于将古老的神话传说以全新的互动形式呈现给现代玩家，让更多人领略到《山海经》的奇幻魅力与水墨艺术的独特韵味。',
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              '联系我们',
              '官方邮箱: contact@shanhaiink.com\n官方网站: www.shanhaiink.com',
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 32 : 48),
            Text(
              'Copyright © 2026 Shanhai Ink Studio. All Rights Reserved.',
              style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 20 : 24, color: AppColors.inkRed),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EFE6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.woodDark.withOpacity(0.2)),
          ),
          child: Text(
            content,
            style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 14 : 16, height: 1.6, color: AppColors.inkBlack),
          ),
        ),
      ],
    );
  }
}
