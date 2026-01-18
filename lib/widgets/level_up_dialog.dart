import 'package:flutter/material.dart';
import '../models/configs.dart';
import '../constants.dart'; // for rarity colors

class LevelUpDialog extends StatelessWidget {
  final List<Perk> options;
  final Function(Perk) onSelect;

  const LevelUpDialog({
    super.key,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1F2937),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("修为突破！", style: TextStyle(color: Colors.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("选择一个命格天赋", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 16),
            ...options.map((perk) => _buildPerkOption(perk)),
          ],
        ),
      ),
    );
  }

  Widget _buildPerkOption(Perk perk) {
    Color rarityColor = rarityColors[perk.rarity] ?? Colors.white;

    return GestureDetector(
      onTap: () => onSelect(perk),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: rarityColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Text(perk.icon, style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(perk.name, style: TextStyle(color: rarityColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(perk.desc, style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
