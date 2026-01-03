import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/player_stats.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class ShopScreen extends StatefulWidget {
  final PlayerStats stats;
  final List<Item> inventory;
  final List<Item> deck;
  final Function(PlayerStats) onStatsChanged;
  final Function(List<Item>) onInventoryChanged;

  const ShopScreen({
    super.key,
    required this.stats,
    required this.inventory,
    required this.deck,
    required this.onStatsChanged,
    required this.onInventoryChanged,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late List<Item> _shopItems;

  @override
  void initState() {
    super.initState();
    _initShop();
  }

  void _initShop() {
    int level = widget.stats.currentFloor;
    int damageScale = 10 + (level * 1.5).toInt();
    int potionScale = 50 + (level * 5);

    _shopItems = [
      Item(id: 'shop_potion', name: 'Great Potion', description: 'Restores $potionScale HP', damage: -potionScale, iconData: '🧪'),
      Item(id: 'shop_sword', name: 'Sword Lv.$level', description: 'Dmg $damageScale', damage: damageScale, iconData: '⚔️'),
      Item(id: 'shop_shield', name: 'Shield Lv.$level', description: 'Small Dmg', damage: (damageScale * 0.3).toInt(), iconData: '🛡️'),
      Item(id: 'shop_magic', name: 'Rune Lv.$level', description: 'Magic Dmg', damage: (damageScale * 1.2).toInt(), iconData: '🔮'),
    ];
  }

  int _getItemCost(Item item) {
    int level = widget.stats.currentFloor;
    if (item.damage < 0) return 5 + (level ~/ 2); // Potions cheaper
    return 10 + level; // Gear more expensive
  }

  int get _goldCount => widget.stats.gold;

  void _buyItem(Item item, int cost) {
    if (_goldCount >= cost) {
      // Deduct Gold
      widget.stats.gold -= cost;
      widget.onStatsChanged(widget.stats);

      // Add Item
      List<Item> newInventory = List.from(widget.inventory);
      Item newItem = Item(
        id: '${item.id}_${DateTime.now().millisecondsSinceEpoch}',
        name: item.name,
        description: item.description,
        damage: item.damage,
        iconData: item.iconData,
      );
      newInventory.add(newItem);
      
      widget.onInventoryChanged(newInventory);
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bought ${item.name}!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Not enough Gold!")));
    }
  }

  void _sellItem(Item item) {
    // Check if equipped
    if (widget.deck.any((e) => e.id == item.id)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot sell equipped items!")));
      return;
    }

    List<Item> newInventory = List.from(widget.inventory);
    newInventory.removeWhere((e) => e.id == item.id);
    
    // Add Gold
    widget.stats.gold += 1;
    widget.onStatsChanged(widget.stats);
    
    widget.onInventoryChanged(newInventory);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sold ${item.name} for 1 Gold")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.towerBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Mysterious Merchant", style: TextStyle(fontFamily: 'serif')),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text("💰 $_goldCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
          ))
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: DefaultTabController(
            length: 2,
            child: Column(
          children: [
            const TabBar(
              indicatorColor: AppColors.accent,
              labelColor: AppColors.accent,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(text: "Buy"),
                Tab(text: "Sell"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Buy Tab
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _shopItems.length,
                    itemBuilder: (context, index) {
                      final item = _shopItems[index];
                      final cost = _getItemCost(item);
                      return GlassContainer(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                        opacity: 0.3,
                        child: ListTile(
                          leading: Text(item.iconData, style: const TextStyle(fontSize: 32)),
                          title: Text(item.name, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(item.description, style: const TextStyle(color: Colors.white54)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.black),
                            onPressed: () => _buyItem(item, cost),
                            child: Text("$cost 💰"),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Sell Tab
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.inventory.length,
                    itemBuilder: (context, index) {
                      final item = widget.inventory[index];
                      if (item.name == 'Gold') return const SizedBox.shrink(); // Don't sell gold
                      
                      return GlassContainer(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                        opacity: 0.3,
                        child: ListTile(
                          leading: Text(item.iconData, style: const TextStyle(fontSize: 32)),
                          title: Text(item.name, style: const TextStyle(color: Colors.white)),
                          subtitle: Text("Sell for 1 Gold", style: const TextStyle(color: Colors.white54)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                            onPressed: () => _sellItem(item),
                            child: const Text("Sell"),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}