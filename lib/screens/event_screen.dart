import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../models/item.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class EventScreen extends StatefulWidget {
  final PlayerStats stats;
  final Function(PlayerStats) onStatsChanged;
  final Function(List<Item>) onLootObtained;

  const EventScreen({
    super.key,
    required this.stats,
    required this.onStatsChanged,
    required this.onLootObtained,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late String _eventTitle;
  late String _eventDescription;
  late IconData _eventIcon;
  late Color _eventColor;
  late List<Widget> _actions;
  
  bool _resolved = false;
  String _resultText = "";

  @override
  void initState() {
    super.initState();
    _generateEvent();
  }

  void _generateEvent() {
    final rand = Random();
    int type = rand.nextInt(3); // 0: Chest, 1: Fountain, 2: Altar
    int level = widget.stats.currentFloor;

    if (type == 0) {
      _eventTitle = "Treasure Chest";
      _eventDescription = "You found a locked chest in the corner. It seems ancient.";
      _eventIcon = Icons.inventory_2;
      _eventColor = Colors.amber;
      _actions = [
        _buildActionButton("Open It", _openChest),
        _buildActionButton("Leave", _leave),
      ];
    } else if (type == 1) {
      _eventTitle = "Healing Fountain";
      _eventDescription = "A fountain with glowing blue water stands before you.";
      _eventIcon = Icons.water_drop;
      _eventColor = Colors.blue;
      _actions = [
        _buildActionButton("Drink Water", _drinkFountain),
        _buildActionButton("Leave", _leave),
      ];
    } else {
      int goldReward = 50 + (level * 5);
      _eventTitle = "Dark Altar";
      _eventDescription = "An ominous altar demands a sacrifice. 'Blood for Gold' is carved on it.";
      _eventIcon = Icons.whatshot;
      _eventColor = Colors.red;
      _actions = [
        _buildActionButton("Sacrifice HP (-20 HP, +$goldReward Gold)", _sacrifice),
        _buildActionButton("Leave", _leave),
      ];
    }
  }

  void _openChest() {
    setState(() {
      _resolved = true;
      final rand = Random();
      int level = widget.stats.currentFloor;
      
      if (rand.nextBool()) {
        // Gold
        int gold = 20 + (level * 5) + rand.nextInt(30);
        widget.stats.gold += gold;
        _resultText = "You found $gold Gold!";
        widget.onStatsChanged(widget.stats);
      } else {
        // Item
        final item = Item(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: "Ancient Relic Lv.$level",
          description: "Found in a chest.",
          damage: 15 + level,
          iconData: "💎",
        );
        widget.onLootObtained([item]);
        _resultText = "You found an Ancient Relic!";
      }
    });
  }

  void _drinkFountain() {
    setState(() {
      _resolved = true;
      int heal = 30;
      widget.stats.hp = (widget.stats.hp + heal).clamp(0, widget.stats.maxHp);
      widget.onStatsChanged(widget.stats);
      _resultText = "You feel refreshed! Recovered $heal HP.";
    });
  }

  void _sacrifice() {
    setState(() {
      _resolved = true;
      if (widget.stats.hp > 20) {
        widget.stats.hp -= 20;
        int goldGain = 50 + (widget.stats.currentFloor * 5);
        widget.stats.gold += goldGain;
        widget.onStatsChanged(widget.stats);
        _resultText = "The altar glows red. You gained $goldGain Gold.";
      } else {
        _resultText = "You don't have enough HP to sacrifice!";
      }
    });
  }

  void _leave() {
    setState(() {
      _resolved = true;
      _resultText = "You walked away safely.";
    });
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _eventColor.withOpacity(0.8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.towerBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Just leave without resolving? Maybe should force resolve.
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(_eventIcon, size: 100, color: _eventColor),
              const SizedBox(height: 30),
              Text(
                _eventTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _eventColor,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 20),
              GlassContainer(
                padding: const EdgeInsets.all(24),
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
                opacity: 0.3,
                child: Text(
                  _eventDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 40),
              if (!_resolved) ..._actions,
              if (_resolved) ...[
                Text(
                  _resultText,
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true); // Return true as "completed"
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Continue"),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
  }
}
