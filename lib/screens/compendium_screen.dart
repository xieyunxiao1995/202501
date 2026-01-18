import 'package:flutter/material.dart';
import '../constants.dart';
import '../data/alchemy_data.dart';
import '../data/souls_data.dart';
import '../data/events_data.dart';
import '../models/alchemy_model.dart';
import '../models/soul_model.dart';
import '../models/event_model.dart';
import '../models/configs.dart';
import '../models/enums.dart';

class CompendiumScreen extends StatefulWidget {
  final VoidCallback onClose;
  final List<String> currentRelics;

  const CompendiumScreen({
    super.key,
    required this.onClose,
    required this.currentRelics,
  });

  @override
  State<CompendiumScreen> createState() => _CompendiumScreenState();
}

class _CompendiumScreenState extends State<CompendiumScreen>
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: Text(
          "山海图鉴",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 20 : 24,
            fontFamily: "Serif",
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: isSmallScreen ? 50 : 56,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.amber, size: isSmallScreen ? 20 : 24),
          onPressed: widget.onClose,
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white54,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 12 : 14,
          ),
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
          tabs: List.generate(_tabs.length, (index) {
            return Tab(
              icon: Icon(_tabIcons[index], size: isSmallScreen ? 20 : 24),
              text: _tabs[index],
              height: isSmallScreen ? 45 : 60,
              iconMargin: EdgeInsets.only(bottom: isSmallScreen ? 2 : 8),
            );
          }),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.5,
            colors: [Colors.amber.withOpacity(0.05), const Color(0xFF111827)],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBestiary(isSmallScreen),
            _buildRelics(isSmallScreen),
            _buildSouls(isSmallScreen),
            _buildAlchemy(isSmallScreen),
            _buildEvents(isSmallScreen),
            _buildPerks(isSmallScreen),
            _buildClasses(isSmallScreen),
            _buildEquipment(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildBestiary(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      itemCount: monsterNames.length + bossNames.length,
      itemBuilder: (context, index) {
        final bool isBoss = index >= monsterNames.length;
        final name = isBoss
            ? bossNames[index - monsterNames.length]
            : monsterNames[index];

        return Container(
          margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
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
                  ? Colors.redAccent.withOpacity(0.5)
                  : Colors.white10,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 4 : 8,
            ),
            leading: Container(
              padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
                border: Border.all(color: isBoss ? Colors.red : Colors.grey),
              ),
              child: Text(
                isBoss ? "👹" : "👾",
                style: TextStyle(fontSize: isSmallScreen ? 20 : 24),
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                color: isBoss ? Colors.redAccent : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  isBoss ? "大荒领主 - 极度危险" : "大荒妖兽 - 常见威胁",
                  style: TextStyle(color: Colors.white54, fontSize: isSmallScreen ? 11 : 13),
                ),
              ],
            ),
            trailing: isBoss
                ? Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: isSmallScreen ? 20 : 24,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildRelics(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
          isSmallScreen: isSmallScreen,
        );
      },
    );
  }

  Widget _buildSouls(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
          isSmallScreen: isSmallScreen,
        );
      },
    );
  }

  Widget _buildAlchemy(bool isSmallScreen) {
    // Combine materials and elixirs
    final List<dynamic> alchemyItems = [...allMaterials, ...allElixirs];

    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
          isSmallScreen: isSmallScreen,
        );
      },
    );
  }

  Widget _buildEvents(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
          collapsedBackgroundColor: Colors.white.withOpacity(0.05),
          backgroundColor: Colors.white.withOpacity(0.08),
          leading: Text(event.icon, style: TextStyle(fontSize: isSmallScreen ? 24 : 28)),
          title: Text(
            event.title,
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 15 : 16,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.description,
                    style: TextStyle(color: Colors.white70, fontSize: isSmallScreen ? 12 : 14),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    "抉择:",
                    style: TextStyle(color: Colors.white54, fontSize: isSmallScreen ? 11 : 12),
                  ),
                  SizedBox(height: 4),
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
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: isSmallScreen ? 11 : 13,
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

  Widget _buildPerks(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
          isSmallScreen: isSmallScreen,
        );
      },
    );
  }

  Widget _buildClasses(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final cls = classes[index];
        return Card(
          color: Colors.white.withOpacity(0.05),
          margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Text(
                        cls.icon,
                        style: TextStyle(fontSize: isSmallScreen ? 20 : 24),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cls.name,
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "HP: ${cls.hp} | ATK: ${cls.power}",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: isSmallScreen ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Text(
                  cls.desc,
                  style: TextStyle(color: Colors.white70, fontSize: isSmallScreen ? 12 : 14),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                const Divider(color: Colors.white10),
                SizedBox(height: isSmallScreen ? 6 : 8),
                _buildAbilityRow("神通", cls.skillName, cls.skillDesc, isSmallScreen),
                SizedBox(height: 4),
                _buildAbilityRow("被动", cls.passiveName, cls.passiveDesc, isSmallScreen),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEquipment(bool isSmallScreen) {
    return ListView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
          child: Text(
            "神兵",
            style: TextStyle(
              color: Colors.amber,
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: isSmallScreen ? 4 : 8,
          runSpacing: isSmallScreen ? 4 : 8,
          children: weaponNames
              .map(
                (name) => Chip(
                  avatar: Text(isSmallScreen ? "" : "⚔️"),
                  label: Text(
                    name,
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                  backgroundColor: Colors.white10,
                  labelStyle: const TextStyle(color: Colors.white),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 4 : 8,
                    vertical: isSmallScreen ? 0 : 4,
                  ),
                  materialTapTargetSize: isSmallScreen ? MaterialTapTargetSize.shrinkWrap : null,
                ),
              )
              .toList(),
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
          child: Text(
            "宝甲",
            style: TextStyle(
              color: Colors.amber,
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: isSmallScreen ? 4 : 8,
          runSpacing: isSmallScreen ? 4 : 8,
          children: shieldNames
              .map(
                (name) => Chip(
                  avatar: Text(isSmallScreen ? "" : "🛡️"),
                  label: Text(
                    name,
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                  backgroundColor: Colors.white10,
                  labelStyle: const TextStyle(color: Colors.white),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 4 : 8,
                    vertical: isSmallScreen ? 0 : 4,
                  ),
                  materialTapTargetSize: isSmallScreen ? MaterialTapTargetSize.shrinkWrap : null,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAbilityRow(String label, String name, String desc, bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.amber,
              fontSize: isSmallScreen ? 9 : 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$name: ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 12 : 13,
                  ),
                ),
                TextSpan(
                  text: desc,
                  style: TextStyle(color: Colors.white70, fontSize: isSmallScreen ? 12 : 13),
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
    required bool isSmallScreen,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHighlight
              ? [color.withOpacity(0.4), const Color(0xFF1F2937)]
              : [
                  const Color(0xFF1F2937).withOpacity(0.5),
                  const Color(0xFF374151).withOpacity(0.5),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? Colors.amberAccent : color.withOpacity(0.3),
          width: isHighlight ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 4 : 8,
        ),
        leading: Container(
          padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Text(icon, style: TextStyle(fontSize: isSmallScreen ? 20 : 24)),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
            if (tag != null) ...[
              SizedBox(width: isSmallScreen ? 6 : 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (tagColor ?? Colors.grey).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: (tagColor ?? Colors.grey).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagColor ?? Colors.grey,
                    fontSize: isSmallScreen ? 9 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: isSmallScreen ? 2 : 4),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.white70, fontSize: isSmallScreen ? 12 : 14),
          ),
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
        return Colors.white70;
      case Rarity.rare:
        return Colors.blueAccent;
      case Rarity.epic:
        return Colors.purpleAccent;
      case Rarity.legendary:
        return Colors.orangeAccent;
    }
  }
}
