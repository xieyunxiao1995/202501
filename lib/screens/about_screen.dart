import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.systemBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("About", style: TextStyle(fontFamily: 'serif')),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo / Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.1),
                border: Border.all(color: AppColors.accent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, size: 50, color: AppColors.accent),
            ),
            const SizedBox(height: 20),
            const Text(
              "Elemental Memory",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'serif',
              ),
            ),
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 40),
            
            GlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              opacity: 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Description",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Elemental Memory is a roguelike memory card game. Climb the tower, defeat enemies by matching elemental pairs, and synthesize powerful artifacts using ancient alchemy.",
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            GlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              opacity: 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Credits",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCreditRow("Developer", "Flutter Enthusiast"),
                  _buildCreditRow("Design", "AI Assistant"),
                  _buildCreditRow("Engine", "Flutter 3.x"),
                  _buildCreditRow("AI Core", "DeepSeek API"),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              "© 2025 Elemental Tower Studio",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }

  Widget _buildCreditRow(String role, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(role, style: const TextStyle(color: Colors.white54)),
          Text(name, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
