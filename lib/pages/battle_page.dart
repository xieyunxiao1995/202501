import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/constants.dart';
import '../models/beast_model.dart';
import '../models/tribe_model.dart';

class BattlePage extends StatefulWidget {
  final List<Beast> beasts;
  final TribeData tribeData;
  final Function(int, int) onReward;

  const BattlePage({
    super.key,
    required this.beasts,
    required this.tribeData,
    required this.onReward,
  });

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> with TickerProviderStateMixin {
  // Mode: 'map' or 'battle'
  String _mode = 'map';

  Beast? _selectedBeast;
  Map<String, dynamic>? _selectedDungeon;

  // Battle Logic State
  bool _isPlayerTurn = true;
  bool _battleEnded = false;
  int _turn = 1;

  // Cooldowns & Status
  int _skillCd = 0;
  int _healCd = 0;
  bool _isPlayerDefending = false;
  bool _isEnemyDefending = false;

  // Stats
  int _playerHp = 100;
  int _playerMaxHp = 100;
  int _enemyHp = 100;
  int _enemyMaxHp = 100;
  String _enemyName = "";

  // Visual Effects
  List<DamageTextData> _floatingTexts = [];
  ShakeController _playerShake = ShakeController();
  ShakeController _enemyShake = ShakeController();

  // Logs
  List<Widget> _logs = [];
  final ScrollController _logScrollController = ScrollController();

  // Animations
  late AnimationController _turnIndicatorController;

  @override
  void initState() {
    super.initState();
    if (widget.beasts.isNotEmpty) {
      _selectedBeast = widget.beasts.first;
    }

    _turnIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    _turnIndicatorController.dispose();
    super.dispose();
  }

  int _calculatePlayerPower() {
    if (_selectedBeast == null) return 0;
    final stats = _selectedBeast!.stats;
    final atkBonus = widget.tribeData.attackBonus;
    final defBonus = widget.tribeData.defenseBonus;
    final spdBonus = widget.tribeData.speedBonus;

    return (stats.hp * 0.3 +
            stats.atk * 0.4 * atkBonus +
            stats.def * 0.2 * defBonus +
            stats.spd * 0.1 * spdBonus)
        .toInt();
  }

  // --- Battle Logic Start ---

  void _startBattle(Map<String, dynamic> dungeon) {
    if (_selectedBeast == null) return;

    final dungeonPower = dungeon['power'] as int;
    final playerPower = _calculatePlayerPower();

    // 简单战力压制警告
    if (playerPower < dungeonPower * 0.6) {
      _showPowerWarning(dungeon, playerPower, dungeonPower);
    } else {
      _initBattle(dungeon, dungeonPower);
    }
  }

  void _showPowerWarning(
    Map<String, dynamic> dungeon,
    int playerPower,
    int dungeonPower,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.danger),
        ),
        title: const Text("境界压制", style: TextStyle(color: AppColors.danger)),
        content: Text(
          "敌方战力 ($dungeonPower) 远高于你 ($playerPower)。\n强行挑战恐有陨落风险。",
          style: const TextStyle(color: AppColors.textSub),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("撤退", style: TextStyle(color: AppColors.textSub)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _initBattle(dungeon, dungeonPower);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text("死战不退"),
          ),
        ],
      ),
    );
  }

  void _initBattle(Map<String, dynamic> dungeon, int dungeonPower) {
    final random = Random();
    setState(() {
      _mode = 'battle';
      _selectedDungeon = dungeon;
      _enemyName = dungeon['boss'];

      // Init Stats
      _enemyMaxHp =
          (dungeonPower * 0.8 + random.nextInt((dungeonPower * 0.4).toInt()))
              .toInt();
      _enemyHp = _enemyMaxHp;

      // Player HP Bonus for battle duration
      _playerMaxHp = _selectedBeast!.stats.hp * 3;
      _playerHp = _playerMaxHp;

      // Reset State
      _turn = 1;
      _skillCd = 0;
      _healCd = 0;
      _isPlayerDefending = false;
      _isEnemyDefending = false;
      _isPlayerTurn = true; // Player goes first for simplicity
      _battleEnded = false;

      _logs = [
        _buildLogItem(
          "遭遇 $_enemyName！战斗开始！",
          AppColors.textMain,
          Icons.warning_amber_rounded,
        ),
      ];
      _floatingTexts.clear();
    });
  }

  // --- Player Actions ---

  void _playerAction(String action) {
    if (_battleEnded) return;

    setState(() {
      _isPlayerTurn = false; // Lock input

      // Reset defense from previous turn
      _isPlayerDefending = false;
    });

    final random = Random();
    int damage = 0;
    String logText = "";
    bool isCrit = false;

    // Player Stats
    final pAtk = (_selectedBeast!.stats.atk * widget.tribeData.attackBonus)
        .toInt();

    switch (action) {
      case 'attack':
        // Base Attack
        damage = (pAtk * 0.8 + random.nextInt((pAtk * 0.4).toInt())).toInt();
        isCrit = random.nextDouble() > 0.8;
        if (isCrit) damage = (damage * 1.5).toInt();

        // Enemy Defense Calculation
        if (_isEnemyDefending) {
          damage = (damage * 0.5).toInt();
          logText = "你发起了攻击，但 $_enemyName 处于防御姿态！造成 $damage 点伤害。";
        } else {
          logText = "你发起攻击${isCrit ? "【暴击】" : ""}！造成 $damage 点伤害。";
        }

        _applyDamageToEnemy(damage, isCrit);
        break;

      case 'defend':
        _isPlayerDefending = true;
        logText = "你摆出了防御姿态，准备迎接下一次攻击。";
        _spawnFloatingText("防御", isCrit: false, isPlayer: true, isText: true);
        break;

      case 'skill':
        damage = (pAtk * 1.8 + random.nextInt((pAtk * 0.5).toInt())).toInt();
        isCrit = true; // Skills usually look cool/crit
        if (_isEnemyDefending) damage = (damage * 0.6).toInt();

        _skillCd = 4; // 3 turns CD
        logText = "你施展了本命神通！轰击 $_enemyName 造成 $damage 点巨额伤害！";
        _applyDamageToEnemy(damage, isCrit);
        break;

      case 'heal':
        int healAmount = (_playerMaxHp * 0.25).toInt();
        _playerHp = min(_playerMaxHp, _playerHp + healAmount);
        _healCd = 5; // 4 turns CD
        logText = "你运转灵力疗伤，恢复了 $healAmount 点生命值。";
        _spawnFloatingText(
          "+$healAmount",
          isCrit: false,
          isPlayer: true,
          color: Colors.greenAccent,
        );
        _playerShake.shake(); // visual feedback
        break;
    }

    _logs.add(_buildLogItem(logText, AppColors.secondary, Icons.arrow_upward));
    _scrollToBottom();

    // Check Win
    if (_enemyHp <= 0) {
      _battleEnded = true;
      Future.delayed(
        const Duration(milliseconds: 1000),
        () => _endBattle(true),
      );
    } else {
      // Proceed to Enemy Turn after delay
      Future.delayed(const Duration(milliseconds: 1200), _enemyTurn);
    }
  }

  void _applyDamageToEnemy(int damage, bool isCrit) {
    setState(() {
      _enemyHp = max(0, _enemyHp - damage);
      _enemyShake.shake();
      _spawnFloatingText(damage.toString(), isCrit: isCrit, isPlayer: false);
    });
  }

  // --- Enemy AI ---

  void _enemyTurn() {
    if (_battleEnded) return;

    setState(() {
      _isEnemyDefending = false; // Reset enemy defense

      // Cooldown tick for player
      if (_skillCd > 0) _skillCd--;
      if (_healCd > 0) _healCd--;
    });

    final random = Random();
    final dungeonPower = _selectedDungeon!['power'] as int;

    // Simple AI: 20% Defend, 60% Attack, 20% Heavy Attack
    double roll = random.nextDouble();
    int damage = 0;
    String logText = "";
    bool isCrit = false;

    if (roll < 0.2) {
      // Defend
      setState(() {
        _isEnemyDefending = true;
        _spawnFloatingText("防御", isCrit: false, isPlayer: false, isText: true);
      });
      logText = "$_enemyName 收缩了防御，气息变得深沉。";
    } else {
      // Attack Logic
      int baseDmg = (15 + random.nextInt(15) + dungeonPower * 0.012).toInt();

      if (roll > 0.8) {
        // Heavy Attack
        damage = (baseDmg * 1.5).toInt();
        logText = "$_enemyName 狂暴了！施展重击造成 $damage 伤害！";
        isCrit = true;
      } else {
        // Normal Attack
        damage = baseDmg;
        logText = "$_enemyName 发起攻击，造成 $damage 伤害。";
      }

      // Check Player Defense
      double finalDmg = damage.toDouble();
      if (_isPlayerDefending) {
        finalDmg = finalDmg * 0.5;
        logText += " (被格挡)";
      }

      // Tribe Defense Bonus (reduction)
      final tribeDefBonus = widget.tribeData.defenseBonus; // e.g. 1.05 for 5%
      // We interpret defense bonus as damage reduction: dmg / bonus
      finalDmg = finalDmg / tribeDefBonus;
      damage = finalDmg.toInt();

      // Apply Damage
      setState(() {
        _playerHp = max(0, _playerHp - damage);
        _playerShake.shake();
        _spawnFloatingText(damage.toString(), isCrit: isCrit, isPlayer: true);
      });
    }

    _logs.add(_buildLogItem(logText, AppColors.danger, Icons.arrow_downward));
    _scrollToBottom();

    // Check Loss
    if (_playerHp <= 0) {
      _battleEnded = true;
      Future.delayed(
        const Duration(milliseconds: 1000),
        () => _endBattle(false),
      );
    } else {
      // Back to Player Turn
      setState(() {
        _turn++;
        _isPlayerTurn = true;
      });
    }
  }

  // --- Visuals & End Game ---

  void _spawnFloatingText(
    String text, {
    required bool isCrit,
    required bool isPlayer,
    bool isText = false,
    Color? color,
  }) {
    final random = Random();
    // 调整坐标系：
    // y > 0 是屏幕下方（玩家），y < 0 是屏幕上方（敌人）
    // 为了防止数字飘出屏幕，我们稍微向中心靠拢
    double y = isPlayer ? 80 : -120;
    double x = (random.nextDouble() * 80) - 40;

    Color finalColor =
        color ??
        (isCrit
            ? AppColors.primary
            : (isText
                  ? Colors.white
                  : (isPlayer ? AppColors.danger : AppColors.secondary)));

    setState(() {
      _floatingTexts.add(
        DamageTextData(
          id:
              DateTime.now().millisecondsSinceEpoch.toString() +
              random.nextInt(100).toString(),
          text: isText ? text : (color != null ? text : "-$text"),
          x: x,
          y: y,
          color: finalColor,
          scale: isCrit ? 1.5 : 1.0,
        ),
      );
    });

    if (_floatingTexts.length > 10) {
      _floatingTexts.removeAt(0);
    }
  }

  void _scrollToBottom() {
    if (_logScrollController.hasClients) {
      // Small delay to ensure list has rendered the new item
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_logScrollController.hasClients) {
          _logScrollController.animateTo(
            _logScrollController.position.maxScrollExtent + 50,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _endBattle(bool victory) {
    if (victory) {
      final spirit =
          ((_selectedDungeon!['power'] as int) ~/
                  8 *
                  widget.tribeData.spiritIncomeBonus)
              .toInt();
      widget.onReward(spirit, 5);
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _buildResultDialog(victory),
    );
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.height < 750;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _mode == 'battle'
          ? _buildBattleInterface(isSmallScreen)
          : _buildMapInterface(isSmallScreen),
    );
  }

  // 1. Map Interface
  Widget _buildMapInterface(bool isSmallScreen) {
    if (widget.beasts.isEmpty) {
      return const Center(
        child: Text("无异兽可战，请先孵化", style: TextStyle(color: AppColors.textSub)),
      );
    }

    final playerPower = _selectedBeast != null ? _calculatePlayerPower() : 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, isSmallScreen ? 8 : 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Stats
          _buildMapHeader(playerPower, isSmallScreen),
          SizedBox(height: isSmallScreen ? 12 : 20),
          // Beast Selector Row
          SizedBox(
            height: isSmallScreen ? 75 : 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.beasts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (ctx, idx) =>
                  _buildBeastSelectorItem(widget.beasts[idx], isSmallScreen),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 20),
          Text(
            " · 征伐目标 · ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSub,
              letterSpacing: isSmallScreen ? 2 : 4,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          // Dungeon List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: dungeons.length,
              itemBuilder: (ctx, idx) =>
                  _buildDungeonCard(dungeons[idx], playerPower, isSmallScreen),
            ),
          ),
        ],
      ),
    );
  }

  // (Helper Widgets for Map Interface)
  Widget _buildMapHeader(int power, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF4C0519).withOpacity(0.8), Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: AppColors.danger.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "APOCALYPSE TIMER",
                style: TextStyle(
                  fontSize: isSmallScreen ? 8 : 10,
                  color: AppColors.danger,
                  letterSpacing: 1,
                ),
              ),
              Text(
                "天道大劫 · 倒计时",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Row(
                children: [
                  Text(
                    "92 年",
                    style: TextStyle(
                      color: AppColors.danger,
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "危",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 8 : 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "当前战力",
                style: TextStyle(
                  color: AppColors.textSub,
                  fontSize: isSmallScreen ? 10 : 12,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.flash_on,
                    color: AppColors.primary,
                    size: isSmallScreen ? 16 : 20,
                  ),
                  Text(
                    "$power",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              if (_selectedBeast != null)
                Text(
                  _selectedBeast!.name,
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeastSelectorItem(Beast b, bool isSmallScreen) {
    final isSelected = _selectedBeast?.id == b.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedBeast = b),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSmallScreen ? 70 : 80,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isSmallScreen ? 32 : 40,
              height: isSmallScreen ? 32 : 40,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  b.name[0],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : AppColors.textSub,
                  ),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            Text(
              b.name,
              style: TextStyle(
                fontSize: isSmallScreen ? 9 : 10,
                color: isSelected ? Colors.white : AppColors.textSub,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDungeonCard(
    Map<String, dynamic> d,
    int playerPower,
    bool isSmallScreen,
  ) {
    final minLevel = d['minTribeLevel'] as int? ?? 0;
    final isLevelLocked = widget.tribeData.level < minLevel;
    final isStatusLocked = d['status'] == 'locked';
    final isLocked = isStatusLocked || isLevelLocked;
    final dungeonPower = d['power'] as int;

    List<Color> gradientColors = [Colors.grey, Colors.black];
    try {
      gradientColors = (d['gradient'] as List)
          .map((c) => Color(int.parse(c)))
          .toList();
    } catch (_) {}

    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Container(
          height: isSmallScreen ? 90 : 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLocked
                  ? [Colors.black, Colors.grey.shade900]
                  : gradientColors,
            ),
            boxShadow: isLocked
                ? []
                : [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLocked
                  ? () {
                      if (isLevelLocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("部落等级不足！需要等级: $minLevel"),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    }
                  : () => _startBattle(d),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                d['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isLocked) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  isLevelLocked ? Icons.lock_clock : Icons.lock,
                                  size: isSmallScreen ? 14 : 16,
                                  color: Colors.white70,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLevelLocked ? "需要部落等级: $minLevel" : d['desc'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 11 : 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          d['level'],
                          style: TextStyle(
                            color: isLocked ? Colors.white30 : Colors.white70,
                            fontSize: isSmallScreen ? 11 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.flash_on,
                              size: isSmallScreen ? 12 : 14,
                              color: isLocked
                                  ? Colors.white30
                                  : Colors.orangeAccent,
                            ),
                            Text(
                              "$dungeonPower",
                              style: TextStyle(
                                color: isLocked ? Colors.white30 : Colors.white,
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 2. Battle Interface (完全重构后的布局)
  Widget _buildBattleInterface(bool isSmallScreen) {
    // 使用 Column + Expanded 分割区域，避免 Stack 导致的各种遮挡
    return Stack(
      children: [
        // 1. 全局背景层
        Positioned.fill(child: Container(color: const Color(0xFF0F172A))),
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Image.network(
              "https://www.transparenttextures.com/patterns/cubes.png",
              repeat: ImageRepeat.repeat,
              errorBuilder: (c, e, s) => Container(),
            ),
          ),
        ),

        // 2. 主要 UI 结构层 (SafeArea + Column)
        SafeArea(
          child: Column(
            children: [
              // --- 顶部状态栏 ---
              _buildTopBar(isSmallScreen),

              // --- 敌方区域 (弹性空间) ---
              Expanded(
                flex: isSmallScreen ? 5 : 6,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _buildEnemyDisplay(isSmallScreen),
                ),
              ),

              // --- 战场中间区域 (放置日志) ---
              // 日志窗口，在小屏幕上不占太多弹性空间
              _buildLogWindow(isSmallScreen),
              SizedBox(height: isSmallScreen ? 4 : 8),

              // --- 我方区域 ---
              Expanded(
                flex: isSmallScreen ? 6 : 6,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildPlayerDisplay(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 4 : 8),
                      // 操作面板
                      _buildCommandDeck(isSmallScreen),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. 特效层 (Damage Texts)
        // 这一层必须在最上面，覆盖所有 UI，且使用 Stack 才能自由定位
        Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: _floatingTexts
                  .map((t) => _buildFloatingText(t, isSmallScreen))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // --- Sub-Widgets for Battle Interface ---

  Widget _buildTopBar(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isSmallScreen ? 4 : 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(() => _mode = 'map'),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8 : 12,
                vertical: isSmallScreen ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.white70,
                    size: isSmallScreen ? 14 : 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "撤退",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 11 : 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 2 : 4,
            ),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isPlayerTurn ? AppColors.secondary : AppColors.danger,
                width: 1,
              ),
            ),
            child: Text(
              _isPlayerTurn ? "我方回合 ($_turn)" : "敌方行动中 ($_turn)",
              style: TextStyle(
                color: _isPlayerTurn ? AppColors.secondary : AppColors.danger,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 11 : 12,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(
            width: isSmallScreen ? 40 : 60,
          ), // Placeholder to balance row
        ],
      ),
    );
  }

  Widget _buildEnemyDisplay(bool isSmallScreen) {
    final double iconSize = isSmallScreen ? 70 : 100;
    final double glowSize = isSmallScreen ? 110 : 160;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 底部光环
        Container(
          width: glowSize,
          height: glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.danger.withOpacity(0.2), Colors.transparent],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHealthBar(
              _enemyHp,
              _enemyMaxHp,
              _enemyName,
              false, // isPlayer
              _isEnemyDefending,
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            ShakeWidget(
              controller: _enemyShake,
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.danger.withOpacity(0.4),
                      blurRadius: isSmallScreen ? 20 : 30,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: AppColors.danger, width: 2),
                  color: const Color(0xFF1E1B4B), // Dark blue bg
                ),
                child: Icon(
                  Icons.smart_toy,
                  size: isSmallScreen ? 40 : 50,
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerDisplay(bool isSmallScreen) {
    final double iconSize = isSmallScreen ? 56 : 80;

    return Column(
      children: [
        ShakeWidget(
          controller: _playerShake,
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.4),
                  blurRadius: isSmallScreen ? 15 : 20,
                ),
              ],
              border: Border.all(color: AppColors.secondary, width: 2),
              color: const Color(0xFF0F172A),
            ),
            child: Icon(
              Icons.pets,
              size: isSmallScreen ? 32 : 40,
              color: AppColors.secondary,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        _buildHealthBar(
          _playerHp,
          _playerMaxHp,
          _selectedBeast?.name ?? "Player",
          true, // isPlayer
          _isPlayerDefending,
          isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildHealthBar(
    int current,
    int maxHp,
    String label,
    bool isPlayer,
    bool isDefending,
    bool isSmallScreen,
  ) {
    double pct = (current / maxHp).clamp(0.0, 1.0);
    Color barColor = isPlayer ? AppColors.secondary : AppColors.danger;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: barColor,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12 : 14,
                shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
            if (isDefending) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white54),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield,
                      size: isSmallScreen ? 8 : 10,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "防御",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 7 : 8,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: isSmallScreen ? 4 : 6),
        Container(
          width: isSmallScreen ? 130 : 160,
          height: isSmallScreen ? 6 : 8,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white10),
          ),
          child: Stack(
            children: [
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                widthFactor: pct,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [barColor.withOpacity(0.6), barColor],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "$current / $maxHp",
          style: TextStyle(
            fontSize: isSmallScreen ? 9 : 10,
            color: Colors.white.withOpacity(0.5),
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  // 独立的日志窗口，带背景，不再遮挡
  Widget _buildLogWindow(bool isSmallScreen) {
    return Container(
      height: isSmallScreen ? 60 : 80,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ListView.builder(
          controller: _logScrollController,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: isSmallScreen ? 4 : 8,
          ),
          itemCount: _logs.length,
          itemBuilder: (ctx, idx) => _logs[idx],
        ),
      ),
    );
  }

  Widget _buildFloatingText(DamageTextData data, bool isSmallScreen) {
    // 重新调整坐标系以适应新的布局
    // 假设中心点为 (0,0)，需要映射到屏幕绝对位置
    // 这里我们简单处理：根据 isPlayer 属性决定是大致在上面还是下面

    // 如果是敌人(top)，我们把它放在屏幕上方 1/3 处
    // 如果是玩家(bottom)，放在屏幕下方 2/3 处
    double baseY =
        MediaQuery.of(context).size.height * (data.y > 0 ? 0.7 : 0.25);

    // 加上随机偏移
    double finalX =
        (MediaQuery.of(context).size.width / 2) + data.x - 30; // 30 是修正居中
    double finalY = baseY - (data.y > 0 ? 50 : -50); // 稍微往中心偏移一点

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      left: finalX,
      top: finalY,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        duration: const Duration(milliseconds: 800),
        builder: (context, double opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: data.scale,
              child: Text(
                data.text,
                style: TextStyle(
                  color: data.color,
                  fontSize: isSmallScreen ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommandDeck(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        isSmallScreen ? 8 : 20,
        16,
        isSmallScreen ? 10 : 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(
          top: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            label: "攻击",
            icon: Icons.gavel,
            color: AppColors.danger,
            onTap: () => _playerAction('attack'),
            isEnabled: _isPlayerTurn,
            isSmallScreen: isSmallScreen,
          ),
          _buildActionButton(
            label: "防御",
            icon: Icons.shield_outlined,
            color: AppColors.info,
            onTap: () => _playerAction('defend'),
            isEnabled: _isPlayerTurn,
            isSmallScreen: isSmallScreen,
          ),
          _buildActionButton(
            label: "神通",
            icon: Icons.flash_on,
            color: AppColors.primary,
            onTap: () => _playerAction('skill'),
            isEnabled: _isPlayerTurn && _skillCd == 0,
            cooldown: _skillCd,
            isSmallScreen: isSmallScreen,
          ),
          _buildActionButton(
            label: "疗伤",
            icon: Icons.local_pharmacy_outlined,
            color: Colors.green,
            onTap: () => _playerAction('heal'),
            isEnabled: _isPlayerTurn && _healCd == 0,
            cooldown: _healCd,
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isEnabled,
    int cooldown = 0,
    required bool isSmallScreen,
  }) {
    final double buttonSize = isSmallScreen ? 56 : 70;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: isEnabled ? color.withOpacity(0.1) : Colors.white10,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEnabled ? color.withOpacity(0.5) : Colors.white12,
              width: 1.5,
            ),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isEnabled ? color : Colors.white24,
                    size: isSmallScreen ? 24 : 28,
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isEnabled ? Colors.white : Colors.white38,
                      fontSize: isSmallScreen ? 9 : 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (cooldown > 0)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "$cooldown",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(String text, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 10, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
                fontFamily: 'monospace',
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDialog(bool victory) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: victory ? AppColors.primary : AppColors.danger,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              victory ? Icons.emoji_events : Icons.broken_image,
              size: 60,
              color: victory ? AppColors.primary : AppColors.danger,
            ),
            const SizedBox(height: 16),
            Text(
              victory ? "征伐胜利" : "征伐失败",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: victory ? AppColors.primary : AppColors.danger,
              ),
            ),
            const SizedBox(height: 16),
            if (victory) ...[
              const Text("获得战利品:", style: TextStyle(color: AppColors.textSub)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: (_selectedDungeon!['drop'] as List)
                    .map<Widget>(
                      (e) => Chip(
                        label: Text(e, style: const TextStyle(fontSize: 10)),
                        backgroundColor: AppColors.card,
                        padding: EdgeInsets.zero,
                      ),
                    )
                    .toList(),
              ),
            ] else
              const Text(
                "异兽重伤，请前往部落疗伤。",
                style: TextStyle(color: AppColors.textSub),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _mode = 'map');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: const Text("返回地图", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ... DamageTextData, ShakeWidget (保持不变) ...

class DamageTextData {
  String id;
  String text;
  double x;
  double y;
  Color color;
  double scale;

  DamageTextData({
    required this.id,
    required this.text,
    required this.x,
    required this.y,
    required this.color,
    this.scale = 1.0,
  });
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final ShakeController controller;
  const ShakeWidget({super.key, required this.child, required this.controller});

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class ShakeController {
  _ShakeWidgetState? _state;
  void shake() => _state?._shake();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _anim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(_controller);
  }

  void _shake() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) => Transform.translate(
        offset: Offset(_anim.value, 0),
        child: widget.child,
      ),
    );
  }
}
