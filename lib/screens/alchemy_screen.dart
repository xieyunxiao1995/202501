import 'package:flutter/material.dart' hide MaterialType;
import '../models/alchemy_model.dart';
import '../data/alchemy_data.dart';
import '../utils/alchemy_manager.dart';
import '../models/enums.dart';

class AlchemyScreen extends StatefulWidget {
  final VoidCallback onClose;

  const AlchemyScreen({super.key, required this.onClose});

  @override
  State<AlchemyScreen> createState() => _AlchemyScreenState();
}

class _AlchemyScreenState extends State<AlchemyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Elixir? _expandedElixir;
  bool _showSuccess = false;
  Elixir? _lastCraftedElixir;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _craftElixir(Elixir elixir) async {
    final success = await AlchemyManager.craftElixir(elixir);
    if (success) {
      setState(() {
        _lastCraftedElixir = elixir;
        _showSuccess = true;
      });
    }
  }

  Widget _buildSuccessOverlay(Elixir elixir, bool isSmallScreen) {
    return Container(
      color: Colors.black87,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: isSmallScreen ? 280 : 320,
                padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D1B0E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.orangeAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.5),
                      blurRadius: 20 * value,
                      spreadRadius: 5 * value,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(elixir.icon, style: TextStyle(fontSize: isSmallScreen ? 56 : 72)),
                    const SizedBox(height: 16),
                    Text(
                      "炼制成功！",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "获得 ${elixir.name}",
                      style: TextStyle(color: Colors.white, fontSize: isSmallScreen ? 16 : 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "下次冒险开始时自动生效",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: isSmallScreen ? 11 : 12),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => setState(() => _showSuccess = false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "收下",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF111827),
          appBar: AppBar(
            title: Text(
              "乾坤炉",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 20 : 24,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.amber, size: isSmallScreen ? 20 : 24),
              onPressed: widget.onClose,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.amber,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white38,
              labelStyle: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "炼丹"),
                Tab(text: "百宝袋"),
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.5,
                colors: [Colors.orange.withOpacity(0.1), const Color(0xFF111827)],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCraftingTab(isSmallScreen),
                _buildInventoryTab(isSmallScreen),
              ],
            ),
          ),
        ),
        if (_showSuccess && _lastCraftedElixir != null)
          _buildSuccessOverlay(_lastCraftedElixir!, isSmallScreen),
      ],
    );
  }

  Widget _buildCraftingTab(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      itemCount: allElixirs.length,
      itemBuilder: (context, index) {
        final elixir = allElixirs[index];
        final isExpanded = _expandedElixir?.id == elixir.id;
        final isActive = AlchemyManager.activeElixirId == elixir.id;
        final canCraft = AlchemyManager.canCraft(elixir);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.amber.withOpacity(0.1)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Colors.amber
                  : (isExpanded
                        ? Colors.amber.withOpacity(0.5)
                        : Colors.transparent),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 4 : 8,
                ),
                leading: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    elixir.icon,
                    style: TextStyle(fontSize: isSmallScreen ? 24 : 32),
                  ),
                ),
                title: Text(
                  elixir.name,
                  style: TextStyle(
                    color: isActive ? Colors.amber : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                ),
                subtitle: Text(
                  elixir.description,
                  style: TextStyle(color: Colors.white70, fontSize: isSmallScreen ? 11 : 13),
                  maxLines: isExpanded ? 10 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: isActive
                    ? Icon(Icons.check_circle, color: Colors.amber, size: isSmallScreen ? 20 : 24)
                    : Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white38,
                        size: isSmallScreen ? 20 : 24,
                      ),
                onTap: () {
                  setState(() {
                    _expandedElixir = isExpanded ? null : elixir;
                  });
                },
              ),
              if (isExpanded)
                Padding(
                  padding: EdgeInsets.fromLTRB(isSmallScreen ? 12 : 16, 0, isSmallScreen ? 12 : 16, isSmallScreen ? 12 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 8),
                      Text(
                        "所需材料:",
                        style: TextStyle(color: Colors.white54, fontSize: isSmallScreen ? 11 : 12),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: isSmallScreen ? 12 : 16,
                        runSpacing: isSmallScreen ? 6 : 8,
                        children: elixir.recipe.entries.map((entry) {
                          final mat = allMaterials.firstWhere(
                            (m) => m.id == entry.key,
                          );
                          final have = AlchemyManager.inventory[entry.key] ?? 0;
                          final need = entry.value;
                          final hasEnough = have >= need;

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                mat.icon,
                                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                mat.name,
                                style: TextStyle(
                                  color: _getRarityColor(mat.rarity),
                                  fontSize: isSmallScreen ? 11 : 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$have/$need",
                                style: TextStyle(
                                  color: hasEnough
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 11 : 13,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      if (isActive)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "已激活 (下次冒险生效)",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canCraft
                                ? () => _craftElixir(elixir)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              disabledBackgroundColor: Colors.white10,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              canCraft ? "开炉炼丹" : "材料不足",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: canCraft ? Colors.black : Colors.white38,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInventoryTab(bool isSmallScreen) {
    final inventory = AlchemyManager.inventory;
    if (inventory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.backpack_outlined,
              size: isSmallScreen ? 48 : 64,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              "乾坤袋空空如也...",
              style: TextStyle(color: Colors.white38, fontSize: isSmallScreen ? 14 : 16),
            ),
          ],
        ),
      );
    }

    // Group items by type
    final Map<MaterialType, List<AlchemyMaterial>> grouped = {};
    for (var mat in allMaterials) {
      if ((inventory[mat.id] ?? 0) > 0) {
        grouped.putIfAbsent(mat.type, () => []).add(mat);
      }
    }

    return ListView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      children: grouped.entries.map((entry) {
        String title = '';
        switch (entry.key) {
          case MaterialType.herb:
            title = "灵草";
            break;
          case MaterialType.ore:
            title = "矿石";
            break;
          case MaterialType.essence:
            title = "精华";
            break;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isSmallScreen ? 3 : 4,
                childAspectRatio: isSmallScreen ? 0.8 : 0.75,
                crossAxisSpacing: isSmallScreen ? 8 : 12,
                mainAxisSpacing: isSmallScreen ? 8 : 12,
              ),
              itemCount: entry.value.length,
              itemBuilder: (context, index) {
                final mat = entry.value[index];
                final count = inventory[mat.id] ?? 0;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRarityColor(mat.rarity).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mat.icon, style: TextStyle(fontSize: isSmallScreen ? 24 : 32)),
                      SizedBox(height: isSmallScreen ? 4 : 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          mat.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getRarityColor(mat.rarity),
                            fontSize: isSmallScreen ? 10 : 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "x$count",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isSmallScreen ? 9 : 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
          ],
        );
      }).toList(),
    );
  }
}
