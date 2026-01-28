import 'package:flutter/material.dart';
import '../models/configs.dart';
import '../data/achievements_data.dart';
import '../utils/achievement_manager.dart';
import '../widgets/background_wrapper.dart';

class AchievementsScreen extends StatelessWidget {
  final VoidCallback onClose;

  const AchievementsScreen({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        title: Text("功业录", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 18 : 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.redAccent, size: isSmallScreen ? 20 : 24),
          onPressed: onClose,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.redAccent.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 12.0 : 24.0,
                isSmallScreen ? 8.0 : 24.0,
                isSmallScreen ? 12.0 : 24.0,
                isSmallScreen ? 4.0 : 16.0,
              ),
              child: Text(
                "记录你在大荒中的点滴成就。每一项成就都是通往强者之路的基石。",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: isSmallScreen ? 12 : 14),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: isSmallScreen ? 12 : 16,
                  right: isSmallScreen ? 12 : 16,
                  bottom: isSmallScreen ? 20 : 32,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  
                  // Calculate progress
                  num progress = 0;
                  switch (achievement.type) {
                    case 'kill':
                      progress = AchievementManager.cumulativeStats['kills'] ?? 0;
                      break;
                    case 'gold':
                      progress = AchievementManager.cumulativeStats['gold'] ?? 0;
                      break;
                    case 'floor':
                      progress = AchievementManager.unlockedIds.contains(achievement.id) 
                          ? achievement.targetValue : 0;
                      break;
                    case 'death':
                      progress = AchievementManager.cumulativeStats['deaths'] ?? 0;
                      break;
                  }

                  final isUnlocked = AchievementManager.unlockedIds.contains(achievement.id);
                  final percent = (progress / achievement.targetValue).toDouble().clamp(0.0, 1.0);

                  return _buildAchievementCard(achievement, progress, isUnlocked, percent, isSmallScreen);
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, dynamic progress, bool isUnlocked, double percent, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.redAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white10,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 44 : 56,
            height: isSmallScreen ? 44 : 56,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.redAccent.withValues(alpha: 0.2) : Colors.black26,
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(achievement.icon, style: TextStyle(fontSize: isSmallScreen ? 24 : 32, color: isUnlocked ? null : Colors.white.withValues(alpha: 0.2)))),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(achievement.name, style: TextStyle(color: isUnlocked ? Colors.redAccent : Colors.white, fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
                    if (isUnlocked)
                      Text("已达成", style: TextStyle(color: Colors.redAccent, fontSize: isSmallScreen ? 10 : 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(achievement.desc, style: TextStyle(color: Colors.white60, fontSize: isSmallScreen ? 11 : 13)),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percent,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: isUnlocked ? Colors.redAccent : Colors.white30,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text("$progress / ${achievement.targetValue}", style: TextStyle(color: Colors.white38, fontSize: isSmallScreen ? 10 : 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
