import 'package:flutter/material.dart';

class BottomNavIcon extends StatelessWidget {
  const BottomNavIcon({
    super.key,
    required this.normalImagePath,
    required this.selectedImagePath,
    required this.isSelected,
    this.badgeCount = 0,
    this.isSpecial = false,
  });

  final String normalImagePath;
  final String selectedImagePath;
  final bool isSelected;
  final bool isSpecial;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Image.asset(
              isSelected ? selectedImagePath : normalImagePath,
              width: isSpecial ? 28 : 24,
              height: isSpecial ? 28 : 24,
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -10,
              top: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Center(
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
