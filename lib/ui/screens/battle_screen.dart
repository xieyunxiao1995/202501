import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import '../../models/role.dart';
import '../../models/item.dart';
import '../widgets/background_scaffold.dart';
import 'battle_result_screen.dart';

// Battle Phase Enum
enum BattlePhase { preparation, battle, victory, defeat }

// Runtime Battle Unit Wrapper
class BattleUnit {
  final String id;
  final Role role;
  final bool isPlayer;
  int hp;
  int maxHp;
  int attack;
  int defense;
  int speed;

  // Visual state
  bool isHit = false;
  bool isAttacking = false;

  BattleUnit({
    required this.id,
    required this.role,
    required this.isPlayer,
    int? overrideHp,
    int? overrideAttack,
  }) : hp = overrideHp ?? role.baseHp,
       maxHp = overrideHp ?? role.baseHp,
       attack = overrideAttack ?? role.baseAttack,
       defense = role.baseDefense,
       speed = role.baseSpeed;

  bool get isDead => hp <= 0;
}

class BattleScreen extends StatefulWidget {
  final GameService gameService;
  final String? enemyName;
  final int? initialHp;

  const BattleScreen({
    super.key,
    required this.gameService,
    this.enemyName,
    this.initialHp,
  });

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with TickerProviderStateMixin {
  BattlePhase _phase = BattlePhase.preparation;

  // 3x3 Grid: Indices 0-8.
  final List<BattleUnit?> _playerFormation = List.filled(9, null);
  final List<BattleUnit?> _enemyFormation = List.filled(9, null);

  List<Role> _availableRoles = [];
  String _battleLog = '请布置你的阵型...';
  int _turnCount = 0;

  // Floating Texts
  List<FloatingText> _floatingTexts = [];

  @override
  void initState() {
    super.initState();
    _initBattle();
  }

  void _initBattle() {
    // 1. Load Player Roles
    final player = widget.gameService.player;
    if (player != null) {
      _availableRoles = allRoles
          .where((r) => player.ownedRoles.contains(r.id))
          .toList();

      bool loadedFromSave = false;
      if (player.formation.isNotEmpty) {
        player.formation.forEach((index, roleId) {
          if (index >= 0 && index < 9) {
            try {
              final role = _availableRoles.firstWhere((r) => r.id == roleId);
              _playerFormation[index] = BattleUnit(
                id: 'p_${role.id}_$index',
                role: role,
                isPlayer: true,
              );
              loadedFromSave = true;
            } catch (e) {
              // Role not found
            }
          }
        });
      }

      if (!loadedFromSave) {
        List<int> prioritySlots = [4, 3, 5, 1, 0, 2, 7, 6, 8];
        for (int i = 0; i < min(_availableRoles.length, 5); i++) {
          if (i < prioritySlots.length) {
            int targetSlot = prioritySlots[i];
            _playerFormation[targetSlot] = BattleUnit(
              id: 'p_${_availableRoles[i].id}_$targetSlot',
              role: _availableRoles[i],
              isPlayer: true,
            );
          }
        }
      }
    }

    // 2. Setup Enemy Formation
    bool isBoss = widget.enemyName == '龙';
    if (isBoss) {
      final bossRole = allRoles.firstWhere(
        (r) => r.id == 'demon_lord',
        orElse: () => allRoles.first,
      );
      _enemyFormation[4] = BattleUnit(
        id: 'boss',
        role: bossRole,
        isPlayer: false,
        overrideHp: widget.initialHp ?? 500,
        overrideAttack: 50,
      );
    } else {
      final minionRole = allRoles.firstWhere(
        (r) => r.id == 'ox_demon',
        orElse: () => allRoles.first,
      );
      int count = 1 + Random().nextInt(3);
      List<int> slots = [4, 3, 5];
      for (int i = 0; i < count; i++) {
        _enemyFormation[slots[i]] = BattleUnit(
          id: 'enemy_$i',
          role: minionRole,
          isPlayer: false,
          overrideHp: widget.initialHp ?? 100,
          overrideAttack: 20,
        );
      }
    }
  }

  // --- Logic ---
  void _toggleRoleInFormation(Role role) {
    if (_phase != BattlePhase.preparation) return;

    int existingIndex = -1;
    for (int i = 0; i < 9; i++) {
      if (_playerFormation[i]?.role.id == role.id) {
        existingIndex = i;
        break;
      }
    }

    setState(() {
      if (existingIndex != -1) {
        _playerFormation[existingIndex] = null;
      } else {
        // Check limit
        int currentCount = _playerFormation.where((u) => u != null).length;
        if (currentCount >= 5) {
          _showToast('最多只能上阵5名英雄');
          return;
        }

        int emptyIndex = -1;
        for (int i = 0; i < 9; i++) {
          if (_playerFormation[i] == null) {
            emptyIndex = i;
            break;
          }
        }
        if (emptyIndex != -1) {
          _playerFormation[emptyIndex] = BattleUnit(
            id: 'p_${role.id}_${DateTime.now().millisecondsSinceEpoch}',
            role: role,
            isPlayer: true,
          );
        } else {
          _showToast('阵型已满');
        }
      }
    });
  }

  void _startBattle() {
    if (_playerFormation.every((u) => u == null)) {
      _showToast('请至少上阵一名英雄');
      return;
    }

    final newFormation = <int, String>{};
    for (int i = 0; i < 9; i++) {
      if (_playerFormation[i] != null) {
        newFormation[i] = _playerFormation[i]!.role.id;
      }
    }
    if (widget.gameService.player != null) {
      widget.gameService.player!.formation = newFormation;
      widget.gameService.saveGame();
    }

    setState(() {
      _phase = BattlePhase.battle;
      _battleLog = '战斗开始！';
      _turnCount = 0;
    });

    _nextTurn();
  }

  Future<void> _nextTurn() async {
    if (_phase != BattlePhase.battle) return;

    _turnCount++;
    setState(() {
      _battleLog = '第 $_turnCount 回合';
    });

    await _executeSideAttacks(true);
    if (_checkGameOver()) return;

    await Future.delayed(const Duration(milliseconds: 500));
    await _executeSideAttacks(false);
    if (_checkGameOver()) return;

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (_phase == BattlePhase.battle) {
        _nextTurn();
      }
    });
  }

  Future<void> _executeSideAttacks(bool isPlayerSide) async {
    final attackers = isPlayerSide ? _playerFormation : _enemyFormation;
    final defenders = isPlayerSide ? _enemyFormation : _playerFormation;

    for (int i = 0; i < 9; i++) {
      if (_phase != BattlePhase.battle) return;

      final unit = attackers[i];
      if (unit != null && !unit.isDead) {
        final targetIndex = _findTarget(defenders);
        if (targetIndex != -1) {
          final target = defenders[targetIndex]!;

          setState(() {
            unit.isAttacking = true;
          });
          await Future.delayed(const Duration(milliseconds: 300));

          _performAttack(unit, target);

          setState(() {
            unit.isAttacking = false;
          });
          await Future.delayed(const Duration(milliseconds: 200));

          if (_checkGameOver()) return;
        }
      }
    }
  }

  int _findTarget(List<BattleUnit?> formation) {
    for (int i = 0; i < 9; i++) {
      if (formation[i] != null && !formation[i]!.isDead) {
        return i;
      }
    }
    return -1;
  }

  void _performAttack(BattleUnit attacker, BattleUnit target) {
    final damage = max(1, attacker.attack - (target.defense ~/ 2));
    bool isCrit = Random().nextDouble() < 0.2;
    final finalDamage = isCrit ? (damage * 1.5).toInt() : damage;

    setState(() {
      target.hp -= finalDamage;
      target.isHit = true;
      _addFloatingText(
        '-$finalDamage${isCrit ? "!" : ""}',
        target.isPlayer ? BattleTarget.player : BattleTarget.enemy,
        isCrit ? Colors.yellow : Colors.white,
      );
      _battleLog =
          '${attacker.role.name} 攻击 ${target.role.name} 造成 $finalDamage 伤害';
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          target.isHit = false;
        });
      }
    });
  }

  bool _checkGameOver() {
    bool playerAlive = _playerFormation.any((u) => u != null && !u.isDead);
    bool enemyAlive = _enemyFormation.any((u) => u != null && !u.isDead);

    if (!enemyAlive) {
      _phase = BattlePhase.victory;
      _handleVictory();
      return true;
    }
    if (!playerAlive) {
      _phase = BattlePhase.defeat;
      _showToast('战斗失败...');
      Navigator.pop(context);
      return true;
    }
    return false;
  }

  void _handleVictory() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        widget.gameService.gainInk(20);
        bool leveledUp = widget.gameService.gainExp(50);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BattleResultScreen(
              isVictory: true,
              gameService: widget.gameService,
              inkReward: 20,
              xpReward: 50,
              leveledUp: leveledUp,
            ),
          ),
        );
      }
    });
  }

  void _addFloatingText(String text, BattleTarget target, Color color) {
    final id =
        DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
    setState(() {
      _floatingTexts.add(
        FloatingText(id: id, text: text, target: target, color: color),
      );
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _floatingTexts.removeWhere((ft) => ft.id == id);
        });
      }
    });
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  int _calculateCombatPower(bool isPlayer) {
    final formation = isPlayer ? _playerFormation : _enemyFormation;
    int total = 0;
    for (var unit in formation) {
      if (unit != null) {
        // Simple CP calculation: Attack * 5 + HP + Defense * 3 + Speed * 2
        total +=
            (unit.attack * 5) +
            unit.maxHp +
            (unit.defense * 3) +
            (unit.speed * 2);
      }
    }
    return total > 0 ? total : (isPlayer ? 1000 : 500); // Default if empty
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundImage: AppAssets.bgAncientStoneCircle,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Semi-transparent overlay to make characters pop
          Container(color: Colors.black.withOpacity(0.1)),

          Column(
            children: [
              // 1. Custom Top Bar (Combat Power)
              _buildTopBar(),

              // 2. Main Battle Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Enemy Formation
                          Expanded(
                            flex: 4,
                            child: _buildFormationGrid(
                              _enemyFormation,
                              isPlayer: false,
                            ),
                          ),

                          // Gap
                          SizedBox(height: 10),

                          // Player Formation
                          Expanded(
                            flex: 4,
                            child: _buildFormationGrid(
                              _playerFormation,
                              isPlayer: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Bottom Control Area
              _buildBottomPanel(),
            ],
          ),

          // Overlays (Floating Text)
          ..._floatingTexts.map((ft) {
            double randomOffset = (Random().nextInt(40) - 20).toDouble();

            return Positioned(
              top: ft.target == BattleTarget.enemy
                  ? MediaQuery.of(context).size.height * 0.25
                  : null,
              bottom: ft.target == BattleTarget.player
                  ? MediaQuery.of(context).size.height * 0.35
                  : null,
              left: (MediaQuery.of(context).size.width / 2) - 20 + randomOffset,
              child:
                  Text(
                        ft.text,
                        style: GoogleFonts.fredoka(
                          color: ft.color,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(offset: Offset(-1, -1), color: Colors.black),
                            Shadow(offset: Offset(1, -1), color: Colors.black),
                            Shadow(offset: Offset(1, 1), color: Colors.black),
                            Shadow(offset: Offset(-1, 1), color: Colors.black),
                          ],
                        ),
                      )
                      .animate()
                      .scale(duration: 200.ms, curve: Curves.easeOutBack)
                      .moveY(begin: 0, end: -80, duration: 800.ms)
                      .fadeOut(delay: 400.ms, duration: 400.ms),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    // Custom VS Banner
    final playerAvatar =
        _playerFormation.where((u) => u != null).firstOrNull?.role.assetPath ??
        'assets/role/Bamboo_Swordman_3D.png';
    final enemyAvatar =
        _enemyFormation.where((u) => u != null).firstOrNull?.role.assetPath ??
        'assets/role/Ox_Demon.png';

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          // Background Bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              // Gradient Teal/Blue background
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4DB6AC), // Teal 300
                  Color(0xFF009688), // Teal 500
                  Color(0xFF4DB6AC),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFFFD700),
                  width: 1.5,
                ), // Brighter Gold
              ),
            ),
          ),

          // Content
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Player
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: AssetImage(playerAvatar),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "修行者",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              shadows: [
                                Shadow(color: Colors.black45, blurRadius: 2),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              // Cross Swords Icon for Combat Power
                              Transform.rotate(
                                angle:
                                    pi / 4, // Rotate slightly for dynamic feel
                                child: Icon(
                                  Icons.colorize, // Looks a bit like a sword
                                  size: 14,
                                  color: Color(0xFFFFD54F),
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                "${_calculateCombatPower(true)}",
                                style: GoogleFonts.russoOne(
                                  color: Color(0xFFFFD54F),
                                  fontSize: 15,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 2),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Center: VS Badge
                Container(
                  width: 60,
                  alignment: Alignment.topCenter,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // V-Shape Background
                      Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFC0A060), Color(0xFFE6C280)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          border: Border.all(color: Colors.white, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "VS",
                        style: GoogleFonts.blackOpsOne(
                          color: Colors.white,
                          fontSize: 20,
                          shadows: [
                            Shadow(color: Colors.black26, offset: Offset(1, 1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Enemy
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.enemyName ?? "妖魔",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              shadows: [
                                Shadow(color: Colors.black45, blurRadius: 2),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${_calculateCombatPower(false)}",
                                style: GoogleFonts.russoOne(
                                  color: Color(0xFFFFD54F),
                                  fontSize: 15,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 2),
                                  ],
                                ),
                              ),
                              SizedBox(width: 2),
                              Transform.rotate(
                                angle: pi / 4,
                                child: Icon(
                                  Icons.colorize,
                                  size: 14,
                                  color: Color(0xFFFFD54F),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: AssetImage(
                            enemyAvatar,
                          ), // Placeholder
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back Button Overlay
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormationGrid(
    List<BattleUnit?> formation, {
    required bool isPlayer,
  }) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Wider layout to fit 3 comfortably
          double width = constraints.maxWidth;
          double cellWidth = width / 3.2;
          double cellHeight = constraints.maxHeight / 3;

          return SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: GridView.builder(
              clipBehavior:
                  Clip.none, // Allow items to overflow (e.g. name tags)
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio:
                    cellWidth / cellHeight, // Maximize vertical space
                crossAxisSpacing: 5,
                mainAxisSpacing: 0, // Minimize vertical gap
              ),
              itemBuilder: (context, index) {
                final unit = formation[index];
                return DragTarget<Role>(
                  onWillAccept: (role) =>
                      isPlayer && _phase == BattlePhase.preparation,
                  onAccept: (role) => _toggleRoleInFormation(role),
                  builder: (context, candidateData, rejectedData) {
                    return GestureDetector(
                      onTap: () {
                        if (isPlayer &&
                            _phase == BattlePhase.preparation &&
                            unit != null) {
                          _toggleRoleInFormation(unit.role);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none, // Allow overflow
                          children: [
                            // 1. Shadow Base (Only if unit exists)
                            if (unit != null)
                              Positioned(
                                bottom: 15,
                                child: Container(
                                  width: cellWidth * 0.7,
                                  height: cellWidth * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.all(
                                      Radius.elliptical(
                                        cellWidth,
                                        cellWidth * 0.4,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            // 2. Unit
                            if (unit != null)
                              _buildBattleUnitVisual(
                                unit,
                                cellWidth,
                                cellHeight,
                              ),

                            // 3. "Add" Indicator (Hidden by default, shown only if dragging maybe? keeping it hidden for clean look like fig 1)
                            // We can remove it entirely for that clean look.
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBattleUnitVisual(BattleUnit unit, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // Allow UI elements to pop out
        children: [
          // A. Character Sprite
          Positioned(
            bottom: 25,
            child: AnimatedContainer(
              duration: 200.ms,
              transform: Matrix4.identity()
                ..scale(unit.isAttacking ? 1.2 : (unit.isHit ? 0.9 : 1.0)),
              width: width * 1.2, // Larger sprite overlapping bounds
              height: height * 1.1,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    unit.role.assetPath,
                    fit: BoxFit.contain,
                    color: unit.isDead ? Colors.grey : null,
                    colorBlendMode: unit.isDead ? BlendMode.saturation : null,
                  ),
                  if (unit.isHit) Container(color: Colors.red.withOpacity(0.5)),
                ],
              ),
            ),
          ),

          // B. Info Header (The "Pill" - like Fig 1)
          Positioned(
            top: -40, // Move above the character image
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Pill Container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(
                      0.65,
                    ), // Dark semi-transparent
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Element Icon
                      Container(
                        width: 14,
                        height: 14,
                        margin: EdgeInsets.only(right: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: unit.role.elementColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Text(
                          _getElementChar(unit.role.element),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Role Name
                      Text(
                        unit.role.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Second Row: Stars (Outside the pill, below it)
                SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    unit.role.stars,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.5),
                      child: Icon(
                        Icons.star,
                        color: Color(0xFFFFD700), // Gold
                        size: 10,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // C. HP Bar (Small and discreet)
          if (unit.hp < unit.maxHp)
            Positioned(
              bottom: 10,
              width: width * 0.6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: unit.hp / unit.maxHp,
                  backgroundColor: Colors.black54,
                  color: unit.isPlayer ? Colors.greenAccent : Colors.redAccent,
                  minHeight: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getElementChar(RoleElement e) {
    switch (e) {
      case RoleElement.metal:
        return '金';
      case RoleElement.wood:
        return '木';
      case RoleElement.water:
        return '水';
      case RoleElement.fire:
        return '火';
      case RoleElement.earth:
        return '土';
      default:
        return '';
    }
  }

  Widget _buildBottomPanel() {
    if (_phase != BattlePhase.preparation) {
      return SafeArea(
        top: false,
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _battleLog,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    // Hero Selection Panel
    return Container(
      height: 180, // Reduced height since filters are gone
      decoration: const BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Control Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text with bracket count
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.notoSerifSc(color: AppColors.inkBlack),
                    children: [
                      TextSpan(
                        text: '选择上阵英雄 ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            '(${_playerFormation.where((u) => u != null).length}/5)',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Start Button
                ElevatedButton(
                  onPressed: _startBattle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B2323), // Deep Red
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 0,
                    ),
                    elevation: 2,
                    minimumSize: Size(0, 32),
                  ),
                  child: const Text('开始战斗', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),

          // 2. Hero List
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _availableRoles.length,
              itemBuilder: (context, index) {
                final role = _availableRoles[index];
                final isDeployed = _playerFormation.any(
                  (u) => u?.role.id == role.id,
                );

                return GestureDetector(
                  onTap: () => _toggleRoleInFormation(role),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12, bottom: 12),
                    child: Stack(
                      children: [
                        // Card Image
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDeployed
                                  ? Colors
                                        .transparent // Border handled by overlay
                                  : Color(0xFFC0A060),
                              width: 1.5,
                            ),
                            image: DecorationImage(
                              image: AssetImage(role.assetPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Deployed Overlay (Dark tint + Checkmark)
                        if (isDeployed)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(
                                0.6,
                              ), // Dark overlay
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check_circle, // Big Green Check
                                color: Color(0xFF4CAF50), // Bright green
                                size: 32,
                              ),
                            ),
                          ),

                        // SSR Tag (Top Left)
                        Positioned(
                          top: 2,
                          left: 2,
                          child: Text(
                            role.rarityLabel,
                            style: GoogleFonts.blackOpsOne(
                              color: role.rarity == RoleRarity.ur
                                  ? Color(0xFFFFD700)
                                  : (role.rarity == RoleRarity.ssr
                                        ? Color(0xFFFF4500)
                                        : Colors.white),
                              fontSize: 10,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 2),
                              ],
                            ),
                          ),
                        ),

                        // Element Icon (Top Right)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(1),
                            child: Icon(
                              Icons.circle,
                              size: 6,
                              color: role.elementColor,
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
        ],
      ),
    );
  }
}

// Reuse constants from existing code
enum BattleTarget { player, enemy }

class FloatingText {
  final String id;
  final String text;
  final BattleTarget target;
  final Color color;

  FloatingText({
    required this.id,
    required this.text,
    required this.target,
    required this.color,
  });
}
