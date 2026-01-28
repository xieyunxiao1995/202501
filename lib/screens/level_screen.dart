import 'package:flutter/material.dart';
import '../data/campaign_data.dart';
import 'help_screen.dart';
import 'level_detail_screen.dart';
import 'level_locked_screen.dart';
import '../widgets/background_wrapper.dart';

class LevelScreen extends StatelessWidget {
  final int highScore;
  final Map<int, int> levelStars;
  final Function(int levelId) onLevelSelect;
  final VoidCallback onClose;

  const LevelScreen({
    super.key,
    required this.highScore,
    required this.levelStars,
    required this.onLevelSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Stack(
        children: [
          Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "山海秘境",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.amber,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                        Shadow(
                          blurRadius: 5,
                          color: Colors.amber,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "选择你的修行之路",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white24,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildScoreBoard(),

                  const SizedBox(height: 32),

                  ...campaignLevels.map((level) {
                    final isUnlocked = highScore >= level.requiredScore;
                    final stars = levelStars[level.id] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildLevelCard(
                        context,
                        level,
                        isUnlocked,
                        stars,
                      ),
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),

        // Back Button (Top Left)
        Positioned(
          top: 16,
          left: 16,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.white.withValues(alpha: 0.2),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white70,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Help Button (Top Right)
        Positioned(
          top: 16,
          right: 16,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HelpScreen(
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.white.withValues(alpha: 0.2),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: Colors.white70,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black54, // Darker background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScoreItem("当前气运", highScore.toString(), Colors.amber),
          Container(
            width: 1,
            height: 24,
            color: Colors.white10,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          _buildScoreItem("解锁关卡", "${_getUnlockedCount()}/8", Colors.green),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  int _getUnlockedCount() {
    return campaignLevels.where((level) => highScore >= level.requiredScore).length;
  }

  Widget _buildLevelCard(
    BuildContext context,
    CampaignLevel level,
    bool isUnlocked,
    int stars,
  ) {
    Color borderColor = Colors.white24;
    Color bgColor = Colors.black54;

    if (isUnlocked) {
      borderColor = Colors.amber.withValues(alpha: 0.8);
      bgColor = Colors.black87;
    } else {
      borderColor = Colors.red.withValues(alpha: 0.5);
    }

    return GestureDetector(
      onTap: isUnlocked
          ? () => _showLevelDetail(context, level, stars)
          : () => _showLockedDialog(context, level),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Colors.amber.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isUnlocked ? Colors.amber : Colors.red.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  isUnlocked ? level.icon : "🔒",
                  style: const TextStyle(fontSize: 32),
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
                    style: TextStyle(
                      color: isUnlocked ? Colors.white : Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level.description,
                    style: TextStyle(
                      color: isUnlocked ? Colors.white60 : Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStar(stars >= 1),
                      const SizedBox(width: 4),
                      _buildStar(stars >= 2),
                      const SizedBox(width: 4),
                      _buildStar(stars >= 3),
                      const SizedBox(width: 8),
                      Text(
                        "${level.maxFloors}层",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isUnlocked ? Colors.amber : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(bool filled) {
    return Icon(
      filled ? Icons.star : Icons.star_border,
      color: filled ? Colors.amber : Colors.grey[600],
      size: 16,
    );
  }

  void _showLevelDetail(BuildContext context, CampaignLevel level, int stars) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LevelDetailScreen(
          level: level,
          stars: stars,
          onLevelSelect: onLevelSelect,
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context, CampaignLevel level) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LevelLockedScreen(
          level: level,
          highScore: highScore,
        ),
      ),
    );
  }
}
