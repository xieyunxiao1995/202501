import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';

class GameOverScreen extends StatelessWidget {
  final int floor;
  final int score;
  final VoidCallback onRestart;

  const GameOverScreen({
    super.key,
    required this.floor,
    required this.score,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg1.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              const Color(0xFF3B0A0A).withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Icon/Title Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  "💀",
                  style: TextStyle(fontSize: isSmallScreen ? 60 : 80),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "渡劫失败",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: isSmallScreen ? 32 : 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  shadows: [
                    Shadow(
                      color: Colors.red,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "道友，此次修行缘尽于此...",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              const Spacer(),
              
              // Stats Section
              Container(
                width: size.width * 0.8,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    _buildStatRow("修行深度", "第 $floor 层", Colors.white),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white10),
                    ),
                    _buildStatRow("大荒气运", "$score", Colors.amber),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Action Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 50 : 60,
                  child: ElevatedButton(
                    onPressed: onRestart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      shadowColor: Colors.red.withValues(alpha: 0.5),
                    ),
                    child: Text(
                      "重回大荒",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
