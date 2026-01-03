import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../models/item.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';
import 'battle_screen.dart';
import 'shop_screen.dart';
import 'event_screen.dart';

class TowerScreen extends StatefulWidget {
  final PlayerStats stats;
  final List<Item> deck;
  final List<Item> inventory;
  final Function(PlayerStats) onStatsChanged;
  final Function(List<Item>) onLootObtained;
  final Function(List<Item>) onInventoryChanged;

  const TowerScreen({
    super.key,
    required this.stats,
    required this.deck,
    required this.inventory,
    required this.onStatsChanged,
    required this.onLootObtained,
    required this.onInventoryChanged,
  });

  @override
  State<TowerScreen> createState() => _TowerScreenState();
}

class _TowerScreenState extends State<TowerScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to bottom (current floor) initially
    _scrollToCurrentFloor();
  }

  bool _isBossFloor(int floor) => floor % 10 == 0;
  bool _isShopFloor(int floor) => floor % 3 == 0 && !_isBossFloor(floor);
  bool _isEventFloor(int floor) =>
      floor % 4 == 0 && !_isBossFloor(floor) && !_isShopFloor(floor);
  bool _isEliteFloor(int floor) =>
      floor % 5 == 0 &&
      !_isBossFloor(floor) &&
      !_isShopFloor(floor) &&
      !_isEventFloor(floor);

  void _scrollToCurrentFloor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Item height is ~96.0 (80 height + 16 vertical padding)
        double targetOffset = (widget.stats.currentFloor - 1) * 96.0;
        // Ensure we don't scroll past bounds
        double maxScroll = _scrollController.position.maxScrollExtent;

        _scrollController.animateTo(
          targetOffset.clamp(0, maxScroll),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _enterFloor(int floor) async {
    if (floor != widget.stats.currentFloor) return;

    bool? result = false;
    bool isElite = _isEliteFloor(floor);

    if (_isBossFloor(floor)) {
      // Boss Battle
      result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => BattleScreen(
            stats: widget.stats,
            deck: widget.deck,
            floor: floor,
            onStatsChanged: widget.onStatsChanged,
            onLootObtained: widget.onLootObtained,
          ),
        ),
      );
    } else if (_isShopFloor(floor)) {
      // Enter Shop
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShopScreen(
            stats: widget.stats,
            inventory: widget.inventory,
            deck: widget.deck,
            onStatsChanged: widget.onStatsChanged,
            onInventoryChanged: widget.onInventoryChanged,
          ),
        ),
      );
      result = true;
    } else if (_isEventFloor(floor)) {
      // Enter Event
      result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => EventScreen(
            stats: widget.stats,
            onStatsChanged: widget.onStatsChanged,
            onLootObtained: widget.onLootObtained,
          ),
        ),
      );
    } else {
      // Normal or Elite Battle
      result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => BattleScreen(
            stats: widget.stats,
            deck: widget.deck,
            floor: floor,
            isElite: isElite,
            onStatsChanged: widget.onStatsChanged,
            onLootObtained: widget.onLootObtained,
          ),
        ),
      );
    }

    if (result == true) {
      // Victory / Progress
      widget.stats.currentFloor++;
      widget.onStatsChanged(widget.stats);
      setState(() {});
      _scrollToCurrentFloor();
    } else if (result == false) {
      // Defeat
      widget.stats.hp = widget.stats.maxHp;
      widget.stats.currentFloor = 1;
      widget.onStatsChanged(widget.stats);
      setState(() {});
      _scrollToCurrentFloor();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate a list of floors. Show up to currentFloor + 19 (Total 20 floors ahead)
    int maxVisibleFloor = widget.stats.currentFloor + 19;

    return Column(
      children: [
        // Header
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "The Tower",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'serif',
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Text(
          "Current Floor: ${widget.stats.currentFloor} | Gold: ${widget.stats.gold}",
          style: const TextStyle(color: Colors.white54),
        ),
        const SizedBox(height: 20),

        // Map List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true, // Floor 1 at bottom
            itemCount: maxVisibleFloor,
            itemBuilder: (context, index) {
              final floor = index + 1;
              final isCurrent = floor == widget.stats.currentFloor;
              final isLocked = floor > widget.stats.currentFloor;
              final isCleared = floor < widget.stats.currentFloor;

              final isShop = _isShopFloor(floor);
              final isBoss = _isBossFloor(floor);
              final isEvent = _isEventFloor(floor);
              final isElite = _isEliteFloor(floor);

              IconData floorIcon = Icons.flash_on;
              Color floorColor = AppColors.accent;
              String floorTitle = "Floor $floor";

              if (isShop) {
                floorIcon = Icons.store;
                floorColor = Colors.amber;
                floorTitle = "Merchant Floor";
              } else if (isBoss) {
                floorIcon = Icons.gavel;
                floorColor = Colors.red;
                floorTitle = "BOSS Floor $floor";
              } else if (isEvent) {
                floorIcon = Icons.question_mark;
                floorColor = Colors.purpleAccent;
                floorTitle = "Mystery Floor";
              } else if (isElite) {
                floorIcon = Icons.security;
                floorColor = Colors.orangeAccent;
                floorTitle = "Elite Floor $floor";
              }

              return GestureDetector(
                onTap: isLocked ? null : () => _enterFloor(floor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 8,
                  ),
                  child: GlassContainer(
                    height: 80,
                    borderRadius: BorderRadius.circular(16),
                    color: isCurrent
                        ? floorColor
                        : (isLocked ? Colors.grey : Colors.green),
                    opacity: isCurrent ? 0.3 : 0.1,
                    border: isCurrent
                        ? Border.all(color: floorColor, width: 2)
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLocked)
                          const Icon(Icons.lock, color: Colors.white24),
                        if (isCleared)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (isCurrent) Icon(floorIcon, color: floorColor),
                        const SizedBox(width: 10),
                        Text(
                          floorTitle,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isLocked ? Colors.white24 : Colors.white,
                          ),
                        ),
                      ],
                    ),
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
