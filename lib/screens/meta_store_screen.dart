import 'package:flutter/material.dart';
import '../widgets/animated_counter.dart';
import '../widgets/background_wrapper.dart';

class MetaStoreScreen extends StatelessWidget {
  final int totalGold;
  final List<String> unlockedPerks;
  final Function(String, int) onBuy; // perkId, cost
  final VoidCallback onClose;

  const MetaStoreScreen({
    super.key,
    required this.totalGold,
    required this.unlockedPerks,
    required this.onBuy,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        title: Text("万宝阁", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 18 : 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.amber, size: isSmallScreen ? 20 : 24),
          onPressed: onClose,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8.0 : 16.0),
            child: Row(
              children: [
                Text("✨ ", style: TextStyle(fontSize: isSmallScreen ? 16 : 18)),
                AnimatedCounter(
                  value: totalGold,
                  style: TextStyle(color: Colors.amber, fontSize: isSmallScreen ? 16 : 18, fontWeight: FontWeight.bold),
                  suffix: isSmallScreen ? "" : " 灵石",
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 12.0 : 24.0,
                isSmallScreen ? 8.0 : 24.0,
                isSmallScreen ? 12.0 : 24.0,
                isSmallScreen ? 4.0 : 16.0,
              ),
              child: Text(
                "消耗灵石以获得永久属性加成，助你在大荒中走得更远。",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  left: isSmallScreen ? 12 : 16,
                  right: isSmallScreen ? 12 : 16,
                  bottom: isSmallScreen ? 20 : 32,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildSectionHeader("基础修行", isSmallScreen),
                  _buildOption("start_gold", "财源广进", "冒险初始灵石 +50", 200, "💰", isSmallScreen),
                  _buildOption("start_hp", "强本固元", "冒险初始气血 +10", 500, "💖", isSmallScreen),
                  _buildOption("start_power", "天生神力", "冒险初始灵力 +1", 1000, "⚔️", isSmallScreen),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  _buildSectionHeader("进阶功法", isSmallScreen),
                  _buildOption("exp_boost", "悟性过人", "修行效率 +10% (敬请期待)", 2000, "🧠", isSmallScreen, locked: true),
                  _buildOption("luck_boost", "鸿运当头", "稀有奖励出现概率增加 (敬请期待)", 3000, "🍀", isSmallScreen, locked: true),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildSectionHeader(String title, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8.0 : 12.0),
      child: Row(
        children: [
          Container(width: 4, height: isSmallScreen ? 16 : 20, color: Colors.amber),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: Colors.amber, fontSize: isSmallScreen ? 16 : 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOption(String id, String title, String desc, int cost, String icon, bool isSmallScreen, {bool locked = false}) {
    final isUnlocked = unlockedPerks.contains(id);
    final canAfford = totalGold >= cost;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? Colors.green.withValues(alpha: 0.5) : (canAfford && !locked ? Colors.amber.withValues(alpha: 0.5) : Colors.white10),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 40 : 48,
            height: isSmallScreen ? 40 : 48,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(icon, style: TextStyle(fontSize: isSmallScreen ? 20 : 24))),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.white60, fontSize: isSmallScreen ? 11 : 13)),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(Icons.check_circle, color: Colors.green, size: isSmallScreen ? 20 : 24)
          else if (locked)
            Text("未开启", style: TextStyle(color: Colors.white24, fontSize: isSmallScreen ? 12 : 14))
          else
            ElevatedButton(
              onPressed: canAfford ? () => onBuy(id, cost) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                disabledBackgroundColor: Colors.white10,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16, vertical: isSmallScreen ? 6 : 8),
                minimumSize: Size(isSmallScreen ? 60 : 80, 0),
              ),
              child: Text("$cost", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 14)),
            ),
        ],
      ),
    );
  }
}
