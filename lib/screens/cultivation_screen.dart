import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../models/configs.dart';
import '../constants.dart';
import '../data/souls_data.dart';
import '../models/enums.dart';
import '../widgets/background_wrapper.dart';

class CultivationScreen extends StatelessWidget {
  final PlayerStats player;
  final VoidCallback onBack;

  const CultivationScreen({
    super.key,
    required this.player,
    required this.onBack,
  });

  String getRealmName(int level) {
    if (level <= 5) return "练气期";
    if (level <= 10) return "筑基期";
    if (level <= 15) return "结丹期";
    if (level <= 20) return "元婴期";
    if (level <= 25) return "化神期";
    if (level <= 30) return "合体期";
    if (level <= 35) return "大乘期";
    return "渡劫期";
  }

  Color getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return Colors.white70;
      case Rarity.rare:
        return Colors.blueAccent;
      case Rarity.epic:
        return Colors.purpleAccent;
      case Rarity.legendary:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        title: const Text(
          "洞府修行",
          style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.cyanAccent),
          onPressed: onBack,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.5,
            colors: [Colors.cyan.withValues(alpha: 0.05), Colors.transparent],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildStatsGrid(),
              const SizedBox(height: 16),
              _buildSoulSection(),
              const SizedBox(height: 16),
              _buildSectionTitle("持有命格", Icons.auto_awesome),
              const SizedBox(height: 8),
              _buildPerksList(),
              const SizedBox(height: 16),
              _buildSectionTitle("奇珍异宝", Icons.diamond),
              const SizedBox(height: 8),
              _buildRelicsList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final realm = getRealmName(player.level);
    final xpProgress = player.maxXp > 0 ? player.xp / player.maxXp : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Text("🧘", style: TextStyle(fontSize: 40)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      realm,
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Lv.${player.level}",
                        style: const TextStyle(color: Colors.purpleAccent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("修为进度: ", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const Spacer(),
                    Text("${player.xp}/${player.maxXp}",
                        style: const TextStyle(color: Colors.cyan, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: xpProgress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard("🩸 精血", "${player.hp}/${player.maxHp}", Colors.redAccent),
        _buildStatCard("⚔️ 攻击", "${player.power}", Colors.orangeAccent),
        _buildStatCard("🛡️ 护身", "${player.shield}", Colors.blueAccent),
        _buildStatCard("✨ 灵石", "${player.gold}", Colors.yellowAccent),
        _buildStatCard("👣 层数", "${player.floor}", Colors.white70),
        _buildStatCard("🔥 连击", "${player.combo}", Colors.deepOrangeAccent),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSoulSection() {
    final soul = player.equippedSoulId != null
        ? allSouls.firstWhere((s) => s.id == player.equippedSoulId)
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("装备魂魄", Icons.psychology, color: Colors.amberAccent),
          const SizedBox(height: 12),
          if (soul != null)
            Row(
              children: [
                Text(soul.icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        soul.name,
                        style: TextStyle(
                          color: getRarityColor(soul.rarity),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        soul.description,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            const Center(
              child: Text("尚未装备魂魄",
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, {Color color = Colors.cyanAccent}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPerksList() {
    if (player.perks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text("暂无命格", style: TextStyle(color: Colors.grey, fontSize: 12))),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: player.perks.map((perkId) {
        final perk = perks.firstWhere((p) => p.id == perkId,
            orElse: () => Perk(
                id: '',
                name: '未知',
                desc: '',
                icon: '❓',
                rarity: Rarity.common));
        return Container(
          width: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: getRarityColor(perk.rarity).withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(perk.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                perk.name,
                style: TextStyle(
                    color: getRarityColor(perk.rarity),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRelicsList() {
    if (player.relics.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text("暂无奇珍", style: TextStyle(color: Colors.grey, fontSize: 12))),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: player.relics.map((relicId) {
        final relic = relics.firstWhere((r) => r.id == relicId,
            orElse: () => RelicConfig(id: '', name: '未知', icon: '❓', desc: '', cost: 0));
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          alignment: Alignment.center,
          child: Text(relic.icon, style: const TextStyle(fontSize: 24)),
        );
      }).toList(),
    );
  }
}
