import 'package:flutter/material.dart';
import '../models/item.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';
import 'item_detail_screen.dart';

class GrimoireScreen extends StatefulWidget {
  final List<Item> inventory;
  final List<Item> deck;
  final Function(List<Item>) onDeckChanged;
  final Function(List<Item>) onInventoryChanged;

  const GrimoireScreen({
    super.key,
    required this.inventory,
    required this.deck,
    required this.onDeckChanged,
    required this.onInventoryChanged,
  });

  @override
  State<GrimoireScreen> createState() => _GrimoireScreenState();
}

class _GrimoireScreenState extends State<GrimoireScreen> {
  String _filter = 'All'; // All, Attack, Heal, Material

  void _toggleEquip(Item item) {
    List<Item> newDeck = List.from(widget.deck);
    
    // Check if item is already in deck
    bool isInDeck = newDeck.any((e) => e.id == item.id);

    if (isInDeck) {
      // Remove
      newDeck.removeWhere((e) => e.id == item.id);
    } else {
      // Add
      if (newDeck.length < 8) {
        newDeck.add(item);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deck is full (Max 8 items)')),
        );
        return;
      }
    }
    
    widget.onDeckChanged(newDeck);
  }

  void _unequipFromDeck(Item item) {
    List<Item> newDeck = List.from(widget.deck);
    newDeck.removeWhere((e) => e.id == item.id);
    widget.onDeckChanged(newDeck);
  }
  
  List<Item> get _filteredInventory {
    if (_filter == 'All') return widget.inventory;
    if (_filter == 'Attack') return widget.inventory.where((i) => i.damage > 0).toList();
    if (_filter == 'Heal') return widget.inventory.where((i) => i.damage < 0).toList();
    // Material assumed if damage is 0 or just fallback
    return widget.inventory.where((i) => i.damage == 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("Grimoire", style: TextStyle(fontSize: 28, fontFamily: 'serif', color: AppColors.accent)),
        const SizedBox(height: 10),
        Text("Active Deck (${widget.deck.length}/8)", style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 10),
        
        // Deck View
        GlassContainer(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          color: Colors.black,
          opacity: 0.3,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.deck.length == 8 ? AppColors.accent : Colors.red),
          child: widget.deck.isEmpty 
            ? const Center(child: Text("Deck Empty. Select items below.", style: TextStyle(color: Colors.white24)))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.deck.map((item) => GestureDetector(
                    onTap: () => _unequipFromDeck(item),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Tooltip(
                        message: item.name,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.accent.withOpacity(0.2),
                          child: Text(item.iconData, style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
        ),
        
        const SizedBox(height: 20),
        const Divider(color: Colors.white24),
        
        // Filter Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['All', 'Attack', 'Heal'].map((filter) {
              final isSelected = _filter == filter;
              return GestureDetector(
                onTap: () => setState(() => _filter = filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent),
                  ),
                  child: Text(
                    filter, 
                    style: TextStyle(
                      color: isSelected ? Colors.black : AppColors.accent,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 10),
        
        Expanded(
          child: _filteredInventory.isEmpty 
          ? const Center(child: Text("No items found.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)))
          : ListView.builder(
            itemCount: _filteredInventory.length,
            itemBuilder: (context, index) {
              final item = _filteredInventory[index];
              final isEquipped = widget.deck.any((e) => e.id == item.id);
              
              return GlassContainer(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  leading: Text(item.iconData, style: const TextStyle(fontSize: 32)),
                  title: Text(item.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text("Dmg: ${item.damage} | ${item.description}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailScreen(item: item)));
                  },
                  trailing: IconButton(
                    icon: Icon(
                      isEquipped ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isEquipped ? AppColors.accent : Colors.white24,
                    ),
                    onPressed: () => _toggleEquip(item),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
