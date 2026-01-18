import 'package:flutter/material.dart';
import '../models/configs.dart';

class ShopDialog extends StatelessWidget {
  final List<ShopItem> items;
  final int playerGold;
  final Function(ShopItem) onBuy;
  final VoidCallback onClose;

  const ShopDialog({
    super.key,
    required this.items,
    required this.playerGold,
    required this.onBuy,
    required this.onClose,
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
            Text("灵宝游商", style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("灵石: $playerGold ✨", style: TextStyle(color: Colors.yellow, fontSize: 16)),
            SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: items.map((item) => _buildShopItem(item)).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: Text("辞别商贾"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopItem(ShopItem item) {
    final bool canAfford = playerGold >= item.cost;
    return Opacity(
      opacity: item.isSold ? 0.5 : 1.0,
      child: Container(
        width: 140,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(item.icon, style: TextStyle(fontSize: 32)),
            SizedBox(height: 4),
            Text(item.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(item.desc, style: TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center, maxLines: 2),
            SizedBox(height: 8),
            if (item.isSold)
              Text("已售罄", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
            else
              ElevatedButton(
                onPressed: canAfford ? () => onBuy(item) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  minimumSize: Size(0, 30),
                ),
                child: Text("${item.cost} 灵石", style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }
}
