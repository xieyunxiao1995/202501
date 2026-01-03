import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class StatisticsScreen extends StatelessWidget {
  final PlayerStats stats;

  const StatisticsScreen({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.systemBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Statistics", style: TextStyle(fontFamily: 'serif')),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
          children: [
            _buildStatCard("Enemies Defeated", stats.enemiesDefeated.toString(), Icons.close),
            _buildStatCard("Items Crafted", stats.itemsCrafted.toString(), Icons.science),
            _buildStatCard("Highest Floor", stats.currentFloor.toString(), Icons.flag), // Assuming current is max for now
            _buildStatCard("Total Deaths", stats.deaths.toString(), Icons.dangerous),
            _buildStatCard("Total Gold", stats.gold.toString(), Icons.monetization_on),
          ],
        ),
      ),
    ),
  ),
);
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      opacity: 0.1,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
