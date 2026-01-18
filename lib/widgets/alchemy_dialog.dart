import 'package:flutter/material.dart';
import '../models/alchemy_model.dart';
import '../data/alchemy_data.dart';
import '../utils/alchemy_manager.dart';
import '../models/enums.dart';

class AlchemyDialog extends StatefulWidget {
  final VoidCallback onClose;

  const AlchemyDialog({super.key, required this.onClose});

  @override
  State<AlchemyDialog> createState() => _AlchemyDialogState();
}

class _AlchemyDialogState extends State<AlchemyDialog> {
  int _tabIndex = 0; // 0: Craft, 1: Inventory
  Elixir? _selectedElixir;
  String? _activeElixirId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await AlchemyManager.load();
    setState(() {
      _activeElixirId = AlchemyManager.activeElixirId;
    });
  }

  Future<void> _craft(Elixir elixir) async {
    final success = await AlchemyManager.craftElixir(elixir);
    if (success) {
      setState(() {
        _activeElixirId = AlchemyManager.activeElixirId;
      });
      // Show confirmation?
    } else {
      // Show error? (Should be disabled button anyway)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.9),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "乾坤炉",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Courier New",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTab("炼制丹药", 0),
                const SizedBox(width: 20),
                _buildTab("材料仓库", 1),
              ],
            ),
            const SizedBox(height: 10),

            // Content
            Expanded(
              child: _tabIndex == 0 ? _buildCraftingTab() : _buildInventoryTab(),
            ),

            // Active Elixir Status
            if (_activeElixirId != null)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.purple.withValues(alpha: 0.2),
                width: double.infinity,
                child: Column(
                  children: [
                    const Text("生效中的丹药 (下次冒险)", style: TextStyle(color: Colors.purpleAccent, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      allElixirs.firstWhere((e) => e.id == _activeElixirId).name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? Colors.amber : Colors.transparent, width: 2)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.amber : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCraftingTab() {
    return Row(
      children: [
        // List
        Expanded(
          flex: 4,
          child: ListView.builder(
            itemCount: allElixirs.length,
            itemBuilder: (context, index) {
              final elixir = allElixirs[index];
              final isSelected = _selectedElixir == elixir;
              return GestureDetector(
                onTap: () => setState(() => _selectedElixir = elixir),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.amber.withValues(alpha: 0.2) : Colors.grey[900],
                    border: Border.all(color: isSelected ? Colors.amber : Colors.grey[800]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(elixir.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(elixir.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text(elixir.description, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Detail
        Expanded(
          flex: 6,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: _selectedElixir == null
                ? const Center(child: Text("选择一种丹药进行炼制", style: TextStyle(color: Colors.grey)))
                : _buildElixirDetail(_selectedElixir!),
          ),
        ),
      ],
    );
  }

  Widget _buildElixirDetail(Elixir elixir) {
    final canCraft = AlchemyManager.canCraft(elixir);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(elixir.icon, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        Text(elixir.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          elixir.description,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 24),
        const Text("配方:", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: elixir.recipe.entries.map((entry) {
            final mat = allMaterials.firstWhere((m) => m.id == entry.key);
            final have = AlchemyManager.inventory[entry.key] ?? 0;
            final need = entry.value;
            final hasEnough = have >= need;
            
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: hasEnough ? Colors.green : Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(mat.icon, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 4),
                Text(
                  "$have/$need",
                  style: TextStyle(
                    color: hasEnough ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: canCraft ? () => _craft(elixir) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            disabledBackgroundColor: Colors.grey[800],
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: Text(
            "炼制",
            style: TextStyle(color: canCraft ? Colors.black : Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTab() {
    if (AlchemyManager.inventory.isEmpty) {
      return const Center(child: Text("尚未收集到任何材料。", style: TextStyle(color: Colors.grey)));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: allMaterials.length,
      itemBuilder: (context, index) {
        final mat = allMaterials[index];
        final count = AlchemyManager.inventory[mat.id] ?? 0;
        
        // Hide undiscovered items? Or just show 0?
        // Let's show all but grey out 0.
        final hasItem = count > 0;

        return Container(
          decoration: BoxDecoration(
            color: hasItem ? Colors.grey[900] : Colors.black,
            border: Border.all(color: hasItem ? _getRarityColor(mat.rarity) : Colors.grey[900]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mat.icon, style: TextStyle(fontSize: 24, color: hasItem ? null : Colors.white.withValues(alpha: 0.2))),
              const SizedBox(height: 8),
              Text(
                mat.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: hasItem ? Colors.white : Colors.grey[700],
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "x$count",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.common: return Colors.grey;
      case Rarity.rare: return Colors.blue;
      case Rarity.epic: return Colors.purple;
      case Rarity.legendary: return Colors.orange;
    }
  }
}
