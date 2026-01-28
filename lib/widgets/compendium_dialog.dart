import 'package:flutter/material.dart';
import '../constants.dart';
import '../data/alchemy_data.dart';
import '../data/souls_data.dart';
import '../data/events_data.dart';
import '../models/alchemy_model.dart';
import '../models/enums.dart';

class CompendiumDialog extends StatefulWidget {
  final VoidCallback onClose;
  final List<String> currentRelics;

  const CompendiumDialog({
    super.key,
    required this.onClose,
    required this.currentRelics,
  });

  @override
  State<CompendiumDialog> createState() => _CompendiumDialogState();
}

class _CompendiumDialogState extends State<CompendiumDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ["妖兽", "法宝", "元魂", "丹药", "奇遇", "功法", "职业", "装备"];

  final List<IconData> _tabIcons = [
    Icons.pets,
    Icons.auto_awesome,
    Icons.psychology,
    Icons.science,
    Icons.explore,
    Icons.book,
    Icons.person,
    Icons.shield,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937), // Gray-800
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber[700]!, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF111827), // Gray-900
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.amber, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    "山海图鉴",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Serif",
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              color: const Color(0xFF111827),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.white54,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: List.generate(_tabs.length, (index) {
                  return Tab(icon: Icon(_tabIcons[index]), text: _tabs[index]);
                }),
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBestiary(),
                  _buildRelics(),
                  _buildSouls(),
                  _buildAlchemy(),
                  _buildEvents(),
                  _buildPerks(),
                  _buildClasses(),
                  _buildEquipment(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestiary() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: monsterNames.length + bossNames.length,
      itemBuilder: (context, index) {
        final bool isBoss = index >= monsterNames.length;
        final name = isBoss
            ? bossNames[index - monsterNames.length]
            : monsterNames[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isBoss
                  ? [const Color(0xFF7F1D1D), const Color(0xFF374151)]
                  : [const Color(0xFF1F2937), const Color(0xFF374151)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isBoss
                  ? Colors.redAccent.withValues(alpha: 0.5)
                  : Colors.white10,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
                border: Border.all(color: isBoss ? Colors.red : Colors.grey),
              ),
              child: Text(
                isBoss ? "👹" : "👾",
                style: const TextStyle(fontSize: 24),
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                color: isBoss ? Colors.redAccent : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  isBoss ? "大荒领主 - 极度危险" : "大荒妖兽 - 常见威胁",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
            trailing: isBoss
                ? const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildRelics() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: relics.length,
      itemBuilder: (context, index) {
        final relic = relics[index];
        final isEquipped = widget.currentRelics.contains(relic.id);

        return _buildCard(
          icon: relic.icon,
          title: relic.name,
          subtitle: relic.desc,
          tag: "${relic.cost} 灵石",
          isHighlight: isEquipped,
          color: Colors.purpleAccent,
        );
      },
    );
  }

  Widget _buildSouls() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allSouls.length,
      itemBuilder: (context, index) {
        final soul = allSouls[index];
        return _buildCard(
          icon: soul.icon,
          title: soul.name,
          subtitle: soul.description,
          tag: _getRarityLabel(soul.rarity),
          tagColor: _getRarityColor(soul.rarity),
          color: _getRarityColor(soul.rarity),
        );
      },
    );
  }

  Widget _buildAlchemy() {
    // Combine materials and elixirs
    final List<dynamic> alchemyItems = [...allMaterials, ...allElixirs];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: alchemyItems.length,
      itemBuilder: (context, index) {
        final item = alchemyItems[index];
        final bool isMaterial = item is AlchemyMaterial;

        String name = isMaterial ? item.name : (item as Elixir).name;
        String icon = isMaterial ? item.icon : (item as Elixir).icon;
        String desc = isMaterial
            ? item.description
            : (item as Elixir).description;
        Rarity rarity = isMaterial ? item.rarity : (item as Elixir).rarity;
        String typeLabel = isMaterial ? "材料" : "丹药";

        return _buildCard(
          icon: icon,
          title: name,
          subtitle: desc,
          tag: typeLabel,
          tagColor: isMaterial ? Colors.green : Colors.orange,
          color: _getRarityColor(rarity),
        );
      },
    );
  }

  Widget _buildEvents() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allEvents.length,
      itemBuilder: (context, index) {
        final event = allEvents[index];
        return ExpansionTile(
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          collapsedBackgroundColor: Colors.white.withValues(alpha: 0.05),
          backgroundColor: Colors.white.withValues(alpha: 0.08),
          leading: Text(event.icon, style: const TextStyle(fontSize: 28)),
          title: Text(
            event.title,
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "抉择:",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  ...event.options.map(
                    (opt) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "• ",
                            style: TextStyle(color: Colors.amber),
                          ),
                          Expanded(
                            child: Text(
                              "${opt.label}: ${opt.description}",
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPerks() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: perks.length,
      itemBuilder: (context, index) {
        final perk = perks[index];
        return _buildCard(
          icon: perk.icon,
          title: perk.name,
          subtitle: perk.desc,
          tag: _getRarityLabel(perk.rarity),
          tagColor: _getRarityColor(perk.rarity),
          color: _getRarityColor(perk.rarity),
        );
      },
    );
  }

  Widget _buildClasses() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final cls = classes[index];
        return Card(
          color: Colors.white.withValues(alpha: 0.05),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Text(
                        cls.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cls.name,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "HP: ${cls.hp} | ATK: ${cls.power}",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(cls.desc, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                const Divider(color: Colors.white10),
                const SizedBox(height: 8),
                _buildAbilityRow("神通", cls.skillName, cls.skillDesc),
                const SizedBox(height: 4),
                _buildAbilityRow("被动", cls.passiveName, cls.passiveDesc),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEquipment() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            "神兵",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weaponNames
              .map(
                (name) => Chip(
                  avatar: const Text("⚔️"),
                  label: Text(name),
                  backgroundColor: Colors.white10,
                  labelStyle: const TextStyle(color: Colors.white),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            "宝甲",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: shieldNames
              .map(
                (name) => Chip(
                  avatar: const Text("🛡️"),
                  label: Text(name),
                  backgroundColor: Colors.white10,
                  labelStyle: const TextStyle(color: Colors.white),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAbilityRow(String label, String name, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$name: ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: desc,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String icon,
    required String title,
    required String subtitle,
    String? tag,
    Color? tagColor,
    bool isHighlight = false,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHighlight
              ? [color.withValues(alpha: 0.4), const Color(0xFF1F2937)]
              : [
                  const Color(0xFF1F2937).withValues(alpha: 0.5),
                  const Color(0xFF374151).withValues(alpha: 0.5),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? Colors.amberAccent : color.withValues(alpha: 0.3),
          width: isHighlight ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Text(icon, style: const TextStyle(fontSize: 24)),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (tag != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (tagColor ?? Colors.grey).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: (tagColor ?? Colors.grey).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagColor ?? Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ),
      ),
    );
  }

  String _getRarityLabel(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return "凡品";
      case Rarity.rare:
        return "良品";
      case Rarity.epic:
        return "仙品";
      case Rarity.legendary:
        return "神品";
    }
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return Colors.grey;
      case Rarity.rare:
        return Colors.blue;
      case Rarity.epic:
        return Colors.purple;
      case Rarity.legendary:
        return Colors.orange;
    }
  }
}
