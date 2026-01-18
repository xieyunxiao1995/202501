import 'package:flutter/material.dart';

class ShrineScreen extends StatelessWidget {
  final int playerGold;
  final int playerHp;
  final int playerMaxHp;
  final Function(String) onOptionSelected;

  const ShrineScreen({
    super.key,
    required this.playerGold,
    required this.playerHp,
    required this.playerMaxHp,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: const Text(
          "远古祭坛",
          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.purpleAccent),
          onPressed: () => onOptionSelected('leave'),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.5,
            colors: [Colors.purple.withOpacity(0.1), const Color(0xFF111827)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "⛩️",
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              Text(
                "进行献祭或祈愿...",
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
              const SizedBox(height: 48),
              
              // Option 1: Pray (Gold)
              _buildOption(
                context,
                icon: "🙏",
                title: "祈愿",
                cost: "50 灵石",
                desc: "70% 几率获得天赐仙缘\n(愈合伤势或增强灵力)",
                canAfford: playerGold >= 50,
                onTap: () => onOptionSelected('pray'),
                color: Colors.amber,
                isSmallScreen: isSmallScreen,
              ),
              
              const SizedBox(height: 20),
              
              // Option 2: Sacrifice (HP)
              _buildOption(
                context,
                icon: "🩸",
                title: "血祭",
                cost: "25% 精血",
                desc: "必得稀有大荒奖励\n(奇珍 / 命格 / 灵石)",
                canAfford: playerHp > (playerMaxHp * 0.25).ceil(),
                onTap: () => onOptionSelected('sacrifice'),
                color: Colors.redAccent,
                isSmallScreen: isSmallScreen,
              ),

              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => onOptionSelected('leave'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "辞别祭坛",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String icon,
    required String title,
    required String cost,
    required String desc,
    required bool canAfford,
    required VoidCallback onTap,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canAfford ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: canAfford ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
            color: canAfford ? color.withOpacity(0.05) : Colors.black26,
          ),
          child: Row(
            children: [
              Text(icon, style: TextStyle(fontSize: isSmallScreen ? 40 : 48)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: canAfford ? Colors.white : Colors.grey,
                            fontSize: isSmallScreen ? 18 : 20,
                          ),
                        ),
                        Text(
                          cost,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: canAfford ? color : Colors.grey,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: Colors.grey[400],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
