import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../models/item.dart';
import '../services/storage_service.dart';
import '../constants/colors.dart';
import 'tower_screen.dart';
import 'alchemy_screen.dart';
import 'grimoire_screen.dart';
import 'system_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  PlayerStats _stats = PlayerStats();
  List<Item> _inventory = [];
  List<Item> _deck = [];
  
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await _storage.loadPlayerStats();
    final inventory = await _storage.loadInventory();
    final deck = await _storage.loadDeck();
    
    // Initial setup
    if (inventory.isEmpty && deck.isEmpty) {
       final starters = [
         Item(id: '1', name: 'Fire', description: 'Burns', damage: 10, iconData: '🔥'),
         Item(id: '2', name: 'Water', description: 'Wet', damage: 10, iconData: '💧'),
         Item(id: '3', name: 'Earth', description: 'Hard', damage: 10, iconData: '🪨'),
         Item(id: '4', name: 'Air', description: 'Blows', damage: 10, iconData: '💨'),
         Item(id: '5', name: 'Sword', description: 'Sharp', damage: 15, iconData: '⚔️'),
         Item(id: '6', name: 'Shield', description: 'Block', damage: 5, iconData: '🛡️'),
         Item(id: '7', name: 'Potion', description: 'Heal', damage: -10, iconData: '🧪'),
         Item(id: '8', name: 'Gold', description: 'Rich', damage: 0, iconData: '💰'),
       ];
       inventory.addAll(starters);
       deck.addAll(starters);
       
       await _storage.saveInventory(inventory);
       await _storage.saveDeck(deck);
    } else if (deck.isEmpty && inventory.isNotEmpty) {
        // Auto fill deck from inventory if possible
        deck.addAll(inventory.take(8));
        await _storage.saveDeck(deck);
    }

    if (mounted) {
      setState(() {
        _stats = stats;
        _inventory = inventory;
        _deck = deck;
      });
    }
  }

  void _onItemSynthesized(Item newItem) {
    setState(() {
      _inventory.add(newItem);
    });
    _storage.saveInventory(_inventory);
  }

  void _onDeckChanged(List<Item> newDeck) {
    setState(() {
      _deck = newDeck;
    });
    _storage.saveDeck(_deck);
  }

  void _onStatsChanged(PlayerStats newStats) {
    setState(() {
      _stats = newStats;
    });
    _storage.savePlayerStats(_stats);
  }
  
  void _onLootObtained(List<Item> loot) {
      setState(() {
          _inventory.addAll(loot);
      });
      _storage.saveInventory(_inventory);
  }

  void _onInventoryChanged(List<Item> newInventory) {
    setState(() {
      _inventory = newInventory;
    });
    _storage.saveInventory(_inventory);
  }

  Future<void> _onReset() async {
    await _storage.clearData();
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TowerScreen(
        stats: _stats, 
        deck: _deck,
        inventory: _inventory,
        onStatsChanged: _onStatsChanged,
        onLootObtained: _onLootObtained,
        onInventoryChanged: _onInventoryChanged,
      ),
      AlchemyScreen(
        inventory: _inventory,
        onItemSynthesized: _onItemSynthesized,
      ),
      GrimoireScreen(
        inventory: _inventory,
        deck: _deck,
        onDeckChanged: _onDeckChanged,
        onInventoryChanged: _onInventoryChanged,
      ),
      SystemScreen(stats: _stats, onReset: _onReset),
    ];

    Color bgColor;
    switch (_currentIndex) {
      case 0: bgColor = AppColors.towerBg; break;
      case 1: bgColor = AppColors.labBg; break;
      case 2: bgColor = AppColors.grimoireBg; break;
      case 3: bgColor = AppColors.systemBg; break;
      default: bgColor = AppColors.towerBg;
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.towerBg, AppColors.labBg], // Subtle gradient
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black.withOpacity(0.9),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black.withOpacity(0.5),
          selectedItemColor: AppColors.accent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.castle), label: 'Tower'),
            BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Alchemy'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Grimoire'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'System'),
          ],
        ),
      ),
    );
  }
}
