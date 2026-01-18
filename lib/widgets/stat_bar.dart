import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../data/souls_data.dart';
import 'animated_counter.dart';

class StatBar extends StatelessWidget {
  final PlayerStats player;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onOpenCompendium;
  final VoidCallback? onOpenCultivation;

  const StatBar({
    super.key,
    required this.player,
    this.onOpenSettings,
    this.onOpenCompendium,
    this.onOpenCultivation,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 4 : 8,
        horizontal: 12,
      ),
      color: Colors.black87,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Row 1: Floor, Level, HP, Shield, Buttons
            Row(
              children: [
                _buildStatItem(
                  isSmallScreen ? "层" : "修行",
                  player.floor,
                  Colors.white,
                  suffix: isSmallScreen ? "" : " 层",
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(width: isSmallScreen ? 8 : 16),
                _buildStatItem(
                  isSmallScreen ? "阶" : "境界",
                  player.level,
                  Colors.purpleAccent,
                  isSmallScreen: isSmallScreen,
                ),
                if (player.combo > 1) ...[
                  SizedBox(width: isSmallScreen ? 8 : 16),
                  _buildStatItem("🔥", player.combo, Colors.orangeAccent, isSmallScreen: isSmallScreen),
                ],
                const Spacer(),
                _buildStatItem("🩸", player.hp, Colors.red, suffix: "/${player.maxHp}", isSmallScreen: isSmallScreen),
                if (player.shield > 0) ...[
                  SizedBox(width: 8),
                  _buildStatItem("🛡️", player.shield, Colors.blue, isSmallScreen: isSmallScreen),
                ],
                SizedBox(width: 8),
                if (onOpenCompendium != null)
                  InkWell(
                    onTap: onOpenCompendium,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.menu_book, color: Colors.amber, size: isSmallScreen ? 18 : 20),
                    ),
                  ),
                if (onOpenCultivation != null)
                  InkWell(
                    onTap: onOpenCultivation,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.self_improvement, color: Colors.cyanAccent, size: isSmallScreen ? 18 : 20),
                    ),
                  ),
                if (onOpenSettings != null)
                  InkWell(
                    onTap: onOpenSettings,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.settings, color: Colors.white54, size: isSmallScreen ? 18 : 20),
                    ),
                  ),
              ],
            ),
            if (!isSmallScreen) SizedBox(height: 8),
            // Row 2: Power, Gold, XP Bar, Keys, Skill
            Row(
              children: [
                _buildStatItem("⚔️", player.power, Colors.orange, isSmallScreen: isSmallScreen),
                SizedBox(width: isSmallScreen ? 8 : 12),
                _buildStatItem("✨", player.gold, Colors.yellow, isSmallScreen: isSmallScreen),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isSmallScreen)
                        Text("灵力", style: TextStyle(color: Colors.cyan, fontSize: 10, fontWeight: FontWeight.bold)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: player.maxXp > 0 ? player.xp / player.maxXp : 0,
                          backgroundColor: Colors.grey[800],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                          minHeight: isSmallScreen ? 4 : 6,
                        ),
                      ),
                    ],
                  ),
                ),
                if (player.keys > 0) ...[
                  SizedBox(width: 8),
                  _buildStatItem("🗝️", player.keys, Colors.amber, isSmallScreen: isSmallScreen),
                ],
                SizedBox(width: 8),
                Text(
                  player.skillCharge >= 100 ? "神通!" : "${player.skillCharge}%",
                  style: TextStyle(
                    color: player.skillCharge >= 100 ? Colors.purpleAccent : Colors.white54,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (player.equippedSoulId != null || player.poison > 0 || player.weak > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    if (player.equippedSoulId != null)
                      _buildSoulDisplay(player.equippedSoulId!, isSmallScreen),
                    if (player.poison > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text("☠️${player.poison}", style: TextStyle(color: Colors.green, fontSize: isSmallScreen ? 10 : 12)),
                      ),
                    if (player.weak > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text("📉${player.weak}", style: TextStyle(color: Colors.grey, fontSize: isSmallScreen ? 10 : 12)),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String icon, int value, Color color, {String suffix = "", String? label, bool isSmallScreen = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
        if (label != null && !isSmallScreen) ...[
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
        const SizedBox(width: 2),
        AnimatedCounter(
          value: value,
          suffix: suffix,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 13 : 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSoulDisplay(String soulId, bool isSmallScreen) {
    final soul = allSouls.firstWhere((s) => s.id == soulId, orElse: () => allSouls[0]);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(soul.icon, style: TextStyle(fontSize: isSmallScreen ? 10 : 12)),
          const SizedBox(width: 4),
          Text(soul.name, style: TextStyle(color: Colors.purpleAccent, fontSize: isSmallScreen ? 8 : 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
