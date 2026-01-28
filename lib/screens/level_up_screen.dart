import 'package:flutter/material.dart';
import '../models/configs.dart';
import '../constants.dart';
import '../widgets/background_wrapper.dart';

class LevelUpScreen extends StatelessWidget {
  final List<Perk> options;
  final Function(Perk) onSelect;

  const LevelUpScreen({
    super.key,
    required this.options,
    required this.onSelect,
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
            center: const Alignment(0, -0.2),
            radius: 1.5,
            colors: [Colors.cyan.withValues(alpha: 0.1), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "✨",
                  style: TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 16),
                const Text(
                  "修为突破！",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "悟得大道，请选择一个命格天赋",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 48),
                ...options.map((perk) => _buildPerkOption(context, perk, isSmallScreen)),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildPerkOption(BuildContext context, Perk perk, bool isSmallScreen) {
    Color rarityColor = rarityColors[perk.rarity] ?? Colors.white;

    return GestureDetector(
      onTap: () => onSelect(perk),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: rarityColor.withValues(alpha: 0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: rarityColor.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(perk.icon, style: TextStyle(fontSize: isSmallScreen ? 32 : 40)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perk.name,
                    style: TextStyle(
                      color: rarityColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    perk.desc,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 13 : 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: rarityColor.withValues(alpha: 0.5), size: 16),
          ],
        ),
      ),
    );
  }
}
