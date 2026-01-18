import 'package:flutter/material.dart';

class ShrineDialog extends StatelessWidget {
  final int playerGold;
  final int playerHp;
  final int playerMaxHp;
  final Function(String) onOptionSelected;

  const ShrineDialog({
    super.key,
    required this.playerGold,
    required this.playerHp,
    required this.playerMaxHp,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1F2937), // gray-800
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "⛩️ 远古祭坛",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "进行献祭或祈愿...",
            style: TextStyle(color: Colors.grey[400]),
          ),
          SizedBox(height: 24),
          
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
          ),
          
          SizedBox(height: 12),
          
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
          ),

          SizedBox(height: 24),
          
          TextButton(
            onPressed: () => onOptionSelected('leave'),
            child: Text("辞别", style: TextStyle(color: Colors.grey)),
          ),
        ],
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
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canAfford ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: canAfford ? color.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(12),
            color: canAfford ? color.withValues(alpha: 0.1) : Colors.black26,
          ),
          child: Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 32)),
              SizedBox(width: 12),
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
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          cost,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: canAfford ? color : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
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
