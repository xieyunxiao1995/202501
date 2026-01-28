import 'package:flutter/material.dart';
import '../data/campaign_data.dart';
import '../models/enums.dart';
import '../widgets/background_wrapper.dart';

class LevelDetailScreen extends StatelessWidget {
  final CampaignLevel level;
  final int stars;
  final Function(int levelId) onLevelSelect;

  const LevelDetailScreen({
    super.key,
    required this.level,
    required this.stars,
    required this.onLevelSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
        children: [
          // Background decoration (optional)
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Center(
                child: Text(level.icon, style: const TextStyle(fontSize: 200)),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header: Icon + Name + Biome
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  level.icon,
                                  style: const TextStyle(fontSize: 36),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  Text(
                                    "地貌：${_getBiomeName(level.biome)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      _buildStar(stars >= 1, size: 20),
                                      const SizedBox(width: 4),
                                      _buildStar(stars >= 2, size: 20),
                                      const SizedBox(width: 4),
                                      _buildStar(stars >= 3, size: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactStatTile(
                                "最大层数",
                                "${level.maxFloors}层",
                                Icons.layers,
                                Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactStatTile(
                                "解锁要求",
                                "${level.requiredScore} 气运",
                                Icons.lock_open,
                                Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "关卡简介",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                level.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rewards
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.redeem,
                                      color: Colors.greenAccent,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "修行奖励",
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: level.rewards.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 6.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.greenAccent,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              level.rewards[index],
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Start Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onLevelSelect(level.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              "开启修行",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildStar(bool filled, {double size = 24}) {
    return Icon(
      filled ? Icons.star : Icons.star_border,
      color: filled ? Colors.amber : Colors.grey[700],
      size: size,
    );
  }

  Widget _buildCompactStatTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color.withValues(alpha: 0.7), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBiomeName(Biome biome) {
    switch (biome) {
      case Biome.forest:
        return "苍翠森林";
      case Biome.volcano:
        return "熔岩火山";
      case Biome.ocean:
        return "无尽汪洋";
      case Biome.void_:
        return "幽冥虚空";
    }
  }
}
