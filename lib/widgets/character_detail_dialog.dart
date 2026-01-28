import 'package:flutter/material.dart';
import '../models/enums.dart';

class CharacterDetailDialog extends StatelessWidget {
  final String name;
  final String imagePath;
  final GameElement element;
  final Rarity rarity;
  final int stars;
  final bool isBoss;

  const CharacterDetailDialog({
    super.key,
    required this.name,
    required this.imagePath,
    required this.element,
    required this.rarity,
    required this.stars,
    this.isBoss = false,
  });

  Color _getElementColor() {
    switch (element) {
      case GameElement.fire:
        return Colors.red;
      case GameElement.water:
        return Colors.blue;
      case GameElement.wood:
        return Colors.green;
      case GameElement.metal:
        return Colors.amber;
      case GameElement.earth:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _getElementName() {
    switch (element) {
      case GameElement.fire:
        return "火";
      case GameElement.water:
        return "水";
      case GameElement.wood:
        return "木";
      case GameElement.metal:
        return "金";
      case GameElement.earth:
        return "土";
      default:
        return "无";
    }
  }

  String _getRarityLabel() {
    if (isBoss) return "UR";
    switch (rarity) {
      case Rarity.legendary:
        return "SSR";
      case Rarity.epic:
        return "SR";
      case Rarity.rare:
        return "R";
      case Rarity.common:
        return "N";
    }
  }

  Color _getRarityColor() {
    if (isBoss) return const Color(0xFFFFD700); // Gold
    switch (rarity) {
      case Rarity.legendary:
        return const Color(0xFFFFAA00); // Orange
      case Rarity.epic:
        return const Color(0xFFA855F7); // Purple
      case Rarity.rare:
        return const Color(0xFF3B82F6); // Blue
      case Rarity.common:
        return const Color(0xFF9CA3AF); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final rarityColor = _getRarityColor();
    final elementColor = _getElementColor();

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.8,
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 800),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: rarityColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: rarityColor.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/bg/Bg2.jpeg', // Reuse background
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Column(
                children: [
                  // Header with Close Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 30),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Character Image
                          Hero(
                            tag: "char_$name",
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    rarityColor.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Name and Rarity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: rarityColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _getRarityLabel(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Stars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(stars, (index) {
                              return const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 24,
                              );
                            }),
                          ),

                          const SizedBox(height: 24),

                          // Attributes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildAttrBadge("属性", _getElementName(), elementColor),
                              _buildAttrBadge("战力", "${(stars * 1000) + (name.hashCode % 500)}", Colors.redAccent),
                              _buildAttrBadge("定位", "输出", Colors.blueAccent), // Mock role
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Description / Story
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "背景故事",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "    $name，生于混沌初开之时，游荡于山海之间。其力能撼天动地，其灵能沟通万物。在漫长的岁月中，见证了无数神魔的兴衰更替...",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.5,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Skills (Mock)
                           Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "天赋技能",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildSkillRow("混沌打击", "对敌人造成${stars * 50}%攻击力的伤害。"),
                                const SizedBox(height: 8),
                                _buildSkillRow("灵力护体", "战斗开始时获得${stars * 10}%最大生命值的护盾。"),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttrBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSkillRow(String name, String desc) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Icon(Icons.bolt, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(desc, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                  )
              )
          ],
      );
  }
}
