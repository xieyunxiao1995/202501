import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';

class AboutUsScreen extends StatelessWidget {
  final VoidCallback onClose;

  const AboutUsScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: isSmallScreen ? 20 : 24),
          onPressed: onClose,
        ),
        title: Text(
          "关于我们",
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: isSmallScreen ? 100 : 120,
                height: isSmallScreen ? 100 : 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.3),
                      blurRadius: isSmallScreen ? 15 : 20,
                      spreadRadius: isSmallScreen ? 3 : 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "🌟",
                    style: TextStyle(fontSize: isSmallScreen ? 52 : 64),
                  ),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Center(
              child: Text(
                "山海地牢",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: isSmallScreen ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Shanhai Dungen",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: isSmallScreen ? 14 : 16,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 3 : 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                ),
                child: Text(
                  "版本 1.9.2",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            _buildSection(
              "开发团队",
              "Indie Flutter Studio",
              Icons.code,
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "技术栈",
              "Flutter 3.x\nDart 3.x\nMaterial Design 3",
              Icons.build,
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "致谢",
              "设计: AI & Human Co-Pilot\n"
                  "代码: Dart & Flutter Community\n"
                  "素材: Open Source Assets",
              Icons.favorite,
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "联系方式",
              "邮箱: contact@shanhaigames.com\n"
                  "官网: www.shanhaigames.com",
              Icons.email,
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Text(
                    "版权声明",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: isSmallScreen ? 15 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "© 2026 Shanhai Games.\n保留所有权利。",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 13 : 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
          ],
        ),
      ),
    ));
  }

  Widget _buildSection(String title, String content, IconData icon, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber, size: isSmallScreen ? 18 : 20),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 13 : 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
