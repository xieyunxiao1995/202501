import 'package:flutter/material.dart';

class MetaStoreDialog extends StatelessWidget {
  final int totalGold;
  final List<String> unlockedPerks;
  final Function(String, int) onBuy; // perkId, cost
  final VoidCallback onClose;

  const MetaStoreDialog({
    super.key,
    required this.totalGold,
    required this.unlockedPerks,
    required this.onBuy,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("万宝阁", style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("持有灵石: $totalGold ✨", style: TextStyle(color: Colors.white)),
          SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildOption("start_gold", "财源广进", "初始灵石 +50", 200, Icons.monetization_on),
                  _buildOption("start_hp", "强本固元", "初始精血 +10", 500, Icons.favorite),
                  _buildOption("start_power", "天生神力", "初始战力 +1", 1000, Icons.flash_on),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
            ),
            child: Text("关闭"),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String id, String title, String desc, int cost, IconData icon) {
    final isUnlocked = unlockedPerks.contains(id);
    final canAfford = totalGold >= cost;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isUnlocked ? Colors.green : (canAfford ? Colors.amber : Colors.grey)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isUnlocked ? Colors.green : Colors.white, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(desc, style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(Icons.check, color: Colors.green)
          else
            ElevatedButton(
              onPressed: canAfford ? () => onBuy(id, cost) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                disabledBackgroundColor: Colors.grey[800],
              ),
              child: Text("$cost 灵石", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}
