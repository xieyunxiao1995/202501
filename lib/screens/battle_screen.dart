import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../models/item.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/flip_card.dart';

class BattleScreen extends StatefulWidget {
  final PlayerStats stats;
  final List<Item> deck;
  final Function(PlayerStats) onStatsChanged;
  final Function(List<Item>) onLootObtained;
  final int floor;
  final bool isElite;

  const BattleScreen({
    super.key,
    required this.stats,
    required this.deck,
    required this.onStatsChanged,
    required this.onLootObtained,
    required this.floor,
    this.isElite = false,
  });

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with SingleTickerProviderStateMixin {
  // Battle State
  List<Item> _cards = [];
  List<bool> _isRevealed = [];
  List<bool> _isMatched = [];
  int? _firstCardIndex;
  bool _isProcessing = false;

  // Enemy State
  int _enemyMaxHp = 100;
  int _enemyHp = 100;
  String _enemyName = 'Slime';
  String _enemyIcon = '👾';

  // Animation State
  AnimationController? _shakeController;
  Animation<double>? _shakeAnimation;
  Color _enemyColor = Colors.white;

  // Logs
  final List<String> _battleLog = [];

  // FX State
  bool _showHitFlash = false;
  Color _flashColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _initializeBattle();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _shakeController!, curve: Curves.elasticIn),
    );

    _shakeController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController!.reset();
        if (mounted) {
          setState(() {
            _enemyColor = Colors.white;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _shakeController?.dispose();
    super.dispose();
  }

  void _triggerEnemyHitEffect() {
    _shakeController?.forward(from: 0);
    setState(() {
      _enemyColor = Colors.red;
    });
  }

  void _initializeBattle() {
    // 1. Setup Enemy
    int level = widget.floor;
    bool isBoss = level % 10 == 0;

    // Difficulty Scaling
    int baseHp = 50 + (level * 20);
    if (isBoss) baseHp = (baseHp * 1.5).toInt();
    if (widget.isElite) baseHp = (baseHp * 1.2).toInt();

    _enemyMaxHp = baseHp;
    _enemyHp = _enemyMaxHp;

    final enemyData = _getEnemyData(level);
    _enemyName = widget.isElite
        ? "Elite ${enemyData['name']}"
        : enemyData['name']!;
    _enemyIcon = enemyData['icon']!;

    // 2. Setup Cards
    List<Item> pairs = [];
    if (widget.deck.isEmpty) {
      pairs = List.generate(
        8,
        (i) => Item(
          id: 'dummy_$i',
          name: 'Void',
          description: '',
          damage: 5,
          iconData: '❓',
        ),
      );
    } else {
      List<Item> source = widget.deck;
      while (pairs.length < 8) {
        for (var item in source) {
          if (pairs.length < 8) pairs.add(item);
        }
      }
    }

    _cards = [...pairs, ...pairs];
    _cards.shuffle();

    _isRevealed = List.filled(16, false);
    _isMatched = List.filled(16, false);
    _firstCardIndex = null;
    _isProcessing = false;
    _battleLog.clear();
    _battleLog.add("Floor $level Started! A wild $_enemyName appears!");
  }

  void _triggerFlash(Color color) {
    setState(() {
      _showHitFlash = true;
      _flashColor = color;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _showHitFlash = false;
        });
      }
    });
  }

  Map<String, String> _getEnemyData(int level) {
    // Boss Logic (Every 10 floors)
    if (level % 10 == 0) {
      int bossIndex = (level ~/ 10) - 1;
      const bosses = [
        {'name': 'Giant King', 'icon': '👑'},
        {'name': 'Elder Dragon', 'icon': '🐲'},
        {'name': 'Demon Lord', 'icon': '😈'},
        {'name': 'Void God', 'icon': '🌌'},
        {'name': 'Chaos Engine', 'icon': '⚙️'},
        {'name': 'Eldritch Horror', 'icon': '🦑'},
        {'name': 'Time Keeper', 'icon': '⏳'},
        {'name': 'World Eater', 'icon': '🪐'},
      ];
      return bosses[bossIndex % bosses.length];
    }

    // Normal Enemy Tiers
    List<Map<String, String>> pool;
    if (level < 10) {
      pool = [
        {'name': 'Slime', 'icon': '👾'},
        {'name': 'Rat', 'icon': '🐀'},
        {'name': 'Bat', 'icon': '🦇'},
        {'name': 'Spider', 'icon': '🕷️'},
        {'name': 'Goblin', 'icon': '👺'},
      ];
    } else if (level < 20) {
      pool = [
        {'name': 'Wolf', 'icon': '🐺'},
        {'name': 'Skeleton', 'icon': '💀'},
        {'name': 'Orc', 'icon': '👹'},
        {'name': 'Bandit', 'icon': '🦹'},
        {'name': 'Ghost', 'icon': '👻'},
      ];
    } else if (level < 30) {
      pool = [
        {'name': 'Golem', 'icon': '🗿'},
        {'name': 'Troll', 'icon': '🧟'},
        {'name': 'Griffin', 'icon': '🦅'},
        {'name': 'Elemental', 'icon': '�'},
        {'name': 'Minotaur', 'icon': '�'},
      ];
    } else {
      pool = [
        {'name': 'Dragon', 'icon': '🐉'},
        {'name': 'Demon', 'icon': '👿'},
        {'name': 'Vampire', 'icon': '🧛'},
        {'name': 'Lich', 'icon': '🧙'},
        {'name': 'Hydra', 'icon': '🐍'},
        {'name': 'Titan', 'icon': '🗿'},
        {'name': 'Beholder', 'icon': '👁️'},
      ];
    }

    return pool[Random().nextInt(pool.length)];
  }

  void _onCardTap(int index) {
    if (_isProcessing || _isRevealed[index] || _isMatched[index]) return;

    setState(() {
      _isRevealed[index] = true;
    });

    if (_firstCardIndex == null) {
      _firstCardIndex = index;
    } else {
      _isProcessing = true;
      _handleMatch(_firstCardIndex!, index);
    }
  }

  void _handleMatch(int index1, int index2) {
    final card1 = _cards[index1];
    final card2 = _cards[index2];

    // Check if cards match (same instance or same ID)
    if (card1 == card2 || card1.id == card2.id) {
      // Match found!
      setState(() {
        _isMatched[index1] = true;
        _isMatched[index2] = true;
        _firstCardIndex = null;
        _isProcessing = false;
      });

      // Effect Logic
      if (card1.damage < 0) {
        // Healing Item (e.g. Potion)
        int healAmount = card1.damage.abs();
        _healPlayer(healAmount);
        _addLog("Used [${card1.name}]! Healed $healAmount HP.");
      } else {
        // Attack Item
        _addLog("Matched [${card1.name}]! Dealt ${card1.damage} damage.");
        _damageEnemy(card1.damage);
        _triggerEnemyHitEffect(); // Shake and Red Flash
        _triggerFlash(Colors.white.withOpacity(0.5)); // Flash enemy white
      }

      _checkWin();
      _checkReshuffleNeeded();
    } else {
      // No match
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _isRevealed[index1] = false;
            _isRevealed[index2] = false;
            _firstCardIndex = null;
            _isProcessing = false;
          });
          // Enemy attacks on mismatch
          _enemyAttack();
        }
      });
    }
  }

  void _checkReshuffleNeeded() {
    // Check if all cards are matched
    if (_isMatched.every((m) => m)) {
      if (_enemyHp > 0) {
        // Deck exhausted but enemy still alive -> Reshuffle!
        _addLog("Deck exhausted! Reshuffling...");

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              // Keep enemy state, reset cards
              _cards.shuffle();
              _isRevealed = List.filled(16, false);
              _isMatched = List.filled(16, false);
              _firstCardIndex = null;
              _isProcessing = false;
            });
            _enemyAttack(); // Penalty for running out of cards? Or just free turn for enemy? Let's make enemy attack to keep pressure.
          }
        });
      }
    }
  }

  void _healPlayer(int amount) {
    setState(() {
      widget.stats.hp = (widget.stats.hp + amount).clamp(0, widget.stats.maxHp);
    });
    widget.onStatsChanged(widget.stats);
  }

  void _damageEnemy(int damage) {
    setState(() {
      _enemyHp -= damage;
      if (_enemyHp < 0) _enemyHp = 0;
    });
  }

  void _enemyAttack() {
    final random = Random();

    bool isBoss = widget.floor % 10 == 0;
    int baseDamage = 5 + (widget.floor * 1.5).toInt();
    if (isBoss) baseDamage = (baseDamage * 1.3).toInt();
    if (widget.isElite) baseDamage = (baseDamage * 1.2).toInt();

    int variance = random.nextInt(5) - 2; // -2 to +2
    int damage = (baseDamage + variance).clamp(1, 999);

    setState(() {
      widget.stats.hp = (widget.stats.hp - damage).clamp(0, widget.stats.maxHp);
    });
    widget.onStatsChanged(widget.stats);

    _addLog("$_enemyName attacks! Dealt $damage damage.");
    _triggerFlash(Colors.red.withOpacity(0.5)); // Flash screen red

    if (widget.stats.hp <= 0) {
      _gameOver();
    }
  }

  void _checkWin() {
    if (_enemyHp <= 0) {
      _addLog("Victory! Enemy defeated.");
      // Generate Loot
      final loot = Item(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Essence of $_enemyName',
        description: 'Material from floor ${widget.floor}',
        damage: 5 + widget.floor,
        iconData: _enemyIcon,
      );

      // Gold Reward
      int goldReward = 10 + (widget.floor * 2);
      if (widget.isElite) goldReward = (goldReward * 1.5).toInt();

      widget.stats.gold += goldReward;
      widget.onStatsChanged(widget.stats);

      widget.onLootObtained([loot]);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          backgroundColor: AppColors.towerBg,
          title: const Text(
            'Victory!',
            style: TextStyle(color: AppColors.accent),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You defeated $_enemyName!',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(loot.iconData, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loot.name,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Damage: ${loot.damage}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("💰", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Text(
                    "+$goldReward Gold",
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(c); // Close Dialog
                Navigator.pop(context, true); // Return to Map with Win
              },
              child: const Text('Complete Floor'),
            ),
          ],
        ),
      );
    }
  }

  void _gameOver() {
    widget.stats.deaths++;
    widget.onStatsChanged(widget.stats);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.towerBg,
        title: const Text(
          'Game Over',
          style: TextStyle(color: AppColors.danger),
        ),
        content: const Text(
          'You have perished in the tower...',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c); // Close Dialog
              Navigator.pop(context, false); // Return to Map with Loss
            },
            child: const Text('Return to Entrance'),
          ),
        ],
      ),
    );
  }

  void _addLog(String msg) {
    setState(() {
      _battleLog.insert(0, msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.towerBg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Floor ${widget.floor}",
              style: const TextStyle(fontFamily: 'serif'),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              // Top HUD
              GlassContainer(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
                opacity: 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Enemy Stats
                    if (_shakeAnimation != null)
                      AnimatedBuilder(
                        animation: _shakeAnimation!,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              sin(_shakeAnimation!.value * 3.14 * 10) * 10,
                              0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _enemyIcon,
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: _enemyColor == Colors.red
                                        ? Colors.red
                                        : null,
                                    shadows: _enemyColor == Colors.red
                                        ? [
                                            const BoxShadow(
                                              color: Colors.red,
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _enemyName,
                                  style: TextStyle(
                                    color: _enemyColor == Colors.red
                                        ? Colors.red
                                        : AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    value: _enemyMaxHp > 0
                                        ? _enemyHp / _enemyMaxHp
                                        : 0,
                                    color: Colors.orange,
                                    backgroundColor: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  "$_enemyHp / $_enemyMaxHp",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    // VS
                    const Text(
                      "VS",
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    // Player Stats
                    Column(
                      children: [
                        const Text("🧙‍♂️ You", style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text(
                          "HP",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 100,
                          child: LinearProgressIndicator(
                            value: widget.stats.hp / widget.stats.maxHp,
                            color: Colors.red,
                            backgroundColor: Colors.grey[800],
                          ),
                        ),
                        Text(
                          "${widget.stats.hp} / ${widget.stats.maxHp}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Battle Grid
              Expanded(
                flex: 3,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate optimal grid size to prevent overflow
                    // We have 4 columns.
                    double width = constraints.maxWidth;
                    double itemWidth = (width - (3 * 8)) / 4;
                    // We want square cards ideally, or slightly rectangular
                    double itemHeight = itemWidth * 1.2;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // Grid fits in screen
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: itemWidth / itemHeight,
                        ),
                        itemCount: 16,
                        itemBuilder: (context, index) {
                          if (index >= _cards.length)
                            return const SizedBox.shrink(); // Safety
                          final item = _cards[index];
                          final isRevealed =
                              _isRevealed[index] || _isMatched[index];

                          return FlipCard(
                            isRevealed: isRevealed,
                            onTap: () => _onCardTap(index),
                            front: GlassContainer(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.accent,
                              opacity: 0.2,
                              border: Border.all(color: AppColors.accent),
                              child: Center(
                                child: Text(
                                  item.iconData,
                                  style: TextStyle(fontSize: itemWidth * 0.5),
                                ),
                              ),
                            ),
                            back: GlassContainer(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              opacity: 0.1,
                              child: const Center(
                                child: Icon(
                                  Icons.help_outline,
                                  color: Colors.white24,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // Battle Log
              Expanded(
                flex: 1,
                child: GlassContainer(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                  opacity: 0.5,
                  child: ListView.builder(
                    itemCount: _battleLog.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _battleLog[index],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // FX Overlay
        IgnorePointer(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: _showHitFlash ? _flashColor : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
