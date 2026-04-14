import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'models.dart';
import 'perspective.dart';
import 'game_painter.dart';

/// Main game screen for Orbit Merge
class GameScreen extends StatefulWidget {
  final int level; // 关卡等级, 0表示无尽模式
  final bool showTitle; // 是否显示标题界面(无尽模式显示, 关卡模式不显示)

  const GameScreen({super.key, this.level = 0, this.showTitle = true});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // ---- Perspective constants ----
  static const int trackCount = 5;
  static const int gridCols = 4;
  static const int gridRows = 4;

  // ---- Game state ----
  double stardust = 80;
  double baseHp = 100;
  int wave = 1;
  double timeScale = 1.0;
  int score = 0;
  double scoreMultiplier = 1.0;
  bool isChoosingBuff = false;
  double overclockTimer = 0;
  int combo = 0;
  double comboTimer = 0;
  bool blackHoleWarn = false;
  DateTime? lastTapTime;

  // ---- Game stats ----
  int maxCombo = 0;
  int towersDeployed = 0;
  int enemiesKilled = 0;
  int mergesPerformed = 0;
  double gameTime = 0;

  // ---- Tutorial ----
  bool showTutorial = true;
  double tutorialTimer = 0;
  int tutorialStep = 0;

  // ---- Screen shake ----
  double shakeX = 0, shakeY = 0;
  double shakeDuration = 0;
  Color? impactFlashColor;
  double impactFlashAlpha = 0;

  // ---- Layout ----
  double vpX = 0, vpY = 0, baseY = 0;
  List<double> tracksX = [];
  Rect gridRect = Rect.zero;
  double cellSize = 0;
  double sizeW = 0, sizeH = 0;

  // ---- Perspective projection ----
  PerspectiveProjection projection = PerspectiveProjection(
    vanishingPointX: 0,
    vanishingPointY: 0,
    baseY: 0,
  );

  // ---- Game entities ----
  final grid = List.generate(
    gridCols,
    (_) => List<GameNode?>.filled(gridRows, null),
  );
  final towers = List<Tower?>.filled(trackCount, null);
  final enemies = <Enemy>[];
  final projectiles = <Projectile>[];
  final particles = <Particle>[];
  final towerFireTimers = List<double>.filled(trackCount, 0);

  // ---- Drag state ----
  bool dragActive = false;
  GameNode? dragNode;
  double dragStartX = 0, dragStartY = 0;
  double dragCurrentX = 0, dragCurrentY = 0;
  int dragOriginCol = -1, dragOriginRow = -1;

  // ---- Timers ----
  double spawnTimer = 0;
  double enemySpawnTimer = 0;
  double protocolTimer = 0;

  // ---- Animation ----
  Ticker? _ticker;
  DateTime? _lastTime;
  double animTime = 0;

  // ---- Game state ----
  bool gameStarted = false;
  bool gameOver = false;
  bool gameVictory = false; // 关卡胜利
  String playerName = ''; // 玩家角色名

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Auto-start if no title screen (level mode)
    if (!widget.showTitle) {
      gameStarted = true;
      playerName = '探险者';
    }
    // Initialize layout + start ticker after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLayout();
      _ticker = createTicker(_onTick)..start();
      _lastTime = DateTime.now();
      if (gameStarted) _initGrid();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (mounted) {
      _initLayout();
    }
  }

  // ---- Screen shake ----
  void _triggerShake([double intensity = 6]) {
    shakeDuration = 0.3;
    final rng = Random();
    shakeX = (rng.nextDouble() - 0.5) * intensity;
    shakeY = (rng.nextDouble() - 0.5) * intensity * 0.5;
  }

  void _triggerImpactFlash(Color color, [double alpha = 0.15]) {
    impactFlashColor = color;
    impactFlashAlpha = alpha;
  }

  void _initLayout() {
    if (!mounted) return;
    final mediaQuery = MediaQuery.of(context);
    sizeW = mediaQuery.size.width;
    sizeH = mediaQuery.size.height;

    if (sizeW == 0 || sizeH == 0) return;

    // Account for safe areas (notch, status bar, nav bar)
    final topPadding = mediaQuery.padding.top + 8;
    final bottomSafe = mediaQuery.padding.bottom;

    // HUD takes ~80px from top
    _hudTop = topPadding;
    _hudHeight = 72;
    final hudBottom = _hudTop + _hudHeight;

    vpX = sizeW / 2;
    vpY = hudBottom + sizeW * 0.05;
    // Game area ends where grid starts, with gap for combo bar
    baseY = sizeH * 0.52;
    // Ensure baseY is below vpY and HUD
    if (baseY < hudBottom + 60) {
      baseY = hudBottom + 60;
    }

    projection = PerspectiveProjection(
      vanishingPointX: vpX,
      vanishingPointY: vpY,
      baseY: baseY,
    );

    // Track X positions at base line
    tracksX = List.generate(trackCount, (i) {
      return projection.trackXAtBase(i, trackCount, sizeW);
    });

    // Grid layout (4x4 centered between combo bar and black hole)
    const padding = 16.0;
    final availableW = sizeW - padding * 2;
    cellSize = availableW / gridCols;
    final gridH = cellSize * gridRows;

    // Combo bar needs ~40px below baseY
    // Grid starts after combo bar with some spacing
    final gridTop = baseY + 55;
    // Black hole area at bottom with safe area padding
    final bhAreaHeight = 80 + bottomSafe;
    final gridBottom = sizeH - bhAreaHeight;

    final availableH = gridBottom - gridTop;
    var actualGridH = gridH;
    var actualCellSize = cellSize;

    // Scale down if grid doesn't fit
    if (actualGridH > availableH) {
      actualGridH = availableH;
      actualCellSize = actualGridH / gridRows;
    }

    // Center grid horizontally
    final actualGridW = actualCellSize * gridCols;
    final gridLeft = (sizeW - actualGridW) / 2;

    gridRect = Rect.fromLTWH(gridLeft, gridTop, actualGridW, actualGridH);
    cellSize = actualCellSize;
  }

  // HUD layout values
  double _hudTop = 0;
  double _hudHeight = 0;

  double _getNodeTargetX(int col) =>
      gridRect.left + col * cellSize + cellSize / 2;
  double _getNodeTargetY(int row) =>
      gridRect.top + row * cellSize + cellSize / 2;

  // ---- Initialization ----
  void _initGrid() {
    for (var c = 0; c < gridCols; c++) {
      for (var r = 0; r < gridRows; r++) {
        grid[c][r] = null;
      }
    }
    towers.fillRange(0, trackCount, null);
    _spawnNode(1);
    _spawnNode(1);
    _spawnNode(1);
    _spawnNode(2);
  }

  List<GridSlot> _getEmptySlots() {
    final slots = <GridSlot>[];
    for (var c = 0; c < gridCols; c++) {
      for (var r = 0; r < gridRows; r++) {
        if (grid[c][r] == null) slots.add(GridSlot(c, r));
      }
    }
    return slots;
  }

  bool _spawnNode([int tier = 1]) {
    final slots = _getEmptySlots();
    if (slots.isEmpty) return false;
    final slot = slots[Random().nextInt(slots.length)];
    final node = GameNode(
      tier,
      slot.col,
      slot.row,
      vx: _getNodeTargetX(slot.col),
      vy: _getNodeTargetY(slot.row),
      scale: 0.01,
    );
    grid[slot.col][slot.row] = node;
    blackHoleWarn = (slots.length - 1 <= 1);
    return true;
  }

  // ---- Auto spawn ----
  void _processAutoSpawn(double dt) {
    spawnTimer += dt;
    if (spawnTimer > 4) {
      spawnTimer = 0;
      if (stardust >= 3) {
        if (_spawnNode(1)) {
          stardust -= 3;
        }
      }
    }
  }

  // ---- Enemy spawning ----
  void _processEnemies(double dt) {
    enemySpawnTimer += dt;

    // Calculate difficulty based on both time and wave
    // Time-based difficulty: increases gradually over the game
    final timeDifficulty = gameTime / 60.0; // minutes of gameplay
    final effectiveDifficulty = wave + timeDifficulty * 0.5;

    // Spawn rate decreases over time (enemies come faster)
    // Starts at 2.5s, goes down to 0.6s minimum
    final spawnRate = max(0.6, 2.5 - effectiveDifficulty * 0.12);

    if (enemySpawnTimer > spawnRate) {
      enemySpawnTimer = 0;
      final track = Random().nextInt(trackCount);

      // Determine enemy type based on effective difficulty
      EnemyType enemyType;
      int enemyTier;
      double hpMult = 1.0;
      double speedMult = 1.0;
      double shieldValue = 0;

      final rng = Random();

      // Scale enemy type chances with difficulty
      final shieldChance = max(
        0.0,
        min(0.25, (effectiveDifficulty - 15) * 0.025),
      );
      final splitterChance = max(
        0.0,
        min(0.30, (effectiveDifficulty - 8) * 0.025),
      );
      final bossChance = max(0.0, min(0.20, (effectiveDifficulty - 12) * 0.02));
      final tankChance = max(0.0, min(0.35, (effectiveDifficulty - 5) * 0.03));
      final scoutChance = 0.25;

      if (effectiveDifficulty >= 15 && rng.nextDouble() < shieldChance) {
        // Shield enemies (from difficulty 15)
        enemyType = EnemyType.shield;
        enemyTier = min(5, 2 + effectiveDifficulty ~/ 5);
        hpMult = 1.5 + timeDifficulty * 0.05;
        speedMult = 0.8 + timeDifficulty * 0.02;
        shieldValue = (20 + effectiveDifficulty * 5).toDouble();
      } else if (effectiveDifficulty >= 8 &&
          rng.nextDouble() < splitterChance) {
        // Splitter enemies (from difficulty 8)
        enemyType = EnemyType.splitter;
        enemyTier = min(4, 1 + effectiveDifficulty ~/ 4);
        hpMult = 1.2 + timeDifficulty * 0.03;
        speedMult = 1.0 + timeDifficulty * 0.02;
      } else if (effectiveDifficulty >= 12 && rng.nextDouble() < bossChance) {
        // Boss enemies (from difficulty 12)
        enemyType = EnemyType.boss;
        enemyTier = min(5, 2 + effectiveDifficulty ~/ 5);
        hpMult = 5.0 + timeDifficulty * 0.1;
        speedMult = 0.5 + timeDifficulty * 0.02;
      } else if (effectiveDifficulty >= 5 && rng.nextDouble() < tankChance) {
        // Tank enemies (from difficulty 5)
        enemyType = EnemyType.tank;
        enemyTier = min(5, 1 + effectiveDifficulty ~/ 4);
        hpMult = 3.0 + timeDifficulty * 0.08;
        speedMult = 0.6 + timeDifficulty * 0.03;
      } else if (rng.nextDouble() < scoutChance) {
        // Scout enemies (fast, low HP)
        enemyType = EnemyType.scout;
        enemyTier = max(
          1,
          min(3, rng.nextInt(3) + 1 + effectiveDifficulty ~/ 10),
        );
        hpMult = 0.5 + timeDifficulty * 0.02;
        speedMult = 1.8 + timeDifficulty * 0.05;
      } else {
        enemyType = EnemyType.normal;
        enemyTier = max(
          1,
          min(4, rng.nextInt(3) + 1 + effectiveDifficulty ~/ 6),
        );
        hpMult = 1.0 + timeDifficulty * 0.04;
        speedMult = 1.0 + timeDifficulty * 0.03;
      }

      // HP and speed scale continuously with effective difficulty
      final baseHp = (8 + effectiveDifficulty * 12) * hpMult;
      final baseSpeed = (25 + effectiveDifficulty * 4) * speedMult;

      enemies.add(
        Enemy(
          trackIdx: track,
          y: vpY + 10,
          baseSpeed: baseSpeed,
          hp: baseHp,
          maxHp: baseHp,
          tier: enemyTier,
          type: enemyType,
          shieldHp: shieldValue,
        ),
      );

      // Increase wave every 10 enemies (used for UI display)
      if (enemies.length % 10 == 0) {
        wave++;
      }
    }
  }

  // ---- Tower combat ----
  void _processTowers(double dt) {
    double baseFireRate = 1.0;
    if (overclockTimer > 0) {
      baseFireRate = 0.5;
      overclockTimer -= dt;
    }

    for (var i = 0; i < trackCount; i++) {
      final towerNode = towers[i];
      if (towerNode == null) continue;

      towerFireTimers[i] -= dt;
      if (towerFireTimers[i] <= 0) {
        final hasEnemy = enemies.any(
          (e) => e.trackIdx == i && e.y < baseY - 10 && !e.markedForDeath,
        );
        if (hasEnemy) {
          final trackX = tracksX[i];
          final towerTier = towerNode.tier;
          final damage = pow(2, towerTier).toDouble() * 5;

          // Assign tower ability based on tier (T3+ gets abilities)
          TowerAbility ability = TowerAbility.normal;
          if (towerTier >= 4) {
            ability = TowerAbility.aoe;
          } else if (towerTier >= 3) {
            ability = i % 2 == 0 ? TowerAbility.slow : TowerAbility.splash;
          }

          projectiles.add(
            Projectile(
              trackIdx: i,
              x: trackX,
              y: baseY,
              tier: towerTier,
              damage: damage,
              color: tierColors[towerTier - 1],
              ability: ability,
            ),
          );
          towerFireTimers[i] = baseFireRate / (1 + towerTier * 0.2);
        }
      }
    }
  }

  // ---- Particles ----
  void _createExplosion(double x, double y, Color color, [int count = 10]) {
    for (var i = 0; i < count; i++) {
      final angle = Random().nextDouble() * pi * 2;
      final speed = Random().nextDouble() * 60 + 20;
      particles.add(
        Particle(
          x: x,
          y: y,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          life: 1.0,
          color: color,
        ),
      );
    }
  }

  // ---- Combo system ----
  void _addCombo() {
    combo++;
    if (combo > maxCombo) maxCombo = combo;
    comboTimer = 3.0;
    scoreMultiplier = 1.0 + combo * 0.25;
    if (combo >= 2) {
      _spawnNode(2);
      _createExplosion(sizeW / 2, baseY, const Color(0xFF00F0FF), 30);
      _triggerShake(3);
    }
    if (combo >= 4) {
      overclockTimer = 4.0;
      combo = 0;
      scoreMultiplier = 2.5;
      _triggerShake(8);
      _triggerImpactFlash(const Color(0xFFFFEA00), 0.2);
      // Firework particles for big combo
      for (var i = 0; i < 3; i++) {
        _createExplosion(
          sizeW * 0.2 + Random().nextDouble() * sizeW * 0.6,
          baseY * 0.3 + Random().nextDouble() * baseY * 0.4,
          tierColors[Random().nextInt(tierColors.length)],
          20,
        );
      }
    }
  }

  void _processCombo(double dt) {
    if (comboTimer > 0) {
      comboTimer -= dt;
      if (comboTimer <= 0) {
        combo = 0;
        scoreMultiplier = 1.0;
      }
    }
  }

  // ---- Deep Space Protocol (3-select-1) ----
  void _processProtocol(double dt) {
    if (isChoosingBuff) return;
    protocolTimer += dt;
    if (protocolTimer > 60) {
      protocolTimer = 0;
      _triggerProtocol();
    }
  }

  void _triggerProtocol() {
    if (!mounted) return;
    setState(() {
      isChoosingBuff = true;
      timeScale = 0.1;
    });
    _showProtocolDialog();
  }

  String _getTutorialText() {
    switch (tutorialStep) {
      case 0:
        return '👆 拖拽相同节点合成升级';
      case 1:
        return '🚀 向上拖拽节点部署防御塔';
      case 2:
        return '💫 连续合成触发COMBO奖励';
      case 3:
        return '🌀 双击黑洞清除最低阶节点';
      case 4:
        return '⚡ 每60秒选择深空协议强化';
      default:
        return '';
    }
  }

  void _processTutorial(double dt) {
    if (!showTutorial) return;
    tutorialTimer += dt;

    // Auto-advance tutorial steps
    if (tutorialTimer > 4) {
      tutorialTimer = 0;
      if (tutorialStep < 4) {
        tutorialStep++;
      } else if (gameTime > 30) {
        // Fade out tutorial after 30 seconds
        setState(() {
          showTutorial = false;
        });
      }
    }
  }

  void _showProtocolDialog() {
    final buffs = _generateBuffs();
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ProtocolDialog(buffs: buffs),
    ).then((selectedBuff) {
      if (selectedBuff != null && mounted) {
        selectedBuff.action();
        setState(() {
          isChoosingBuff = false;
          timeScale = 1.0;
        });
        _createExplosion(vpX, baseY, const Color(0xFFFF00AA), 50);
        _triggerShake(5);
        _triggerImpactFlash(const Color(0xFFFF00AA), 0.15);
      }
    });
  }

  List<Buff> _generateBuffs() {
    final allBuffs = [
      Buff(
        name: '动能回收',
        tier: 'R',
        tierColor: const Color(0xFF0088FF),
        icon: '⚡',
        description: '立即获得50星尘并生成2个T2节点',
        action: () {
          stardust += 50;
          _spawnNode(2);
          _spawnNode(2);
        },
      ),
      Buff(
        name: '引力塌陷',
        tier: 'SR',
        tierColor: const Color(0xFFAA00FF),
        icon: '🌀',
        description: '所有敌人当前生命值减半',
        action: () {
          for (final e in enemies) {
            e.hp /= 2;
          }
          _createExplosion(vpX, baseY, const Color(0xFF9D00FF), 50);
        },
      ),
      Buff(
        name: '防线超频',
        tier: 'SR',
        tierColor: const Color(0xFFAA00FF),
        icon: '🔥',
        description: '基地恢复50%HP，触发长效超频',
        action: () {
          baseHp = min(100, baseHp + 50);
          overclockTimer = 10;
        },
      ),
      Buff(
        name: '维度共振',
        tier: 'SSR',
        tierColor: const Color(0xFFFF0055),
        icon: '💎',
        description: '所有防御塔立即提升1阶',
        action: () {
          for (var i = 0; i < trackCount; i++) {
            if (towers[i] != null && towers[i]!.tier < 5) {
              towers[i] = Tower(tier: towers[i]!.tier + 1);
            }
          }
          _createExplosion(vpX, baseY, const Color(0xFFFF00AA), 100);
        },
      ),
      Buff(
        name: '折射棱镜',
        tier: 'SR',
        tierColor: const Color(0xFFAA00FF),
        icon: '💠',
        description: '获得30星尘和T3节点',
        action: () {
          stardust += 30;
          _spawnNode(3);
        },
      ),
      Buff(
        name: '时间膨胀',
        tier: 'SSR',
        tierColor: const Color(0xFFFF0055),
        icon: '⏳',
        description: '所有敌人减速5秒',
        action: () {
          for (final e in enemies) {
            e.slowFactor = 0.3;
            e.slowTimer = 5.0;
          }
          _createExplosion(vpX, baseY, const Color(0xFF00C3FF), 60);
        },
      ),
      Buff(
        name: '星尘暴涨',
        tier: 'R',
        tierColor: const Color(0xFF0088FF),
        icon: '✦',
        description: '立即获得100星尘',
        action: () {
          stardust += 100;
          _createExplosion(sizeW / 2, sizeH / 2, const Color(0xFF00FF88), 30);
        },
      ),
      Buff(
        name: '连击核心',
        tier: 'SR',
        tierColor: const Color(0xFFAA00FF),
        icon: '🎯',
        description: '立即触发5连击效果',
        action: () {
          combo = 4;
          comboTimer = 3.0;
          _addCombo();
        },
      ),
      Buff(
        name: '铁壁防御',
        tier: 'R',
        tierColor: const Color(0xFF0088FF),
        icon: '🛡️',
        description: '基地恢复30%HP',
        action: () {
          baseHp = min(100, baseHp + 30);
          _createExplosion(vpX, baseY, const Color(0xFF00FF88), 25);
        },
      ),
      Buff(
        name: '星轨齐射',
        tier: 'SSR',
        tierColor: const Color(0xFFFF0055),
        icon: '🌟',
        description: '所有塔立即发射一枚强力炮弹',
        action: () {
          for (var i = 0; i < trackCount; i++) {
            if (towers[i] != null) {
              final towerTier = towers[i]!.tier;
              final trackX = tracksX[i];
              final damage = pow(2, towerTier).toDouble() * 15;
              projectiles.add(
                Projectile(
                  trackIdx: i,
                  x: trackX,
                  y: baseY,
                  tier: towerTier,
                  damage: damage,
                  color: tierColors[towerTier - 1],
                  ability: towerTier >= 4
                      ? TowerAbility.aoe
                      : towerTier >= 3
                      ? (i % 2 == 0 ? TowerAbility.slow : TowerAbility.splash)
                      : TowerAbility.normal,
                ),
              );
            }
          }
          _createExplosion(vpX, baseY, const Color(0xFFFFEA00), 80);
          _triggerShake(6);
        },
      ),
      Buff(
        name: '合成大师',
        tier: 'SR',
        tierColor: const Color(0xFFAA00FF),
        icon: '🔮',
        description: '生成1个T4节点',
        action: () {
          _spawnNode(4);
          _createExplosion(sizeW / 2, sizeH * 0.7, const Color(0xFFFF00AA), 30);
        },
      ),
    ];

    allBuffs.shuffle(Random());
    return allBuffs.take(3).toList();
  }

  // ---- Black hole recycling ----
  void _triggerBlackHole() {
    final now = DateTime.now();
    final isDoubleTap =
        lastTapTime != null &&
        now.difference(lastTapTime!).inMilliseconds < 300;
    lastTapTime = now;

    if (isDoubleTap && stardust >= 10) {
      stardust -= 10;
      int lowestTier = 6;
      for (var c = 0; c < gridCols; c++) {
        for (var r = 0; r < gridRows; r++) {
          final n = grid[c][r];
          if (n != null && n.tier < lowestTier) lowestTier = n.tier;
        }
      }
      if (lowestTier < 6) {
        for (var c = 0; c < gridCols; c++) {
          for (var r = 0; r < gridRows; r++) {
            final n = grid[c][r];
            if (n != null && n.tier == lowestTier) {
              _createExplosion(n.vx, n.vy, const Color(0xFF9D00FF), 20);
              grid[c][r] = null;
            }
          }
        }
        _triggerShake(4);
      }
    }
  }

  // ---- Input handling ----
  void _handleDown(Offset pos) {
    if (timeScale < 0.5) return;

    // Check black hole area tap (bottom area below grid)
    if (pos.dy > gridRect.bottom + 10) {
      _triggerBlackHole();
      return;
    }

    // Check grid nodes
    for (var c = 0; c < gridCols; c++) {
      for (var r = 0; r < gridRows; r++) {
        final n = grid[c][r];
        if (n != null) {
          final dx = pos.dx - n.vx;
          final dy = pos.dy - n.vy;
          if (dx * dx + dy * dy < 1600) {
            // radius ~40
            setState(() {
              dragActive = true;
              dragNode = n;
              dragStartX = pos.dx;
              dragStartY = pos.dy;
              dragCurrentX = pos.dx;
              dragCurrentY = pos.dy;
              dragOriginCol = c;
              dragOriginRow = r;
              grid[c][r] = null;
            });
            HapticFeedback.lightImpact();
            return;
          }
        }
      }
    }
  }

  void _handleMove(Offset pos) {
    if (dragActive && dragNode != null) {
      setState(() {
        dragCurrentX = pos.dx;
        dragCurrentY = pos.dy;
        dragNode!.vx = pos.dx;
        dragNode!.vy = pos.dy;
      });
    }
  }

  void _handleUp(Offset pos) {
    if (!dragActive || dragNode == null) return;

    final n = dragNode!;
    final x = dragCurrentX;
    final y = dragCurrentY;

    setState(() {
      // Check if deployed to upper screen (Y < baseY)
      if (y < baseY) {
        final trackIdx = max(
          0,
          min(trackCount - 1, (x / (sizeW / trackCount)).floor()),
        );
        towers[trackIdx] = Tower(tier: n.tier);
        towersDeployed++;
        _createExplosion(tracksX[trackIdx], baseY, tierColors[n.tier - 1], 40);
        _triggerShake(4);
        _triggerImpactFlash(tierColors[n.tier - 1], 0.1);
        HapticFeedback.mediumImpact();
      } else {
        // Check grid placement
        int targetCol = ((x - gridRect.left) / cellSize).floor();
        int targetRow = ((y - gridRect.top) / cellSize).floor();
        targetCol = max(0, min(gridCols - 1, targetCol));
        targetRow = max(0, min(gridRows - 1, targetRow));

        final targetNode = grid[targetCol][targetRow];

        if (targetNode != null && targetNode.tier == n.tier && n.tier < 5) {
          // Merge!
          targetNode.tier++;
          mergesPerformed++;
          targetNode.scale = 0.5;
          _addCombo();
          _createExplosion(
            targetNode.vx,
            targetNode.vy,
            tierColors[targetNode.tier - 1],
            20,
          );
          _triggerShake(3);
          _triggerImpactFlash(tierColors[targetNode.tier - 1], 0.1);
          HapticFeedback.mediumImpact();
        } else if (targetNode != null) {
          // Swap positions
          grid[dragOriginCol][dragOriginRow] = targetNode;
          targetNode.col = dragOriginCol;
          targetNode.row = dragOriginRow;
          grid[targetCol][targetRow] = n;
          n.col = targetCol;
          n.row = targetRow;
        } else {
          // Empty slot, place directly
          grid[targetCol][targetRow] = n;
          n.col = targetCol;
          n.row = targetRow;
        }
      }

      dragActive = false;
      dragNode = null;
    });
  }

  // ---- Game update tick ----
  void _onTick(Duration elapsed) {
    // Skip until layout is ready
    if (sizeW == 0 || sizeH == 0) return;

    final now = DateTime.now();
    if (_lastTime == null) {
      _lastTime = now;
      return;
    }
    double dt = now.difference(_lastTime!).inMilliseconds / 1000.0;
    _lastTime = now;
    if (dt > 0.1) dt = 0.1;
    if (dt < 0) dt = 0;

    animTime += dt;

    // Update shake
    if (shakeDuration > 0) {
      shakeDuration -= dt;
      final rng = Random();
      shakeX = (rng.nextDouble() - 0.5) * shakeDuration * 20;
      shakeY = (rng.nextDouble() - 0.5) * shakeDuration * 10;
    } else {
      shakeX = 0;
      shakeY = 0;
    }

    // Update impact flash
    if (impactFlashAlpha > 0) {
      impactFlashAlpha -= dt * 0.8;
      if (impactFlashAlpha < 0) impactFlashAlpha = 0;
    }

    final realDt = dt * timeScale;
    gameTime += realDt;

    // Update game logic
    _processAutoSpawn(realDt);
    _processEnemies(realDt);
    _processTowers(realDt);
    _processCombo(realDt);
    _processProtocol(dt);
    _processTutorial(dt);

    // Update enemies
    for (var i = enemies.length - 1; i >= 0; i--) {
      final e = enemies[i];
      // Decay slow effect
      if (e.slowTimer > 0) {
        e.slowTimer -= realDt;
        if (e.slowTimer <= 0) {
          e.slowFactor = 1.0;
        }
      }
      e.y += e.effectiveSpeed * realDt;
      if (e.y >= baseY) {
        baseHp -= e.tier * 1.5;
        _createExplosion(
          tracksX[e.trackIdx],
          baseY,
          e.visualColor,
          e.type == EnemyType.boss ? 40 : 20,
        );
        _triggerShake(e.type == EnemyType.boss ? 12 : 8);
        _triggerImpactFlash(e.visualColor, 0.2);
        e.markedForDeath = true;
        HapticFeedback.mediumImpact();
      }
    }

    // Update projectiles
    for (var i = projectiles.length - 1; i >= 0; i--) {
      final p = projectiles[i];
      p.y -= p.speed * realDt;
      if (p.y < vpY) {
        p.markedForDeath = true;
        continue;
      }
      // Collision detection
      for (final e in enemies) {
        if (!e.markedForDeath &&
            e.trackIdx == p.trackIdx &&
            (e.y - p.y).abs() < 20) {
          // Shield absorbs damage first
          if (e.shieldHp > 0) {
            e.shieldHp -= p.damage;
            if (e.shieldHp < 0) {
              e.hp += e.shieldHp; // excess damage to HP
              e.shieldHp = 0;
            }
            _createExplosion(p.x, e.y, const Color(0xFF4488FF), 8);
          } else {
            e.hp -= p.damage;
          }
          p.markedForDeath = true;
          _createExplosion(p.x, e.y, p.color, 10);

          // Apply tower ability effects
          switch (p.ability) {
            case TowerAbility.slow:
              e.slowFactor = 0.4;
              e.slowTimer = 2.0;
              break;
            case TowerAbility.splash:
              // Damage nearby enemies on same track
              for (final other in enemies) {
                if (other != e &&
                    !other.markedForDeath &&
                    other.trackIdx == p.trackIdx &&
                    (other.y - e.y).abs() < 40) {
                  other.hp -= p.damage * 0.5;
                  if (other.hp <= 0) {
                    other.markedForDeath = true;
                    stardust += 3 + other.tier;
                    score += (other.tier * 10 * scoreMultiplier).round();
                  }
                }
              }
              break;
            case TowerAbility.aoe:
              // Damage all enemies on same track
              for (final other in enemies) {
                if (other != e &&
                    !other.markedForDeath &&
                    other.trackIdx == p.trackIdx) {
                  other.hp -= p.damage * 0.3;
                  if (other.hp <= 0) {
                    other.markedForDeath = true;
                    stardust += 3 + other.tier;
                    score += (other.tier * 10 * scoreMultiplier).round();
                  }
                }
              }
              _createExplosion(p.x, e.y, p.color, 25);
              break;
            case TowerAbility.normal:
              break;
          }

          if (e.hp <= 0 && !e.markedForDeath) {
            // Handle splitter: spawn 2 small scouts on death
            if (e.type == EnemyType.splitter) {
              for (var s = 0; s < 2; s++) {
                enemies.add(
                  Enemy(
                    trackIdx: e.trackIdx,
                    y: e.y + s * 15,
                    baseSpeed: e.baseSpeed * 1.5,
                    hp: e.maxHp * 0.3,
                    maxHp: e.maxHp * 0.3,
                    tier: max(1, e.tier - 1),
                    type: EnemyType.scout,
                  ),
                );
              }
              _createExplosion(
                tracksX[e.trackIdx],
                e.y,
                const Color(0xFF00FFAA),
                25,
              );
            }

            e.markedForDeath = true;
            enemiesKilled++;
            stardust += 3 + e.tier;
            score +=
                (e.tier *
                        10 *
                        (e.type == EnemyType.boss ? 5 : 1) *
                        scoreMultiplier)
                    .round();
            _createExplosion(
              tracksX[e.trackIdx],
              e.y,
              e.visualColor,
              e.type == EnemyType.boss ? 50 : 15,
            );
          }
          break;
        }
      }
    }

    // Update node visual positions (easing)
    for (var c = 0; c < gridCols; c++) {
      for (var r = 0; r < gridRows; r++) {
        final n = grid[c][r];
        if (n != null) {
          if (n.scale < 1) {
            n.scale += dt * 5;
            if (n.scale > 1) n.scale = 1;
          }
          final targetX = _getNodeTargetX(n.col);
          final targetY = _getNodeTargetY(n.row);
          n.vx += (targetX - n.vx) * 15 * dt;
          n.vy += (targetY - n.vy) * 15 * dt;
        }
      }
    }

    // Update particles
    for (var i = particles.length - 1; i >= 0; i--) {
      final p = particles[i];
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.life -= dt * 2;
      if (p.life <= 0) {
        particles.removeAt(i);
      }
    }

    // Cleanup dead entities
    enemies.removeWhere((e) => e.markedForDeath);
    projectiles.removeWhere((p) => p.markedForDeath);

    // Check win condition for level mode
    final targetWaves = widget.level > 0 ? widget.level * 3 + 5 : 0;
    if (widget.level > 0 && wave > targetWaves) {
      _showGameVictory();
      return;
    }

    // Check game over
    if (baseHp <= 0) {
      _showGameOver();
      return;
    }

    // Trigger rebuild
    if (mounted) {
      setState(() {});
    }
  }

  void _showGameOver() {
    _ticker?.stop();
    gameOver = true;
    if (!mounted) return;
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _GameOverDialog(
        score: score,
        wave: wave,
        maxCombo: maxCombo,
        towersDeployed: towersDeployed,
        enemiesKilled: enemiesKilled,
        mergesPerformed: mergesPerformed,
        gameTime: gameTime,
      ),
    ).then((restart) {
      if (mounted) {
        if (restart == true) {
          // 再来一局
          setState(() {
            stardust = 80;
            baseHp = 100;
            wave = 1;
            score = 0;
            scoreMultiplier = 1.0;
            enemies.clear();
            projectiles.clear();
            particles.clear();
            for (var i = 0; i < trackCount; i++) towers[i] = null;
            spawnTimer = 0;
            enemySpawnTimer = 0;
            protocolTimer = 0;
            combo = 0;
            comboTimer = 0;
            overclockTimer = 0;
            maxCombo = 0;
            towersDeployed = 0;
            enemiesKilled = 0;
            mergesPerformed = 0;
            gameTime = 0;
            showTutorial = true;
            tutorialTimer = 0;
            tutorialStep = 0;
            gameOver = false;
            gameVictory = false;
          });
          _initGrid();
          _lastTime = DateTime.now();
          _ticker?.start();
        } else {
          // 返回上一页
          Navigator.of(context).pop(false);
        }
      }
    });
  }

  void _showGameVictory() {
    _ticker?.stop();
    gameVictory = true;
    if (!mounted) return;
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _GameVictoryDialog(
        level: widget.level,
        score: score,
        wave: wave,
        maxCombo: maxCombo,
        towersDeployed: towersDeployed,
        enemiesKilled: enemiesKilled,
        mergesPerformed: mergesPerformed,
        gameTime: gameTime,
      ),
    ).then((_) {
      if (mounted) {
        Navigator.of(context).pop(true); // 返回true表示通关
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      body: Stack(
        children: [
          // Title screen (only for endless mode)
          if (!gameStarted && widget.showTitle)
            _TitleScreen(
              onStart: () {
                if (playerName.isEmpty) return;
                setState(() {
                  gameStarted = true;
                });
                _initGrid();
              },
              onNameSubmit: (name) {
                setState(() {
                  playerName = name;
                });
              },
            ),

          // Game content
          if (gameStarted) ..._buildGameContent(),
        ],
      ),
    );
  }

  List<Widget> _buildGameContent() {
    return [
      // Game canvas with shake offset
      Transform.translate(
        offset: Offset(shakeX, shakeY),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (sizeW != constraints.maxWidth ||
                sizeH != constraints.maxHeight) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initLayout();
              });
            }
            return GestureDetector(
              onPanStart: (details) => _handleDown(details.localPosition),
              onPanUpdate: (details) => _handleMove(details.localPosition),
              onPanEnd: (details) {
                if (dragActive) {
                  _handleUp(details.localPosition);
                }
              },
              child: Stack(
                children: [
                  CustomPaint(
                    painter: GamePainter(
                      vpX: vpX,
                      vpY: vpY,
                      baseY: baseY,
                      tracksX: tracksX,
                      trackCount: trackCount,
                      gridRect: gridRect,
                      cellSize: cellSize,
                      grid: grid,
                      towers: towers,
                      enemies: enemies,
                      projectiles: projectiles,
                      particles: particles,
                      dragNode: dragNode,
                      dragCurrentX: dragCurrentX,
                      dragCurrentY: dragCurrentY,
                      dragActive: dragActive,
                      overclockTimer: overclockTimer,
                      combo: combo,
                      comboTimer: comboTimer,
                      blackHoleWarn: blackHoleWarn,
                      stardust: stardust,
                      baseHp: baseHp,
                      wave: wave,
                      projection: projection,
                      sizeW: sizeW,
                      sizeH: sizeH,
                      animTime: animTime,
                      hudHeight: _hudHeight,
                    ),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  ),

                  // Impact flash overlay
                  if (impactFlashAlpha > 0)
                    IgnorePointer(
                      child: Container(
                        color: (impactFlashColor ?? Colors.white).withOpacity(
                          impactFlashAlpha,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),

      // Top HUD
      Positioned(top: _hudTop, left: 0, right: 0, child: _buildHUD()),

      // Tutorial overlay
      if (showTutorial && gameStarted && !gameOver)
        Positioned(
          top: _hudTop + _hudHeight + 10,
          left: 20,
          right: 20,
          child: AnimatedOpacity(
            opacity: showTutorial ? 0.9 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1020).withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00F0FF).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Progress dots
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i <= tutorialStep
                              ? const Color(0xFF00F0FF)
                              : const Color(0xFF334455),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getTutorialText(),
                      style: const TextStyle(
                        color: Color(0xFFAABBCC),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showTutorial = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Text(
                        '✕',
                        style: TextStyle(
                          color: Color(0xFF6688AA),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      // Score display (top right, below HUD)
      if (gameStarted && !gameOver)
        Positioned(
          top: _hudTop + _hudHeight + (showTutorial ? 60 : 10),
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1020).withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFFEA00).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              '$score',
              style: const TextStyle(
                color: Color(0xFFFFEA00),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Color(0xFFFFEA00), blurRadius: 6)],
              ),
            ),
          ),
        ),

      // Protocol overlay
      if (isChoosingBuff)
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              color: Colors.black.withOpacity((1 - timeScale) * 0.6),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A1E).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    '⏸ 子弹时间',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                      shadows: [
                        Shadow(color: Color(0xFFFFD700), blurRadius: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ];
  }

  Widget _buildHUD() {
    final t = animTime;
    final hpRatio = (baseHp / 100).clamp(0.0, 1.0);
    final hpColor = hpRatio > 0.5
        ? const Color(0xFF00FF88)
        : hpRatio > 0.25
        ? const Color(0xFFFFAA00)
        : const Color(0xFFFF003C);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player name + Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (playerName.isNotEmpty)
                Text(
                  '👤 $playerName',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00F0FF),
                  ),
                )
              else
                const SizedBox(width: 1),
              Text(
                '得分: $score',
                style: const TextStyle(fontSize: 12, color: Color(0xFFAABBCC)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Top row: Stardust + Multiplier + Wave
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stardust
              _buildHUDItem(
                icon: '✦',
                value: stardust.floor().toString(),
                label: '星尘',
                color: const Color(0xFF00F0FF),
              ),
              // Score Multiplier (shown when > 1x)
              if (scoreMultiplier > 1.0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEA00).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFEA00).withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${scoreMultiplier.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      color: Color(0xFFFFEA00),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Color(0xFFFFEA00), blurRadius: 8),
                      ],
                    ),
                  ),
                ),
              // Wave
              _buildHUDItem(
                icon: '◈',
                value: wave.toString(),
                label: '波次',
                color: const Color(0xFF9D00FF),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // HP bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '基地 HP',
                      style: TextStyle(color: Color(0xFF668899), fontSize: 9),
                    ),
                    Text(
                      '${baseHp.floor()}%',
                      style: TextStyle(
                        color: hpColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: hpColor, blurRadius: 6)],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                // HP bar
                SizedBox(
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF111820),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [hpColor, hpColor.withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: hpColor.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          width:
                              (MediaQuery.of(context).size.width - 32) *
                              hpRatio,
                        ),
                        // Pulsing highlight
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(
                                    0.15 + 0.1 * sin(t * 2),
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHUDItem({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1020).withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: TextStyle(
              color: color,
              fontSize: 16,
              shadows: [Shadow(color: color, blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: color, blurRadius: 8)],
                ),
              ),
              Text(
                label,
                style: TextStyle(color: color.withOpacity(0.6), fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- Title Screen ----
class _TitleScreen extends StatefulWidget {
  final VoidCallback onStart;
  final Function(String) onNameSubmit;
  const _TitleScreen({required this.onStart, required this.onNameSubmit});

  @override
  State<_TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<_TitleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  final TextEditingController _nameController = TextEditingController();
  bool _hasName = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleNameSubmit() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && name.length <= 12) {
      setState(() => _hasName = true);
      widget.onNameSubmit(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 0.8,
          colors: [Color(0xFF0A1030), Color(0xFF050818), Color(0xFF020308)],
        ),
      ),
      child: Stack(
        children: [
          // Animated stars background
          CustomPaint(
            painter: _StarFieldPainter(animTime: _controller.value),
            size: size,
          ),

          // Orbital ring decoration around title
          Positioned.fill(
            child: CustomPaint(
              painter: _TitleOrbitalPainter(animTime: _controller.value),
              size: size,
            ),
          ),

          // Content
          FadeTransition(
            opacity: _fadeIn,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // Game title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF00F0FF),
                        Color(0xFF9D00FF),
                        Color(0xFFFF00AA),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      '星轨防线',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8,
                        shadows: [
                          Shadow(color: Color(0xFF00F0FF), blurRadius: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'ORBIT DEFENSE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF00F0FF).withOpacity(0.6),
                      letterSpacing: 12,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Name input
                  if (!_hasName)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          const Text(
                            '请输入你的角色名',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8899AA),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A1628),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF00F0FF).withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00F0FF,
                                  ).withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _nameController,
                              textAlign: TextAlign.center,
                              maxLength: 12,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF00F0FF),
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                hintText: '输入角色名',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF334455),
                                ),
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _handleNameSubmit(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: _handleNameSubmit,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00F0FF),
                                    Color(0xFF0088FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00F0FF,
                                    ).withOpacity(0.3),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: const Text(
                                '确 定',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Instructions
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1020).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00F0FF).withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      children: const [
                        _InstructionRow(icon: '👆', text: '拖拽节点合成升级'),
                        SizedBox(height: 12),
                        _InstructionRow(icon: '🚀', text: '向上部署防御塔'),
                        SizedBox(height: 12),
                        _InstructionRow(icon: '💫', text: '连续合成触发连击'),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Start button
                  if (_hasName)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: GestureDetector(
                        onTap: widget.onStart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00F0FF), Color(0xFF0088FF)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF00F0FF),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Text(
                            '开 始 游 戏',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final String icon;
  final String text;
  const _InstructionRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: Color(0xFFAABBCC), fontSize: 13),
        ),
      ],
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final double animTime;
  _StarFieldPainter({required this.animTime});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(123);
    for (var i = 0; i < 150; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final s = rng.nextDouble() * 1.8 + 0.3;
      final twinkle = 0.3 + 0.7 * (0.5 + 0.5 * sin(animTime * 3 + i * 0.7));
      canvas.drawCircle(
        Offset(x, y),
        s,
        Paint()..color = Colors.white.withOpacity(twinkle * 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter oldDelegate) => true;
}

class _TitleOrbitalPainter extends CustomPainter {
  final double animTime;
  _TitleOrbitalPainter({required this.animTime});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 - 40;
    final t = animTime;

    // Orbital rings
    for (var i = 0; i < 3; i++) {
      final ringR = 120.0 + i * 30;
      final angle = t * (1.5 + i * 0.5) * (i % 2 == 0 ? 1 : -1);
      final color = [
        const Color(0xFF00F0FF),
        const Color(0xFF9D00FF),
        const Color(0xFFFF00AA),
      ][i];

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);

      // Ring
      final ringPaint = Paint()
        ..color = color.withOpacity(0.1 + 0.05 * sin(t * 2 + i))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawOval(
        Rect.fromCircle(center: Offset.zero, radius: ringR),
        ringPaint,
      );

      // Orbiting dots
      for (var d = 0; d < 3 + i * 2; d++) {
        final dotAngle = (d / (3 + i * 2)) * pi * 2;
        final dotX = cos(dotAngle) * ringR;
        final dotY = sin(dotAngle) * ringR * 0.3; // Flatten for perspective
        canvas.drawCircle(
          Offset(dotX, dotY),
          2.5,
          Paint()
            ..color = color.withOpacity(0.4 + 0.3 * sin(t * 4 + d))
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_TitleOrbitalPainter oldDelegate) => true;
}

// ---- Game Over Dialog ----
class _GameOverDialog extends StatelessWidget {
  final int score;
  final int wave;
  final int maxCombo;
  final int towersDeployed;
  final int enemiesKilled;
  final int mergesPerformed;
  final double gameTime;
  const _GameOverDialog({
    required this.score,
    this.wave = 1,
    required this.maxCombo,
    required this.towersDeployed,
    required this.enemiesKilled,
    required this.mergesPerformed,
    required this.gameTime,
  });

  String _formatTime(double seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds.toInt() % 60;
    return '${mins}分${secs}秒';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0E1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFF003C).withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF003C).withOpacity(0.2),
              blurRadius: 30,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💥', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text(
                '基地被摧毁',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF003C),
                  shadows: [Shadow(color: Color(0xFFFF003C), blurRadius: 15)],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '得分: $score',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF00F0FF),
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Color(0xFF00F0FF), blurRadius: 8)],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '到达波次: $wave',
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF9D00FF).withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              // Stats grid
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111820),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1A3050), width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      '📊 战斗统计',
                      style: TextStyle(
                        color: Color(0xFF6688AA),
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _StatChip(
                          icon: '🔥',
                          label: '最大连击',
                          value: '$maxCombo',
                          color: const Color(0xFFFFEA00),
                        ),
                        _StatChip(
                          icon: '🚀',
                          label: '部署塔数',
                          value: '$towersDeployed',
                          color: const Color(0xFF00F0FF),
                        ),
                        _StatChip(
                          icon: '💀',
                          label: '击杀敌人',
                          value: '$enemiesKilled',
                          color: const Color(0xFFFF003C),
                        ),
                        _StatChip(
                          icon: '💫',
                          label: '合成次数',
                          value: '$mergesPerformed',
                          color: const Color(0xFF9D00FF),
                        ),
                        _StatChip(
                          icon: '⏱️',
                          label: '存活时间',
                          value: _formatTime(gameTime),
                          color: const Color(0xFF00FF88),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1628),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1A2240)),
                      ),
                      child: const Text(
                        '返回',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8899AA),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF003C), Color(0xFFFF4466)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF003C).withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Text(
                        '再来一局',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Game Victory Dialog ----
class _GameVictoryDialog extends StatelessWidget {
  final int level;
  final int score;
  final int wave;
  final int maxCombo;
  final int towersDeployed;
  final int enemiesKilled;
  final int mergesPerformed;
  final double gameTime;
  const _GameVictoryDialog({
    required this.level,
    required this.score,
    required this.wave,
    required this.maxCombo,
    required this.towersDeployed,
    required this.enemiesKilled,
    required this.mergesPerformed,
    required this.gameTime,
  });

  String _formatTime(double seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds.toInt() % 60;
    return '${mins}分${secs}秒';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0E1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF88).withOpacity(0.2),
              blurRadius: 30,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                '第 $level 关 通关成功！',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00FF88),
                  shadows: [Shadow(color: Color(0xFF00FF88), blurRadius: 15)],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '得分: $score',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF00F0FF),
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Color(0xFF00F0FF), blurRadius: 8)],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '坚持了 ${_formatTime(gameTime)}',
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF9D00FF).withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              // Stats grid
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111820),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1A3050), width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      '📊 战斗统计',
                      style: TextStyle(
                        color: Color(0xFF6688AA),
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _StatChip(
                          icon: '🔥',
                          label: '最大连击',
                          value: '$maxCombo',
                          color: const Color(0xFFFFEA00),
                        ),
                        _StatChip(
                          icon: '🚀',
                          label: '部署塔数',
                          value: '$towersDeployed',
                          color: const Color(0xFF00F0FF),
                        ),
                        _StatChip(
                          icon: '💀',
                          label: '击杀敌人',
                          value: '$enemiesKilled',
                          color: const Color(0xFFFF003C),
                        ),
                        _StatChip(
                          icon: '🔗',
                          label: '合并次数',
                          value: '$mergesPerformed',
                          color: const Color(0xFFB700FF),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Next level button
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_forward),
                label: Text(level < 81 ? '继续挑战第 ${level + 1} 关' : '返回'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF88),
                  foregroundColor: const Color(0xFF030408),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.6), fontSize: 8),
          ),
        ],
      ),
    );
  }
}

// ---- Protocol Dialog ----
class _ProtocolDialog extends StatefulWidget {
  final List<Buff> buffs;

  const _ProtocolDialog({required this.buffs});

  @override
  State<_ProtocolDialog> createState() => _ProtocolDialogState();
}

class _ProtocolDialogState extends State<_ProtocolDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              Color.fromRGBO(10, 10, 30, 0.95),
              Color.fromRGBO(5, 5, 15, 0.98),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              blurRadius: 30,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: const Text(
                  '深空协议',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                    letterSpacing: 6,
                    shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 12)],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '选择一项强化协议',
                style: TextStyle(
                  color: Color(0xFF6688AA),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.buffs.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final buff = entry.value;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final delay = idx * 0.12;
                          final value = (_animation.value - delay).clamp(
                            0.0,
                            1.0,
                          );
                          final curved = Curves.easeOutBack.transform(value);
                          return Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 40 * (1 - curved))
                              ..scale(0.3 + 0.7 * curved),
                            alignment: Alignment.center,
                            child: Opacity(
                              opacity: curved.clamp(0.0, 1.0),
                              child: child,
                            ),
                          );
                        },
                        child: _BuffCard(
                          buff: buff,
                          onTap: () {
                            Navigator.of(context).pop(buff);
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuffCard extends StatelessWidget {
  final Buff buff;
  final VoidCallback onTap;

  const _BuffCard({required this.buff, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 70),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1220),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: buff.tierColor, width: 1.5),
          boxShadow: [
            BoxShadow(color: buff.tierColor.withOpacity(0.25), blurRadius: 12),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Text(buff.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: buff.tierColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: buff.tierColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                buff.tier,
                style: TextStyle(
                  color: buff.tierColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              buff.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              buff.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8899AA),
                fontSize: 9,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: buff.tierColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '选择',
                style: TextStyle(
                  color: buff.tierColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
