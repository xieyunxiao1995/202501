import 'package:flutter/material.dart';
import '../models/enums.dart';

class CharacterCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final GameElement element;
  final Rarity rarity;
  final int stars;
  final bool isBoss;
  final VoidCallback? onTap;

  const CharacterCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.element,
    required this.rarity,
    required this.stars,
    this.isBoss = false,
    this.onTap,
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

  String _getElementIcon() {
    switch (element) {
      case GameElement.fire:
        return "🔥";
      case GameElement.water:
        return "💧";
      case GameElement.wood:
        return "🍃";
      case GameElement.metal:
        return "⚔️";
      case GameElement.earth:
        return "⛰️";
      default:
        return "❓";
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
    final elementColor = _getElementColor();
    final rarityColor = _getRarityColor();
    final rarityLabel = _getRarityLabel();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(32), // Pointed bottom effect
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: rarityColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Gradient
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        rarityColor.withValues(alpha: 0.1),
                        rarityColor.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Character Image
            Positioned.fill(
              bottom: 24, // Leave space for name
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Center(
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),

            // Top Left: Element
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: elementColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Text(
                  _getElementIcon(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),

            // Top Right: Rarity
            Positioned(
              top: 6,
              right: 6,
              child: Text(
                rarityLabel,
                style: TextStyle(
                  color: rarityColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      color: Colors.white.withValues(alpha: 0.8),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom: Name and Stars
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(stars, (index) {
                      return Icon(Icons.star, color: Colors.amber, size: 10);
                    }),
                  ),
                  const SizedBox(height: 2),
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      shadows: [
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
