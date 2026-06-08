import 'package:flutter/material.dart';

/// 称号徽章组件
///
/// 显示玩家称号的徽章组件，用于个人信息展示。
class TitleBadge extends StatelessWidget {
  /// 称号名称
  final String title;

  /// 称号稀有度
  final int rarity;

  const TitleBadge({
    super.key,
    required this.title,
    this.rarity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getRarityGradient(),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Color> _getRarityGradient() {
    switch (rarity) {
      case 5:
        return [Colors.orange, Colors.deepOrange];
      case 4:
        return [Colors.purple, Colors.deepPurple];
      case 3:
        return [Colors.blue, Colors.indigo];
      default:
        return [Colors.grey, Colors.blueGrey];
    }
  }
}
