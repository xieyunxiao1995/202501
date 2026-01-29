import 'package:flutter/material.dart';
import '../models/configs.dart';
import '../widgets/background_wrapper.dart';
import '../constants.dart';

class MainMenu extends StatelessWidget {
  final int highScore;
  final int totalGold;
  final Function(String) onClassSelect;
  final VoidCallback onOpenStore;
  final VoidCallback onOpenAchievements;
  final VoidCallback onOpenCompendium;
  final VoidCallback onOpenAlchemy;
  final VoidCallback onOpenDailyLogin;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenLevelSelect;
  final VoidCallback onOpenCultivation;
  final VoidCallback onOpenTaskReward;

  final bool hasSave;
  final VoidCallback onContinue;

  const MainMenu({
    super.key,
    required this.highScore,
    required this.totalGold,
    required this.onClassSelect,
    required this.onOpenStore,
    required this.onOpenAchievements,
    required this.onOpenCompendium,
    required this.onOpenAlchemy,
    required this.onOpenDailyLogin,
    required this.onOpenSettings,
    required this.onOpenLevelSelect,
    required this.onOpenCultivation,
    required this.onOpenTaskReward,
    this.hasSave = false,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: isSmallScreen ? 20.0 : 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "少年名将",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 36 : 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.redAccent,
                        letterSpacing: isSmallScreen ? 4 : 8,
                        shadows: const [
                          Shadow(
                            blurRadius: 15,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                          Shadow(
                            blurRadius: 5,
                            color: Colors.red,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "山 海 奇 谭",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white24,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 32),

                    _buildScoreBoard(isSmallScreen),

                    SizedBox(height: isSmallScreen ? 16 : 32),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildSmallMenuButton(
                          onPressed: onOpenLevelSelect,
                          icon: Icons.map_rounded,
                          label: "秘境",
                          color: Colors.cyanAccent,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildSmallMenuButton(
                          onPressed: onOpenStore,
                          icon: Icons.auto_awesome_motion_rounded,
                          label: "万宝阁",
                          color: Colors.amber,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildSmallMenuButton(
                          onPressed: onOpenCompendium,
                          icon: Icons.menu_book_rounded,
                          label: "图鉴",
                          color: Colors.lightBlueAccent,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildSmallMenuButton(
                          onPressed: onOpenAchievements,
                          icon: Icons.emoji_events_rounded,
                          label: "功业录",
                          color: Colors.redAccent,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildSmallMenuButton(
                          onPressed: onOpenAlchemy,
                          icon: Icons.science_rounded,
                          label: "炼丹",
                          color: Colors.greenAccent,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildSmallMenuButton(
                          onPressed: onOpenCultivation,
                          icon: Icons.self_improvement,
                          label: "修行",
                          color: Colors.cyanAccent,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildSmallMenuButton(
                          onPressed: onOpenDailyLogin,
                          icon: Icons.calendar_today_rounded,
                          label: "七日礼",
                          color: Colors.purpleAccent,
                          isSmallScreen: isSmallScreen,
                        ),
                        _buildSmallMenuButton(
                          onPressed: onOpenTaskReward,
                          icon: Icons.task_alt,
                          label: "限时活动",
                          color: Colors.orangeAccent,
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 48),
                    const Text(
                      "—— 选择你的传承 ——",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 24),

                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: classes
                          .map(
                            (cls) =>
                                _buildClassCard(context, cls, isSmallScreen),
                          )
                          .toList(),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 40),
                  ],
                ),
              ),
            ),
          ),

          // Settings Button (Top Right)
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onOpenSettings,
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  child: Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white70,
                      size: 24,
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

  Widget _buildScoreBoard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 24,
        vertical: isSmallScreen ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black54, // Darker background for visibility
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
          width: 1.5,
        ), // Colored border
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
          _buildScoreItem(
            "最高气运",
            highScore.toString(),
            Colors.amber,
            isSmallScreen,
          ),
          Container(
            width: 1,
            height: isSmallScreen ? 16 : 24,
            color: Colors.white10,
            margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 20),
          ),
          _buildScoreItem(
            "灵石总量",
            totalGold.toString(),
            Colors.yellowAccent,
            isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(
    String label,
    String value,
    Color color,
    bool isSmallScreen,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: isSmallScreen ? 10 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildSmallMenuButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool showBadge = false,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: isSmallScreen ? 85 : 100,
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.black87, // Darker background for better contrast
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color,
                width: 2,
              ), // Thicker colored border
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: isSmallScreen ? 24 : 28,
                ), // Slightly larger icon
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: isSmallScreen ? 12 : 13,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showBadge)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    ClassConfig cls,
    bool isSmallScreen,
  ) {
    bool isLocked = false;
    String lockReason = "";

    if (cls.id == 'paladin' && highScore < 500) {
      isLocked = true;
      lockReason = "500气运解锁";
    } else if (cls.id == 'rogue' && highScore < 1000) {
      isLocked = true;
      lockReason = "1000气运解锁";
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked ? null : () => onClassSelect(cls.id),
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Container(
            width: isSmallScreen ? 140 : 160,
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: isLocked ? Colors.black54 : Colors.black87,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLocked
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.white24,
                width: 2,
              ),
              boxShadow: [
                if (!isLocked)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  isLocked ? "🔒" : cls.icon,
                  style: TextStyle(fontSize: isSmallScreen ? 32 : 40),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Text(
                  cls.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                ),
                const SizedBox(height: 6),
                if (isLocked)
                  Text(
                    lockReason,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  Text(
                    cls.desc,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                if (!isLocked) ...[
                  _buildStatRow("初始精血", cls.hp.toString(), Colors.red),
                  _buildStatRow("初始战力", cls.power.toString(), Colors.orange),
                  if (cls.shield > 0)
                    _buildStatRow("护身罡气", cls.shield.toString(), Colors.blue),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
