import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/general/general_model.dart';
import 'battle_models.dart';

/// 战斗主页面（4v4 回合制卡牌战斗）
///
/// 从招募页面选择武将后进入，使用卡牌系统进行回合制战斗。
/// 左侧为我方英雄，右侧为敌方单位。
class BattlePage extends StatefulWidget {
  final List<GeneralModel> heroes;

  const BattlePage({super.key, required this.heroes});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> with TickerProviderStateMixin {
  // ---- 战斗对象 ----
  late final List<HeroData> _heroes;
  late final List<BattleEnemy> _enemies;

  // ---- 牌堆 ----
  final List<CardData> _drawPile = [];
  final List<CardData> _discardPile = [];
  final List<CardData> _handCards = [];

  // ---- 战斗状态 ----
  int _energy = 3;
  bool _isPlayerTurn = true;
  bool _battleOver = false;
  bool _victory = false;
  CardData? _pendingAttackCard;

  // ---- 特效 ----
  final Set<int> _flashHeroes = {};
  final Set<int> _flashEnemies = {};
  bool _heroShieldFlash = false;
  final List<_FloatingText> _floatingTexts = [];
  final List<String> _battleLog = [];

  // ---- 随机 ----
  final Random _rng = Random();

  // ---- 配色 ----
  static const _heroColor = Color(0xFFA11717);
  static const _goldColor = Color(0xFFD4A84B);
  static const _bgColor = Color(0xFF1A0F0A);

  // =========================== 生命周期 ===========================

  @override
  void initState() {
    super.initState();
    _heroes = widget.heroes
        .map((g) => HeroData(name: g.name, maxHp: (g.hp / 10).round()))
        .toList();

    // 随机选 4 个敌人
    final pool = List<EnemyData>.from(starterEnemies)..shuffle(_rng);
    _enemies = pool.take(4).map((e) {
      final be = BattleEnemy(name: e.name, maxHp: e.maxHealth);
      be.setIntent(damage: 4 + _rng.nextInt(5));
      return be;
    }).toList();

    _initDrawPile();
    _drawCards(3);
  }

  // ---- 快捷访问 ----

  int get _aliveHeroCount => _heroes.where((h) => h.isAlive).length;
  int get _aliveEnemyCount => _enemies.where((e) => e.isAlive).length;

  HeroData? get _firstAliveHero => _heroes.cast<HeroData?>().firstWhere(
    (h) => h!.isAlive,
    orElse: () => null,
  );

  // =========================== 牌堆逻辑 ===========================

  void _initDrawPile() {
    _drawPile.clear();
    for (final card in starterCards) {
      for (var i = 0; i < 3; i++) {
        _drawPile.add(card);
      }
    }
    _drawPile.shuffle(_rng);
  }

  void _drawCards(int count) {
    for (var i = 0; i < count; i++) {
      if (_drawPile.isEmpty) {
        if (_discardPile.isEmpty) break;
        _drawPile.addAll(_discardPile);
        _discardPile.clear();
        _drawPile.shuffle(_rng);
      }
      _handCards.add(_drawPile.removeAt(0));
    }
  }

  // =========================== 出牌 ===========================

  void _playCard(CardData card) {
    if (!_isPlayerTurn || _battleOver) return;
    if (_energy < card.cost) return;

    if (card.type == CardType.attack && _aliveEnemyCount > 0) {
      setState(() => _pendingAttackCard = card);
      return;
    }

    _executeCard(card, targetEnemyIndex: 0);
  }

  void _executeCard(CardData card, {required int targetEnemyIndex}) {
    setState(() {
      _energy -= card.cost;
      _pendingAttackCard = null;

      switch (card.type) {
        case CardType.attack:
          if (_aliveEnemyCount == 0) break;
          final enemy = _enemies[targetEnemyIndex];
          if (!enemy.isAlive) break;
          final dmg = (_firstAliveHero?.attackPower(card.damage) ?? card.damage);
          enemy.takeDamage(dmg);
          _flashEnemy(targetEnemyIndex);
          _addFloatingText('-$dmg', const Color(0xFFA11717), isRight: true);
          _addLog('⚔ ${card.name} → ${enemy.name} 造成 $dmg 点伤害');
          break;

        case CardType.skill:
          final target = _lowestHpHero();
          if (target != null) {
            target.addBlock(card.block);
            _heroShieldFlash = true;
            Future.delayed(const Duration(milliseconds: 350), () {
              if (mounted) setState(() => _heroShieldFlash = false);
            });
          }
          _addFloatingText('+${card.block}', _goldColor, isRight: false);
          _addLog('🛡 ${card.name} → 获得 ${card.block} 点护甲');
          break;

        case CardType.power:
          for (final h in _heroes) {
            if (h.isAlive) h.addStrength(2);
          }
          _addLog('💪 ${card.name} → 全体力量 +2');
          break;
      }

      _handCards.remove(card);
      _discardPile.add(card);
    });

    _checkBattleEnd();
  }

  HeroData? _lowestHpHero() {
    HeroData? best;
    for (final h in _heroes) {
      if (!h.isAlive) continue;
      if (best == null || h.hp < best.hp) best = h;
    }
    return best;
  }

  void _cancelTargeting() {
    setState(() => _pendingAttackCard = null);
  }

  // =========================== 回合结束 ===========================

  void _endTurn() {
    if (!_isPlayerTurn || _battleOver) return;
    _pendingAttackCard = null;
    _discardPile.addAll(_handCards);
    _handCards.clear();

    setState(() {
      _isPlayerTurn = false;
      for (final h in _heroes) {
        h.resetBlock();
      }
      for (final e in _enemies) {
        e.resetBlock();
      }
      _addLog('--- 敌军回合 ---');
    });

    Future.delayed(const Duration(milliseconds: 600), _enemyAct);
  }

  void _enemyAct() {
    if (_battleOver) return;

    for (var i = 0; i < _enemies.length; i++) {
      final enemy = _enemies[i];
      if (!enemy.isAlive) continue;

      final aliveHeroes = <int>[];
      for (var j = 0; j < _heroes.length; j++) {
        if (_heroes[j].isAlive) aliveHeroes.add(j);
      }
      if (aliveHeroes.isEmpty) break;

      final targetIdx = aliveHeroes[_rng.nextInt(aliveHeroes.length)];
      final target = _heroes[targetIdx];
      final dmg = enemy.attackPower(enemy.intendedDamage);

      setState(() {
        target.takeDamage(dmg);
        _flashHero(targetIdx);
        _addFloatingText('-$dmg', const Color(0xFFA11717), isRight: false);
        _addLog('⚔ ${enemy.name} 攻击 ${target.name}，造成 $dmg 点伤害');
      });

      if (_battleOver) break;
    }

    for (final enemy in _enemies) {
      if (enemy.isAlive) {
        enemy.setIntent(damage: 4 + _rng.nextInt(6));
      }
    }

    _checkBattleEnd();
    if (_battleOver) return;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _battleOver) return;
      setState(() {
        _isPlayerTurn = true;
        for (final h in _heroes) {
          h.onTurnStart();
        }
        _energy = 3;
        _drawCards(3);
        _addLog('--- 你的回合 ---');
      });
    });
  }

  // =========================== 胜负判定 ===========================

  void _checkBattleEnd() {
    if (_aliveEnemyCount == 0) {
      setState(() {
        _battleOver = true;
        _victory = true;
      });
    } else if (_aliveHeroCount == 0) {
      setState(() {
        _battleOver = true;
        _victory = false;
      });
    }
  }

  void _restart() {
    setState(() {
      _heroes.clear();
      _enemies.clear();
      _heroes.addAll(
        widget.heroes.map((g) => HeroData(name: g.name, maxHp: (g.hp / 10).round())),
      );
      final pool = List<EnemyData>.from(starterEnemies)..shuffle(_rng);
      for (final e in pool.take(4)) {
        final be = BattleEnemy(name: e.name, maxHp: e.maxHealth);
        be.setIntent(damage: 4 + _rng.nextInt(5));
        _enemies.add(be);
      }
      _drawPile.clear();
      _discardPile.clear();
      _handCards.clear();
      _energy = 3;
      _isPlayerTurn = true;
      _battleOver = false;
      _victory = false;
      _pendingAttackCard = null;
      _floatingTexts.clear();
      _battleLog.clear();
      _flashHeroes.clear();
      _flashEnemies.clear();
      _heroShieldFlash = false;
      _initDrawPile();
      _drawCards(3);
    });
  }

  // =========================== 特效 ===========================

  void _flashHero(int index) {
    _flashHeroes.add(index);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _flashHeroes.remove(index));
    });
  }

  void _flashEnemy(int index) {
    _flashEnemies.add(index);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _flashEnemies.remove(index));
    });
  }

  void _addFloatingText(String text, Color color, {required bool isRight}) {
    final ft = _FloatingText(
      text: text,
      color: color,
      dx: isRight ? -40.0 : 40.0,
      dy: isRight ? -80.0 : 0.0,
    );
    setState(() => _floatingTexts.add(ft));
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _floatingTexts.remove(ft));
    });
  }

  void _addLog(String msg) {
    setState(() {
      _battleLog.add(msg);
      if (_battleLog.length > 30) _battleLog.removeAt(0);
    });
  }

  // =========================== 构建 ===========================

  @override
  Widget build(BuildContext context) {
    final inTargeting = _pendingAttackCard != null;

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ---- 顶部栏 ----
            _buildTopBar(),
            // ---- 战斗区域 ----
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ---- 背景装饰 ----
                  Positioned.fill(
                    child: CustomPaint(painter: _BattleBgPainter()),
                  ),
                  // ---- 战鼓 ----
                  Positioned(
                    right: 10,
                    bottom: 200,
                    child: Opacity(
                      opacity: 0.08,
                      child: Icon(Icons.military_tech, size: 200, color: _heroColor),
                    ),
                  ),
                  // ---- 战斗日志 ----
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.35,
                    child: Center(child: _buildLog()),
                  ),
                  // ---- 我方英雄 ----
                  ..._buildHeroTeam(),
                  // ---- 敌方 ----
                  ..._buildEnemyTeam(inTargeting),
                  // ---- 浮动文字 ----
                  ..._floatingTexts.map(_buildFloatingText),
                  // ---- 选敌提示 ----
                  if (inTargeting)
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: _cancelTargeting,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xDDD4A84B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '点击敌方选择目标 · 点此取消',
                              style: TextStyle(color: Color(0xFF1A0F0A), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // ---- 底部操作区 ----
                  if (!_battleOver) _buildBottomBar(),
                  // ---- 战斗结束弹窗 ----
                  if (_battleOver) _buildResultOverlay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 顶部栏 ====================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0x20FFFFFF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFFE2D9CD), size: 24),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '征战沙场',
            style: TextStyle(
              color: Color(0xFFE2D9CD),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          // 回合指示
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isPlayerTurn ? const Color(0x40A11717) : const Color(0x20FFFFFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isPlayerTurn ? const Color(0x80A11717) : const Color(0x20FFFFFF),
              ),
            ),
            child: Text(
              _isPlayerTurn ? '你的回合' : '敌军回合',
              style: TextStyle(
                color: _isPlayerTurn ? const Color(0xFFE2D9CD) : const Color(0x66E2D9CD),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 日志 ====================

  Widget _buildLog() {
    return SizedBox(
      width: 160,
      height: 120,
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: _battleLog
              .map((m) => Text(
                    m,
                    style: TextStyle(
                      color: const Color(0xFFE2D9CD).withAlpha(60),
                      fontSize: 9,
                      height: 1.4,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ==================== 英雄队伍（左侧单列）====================

  List<Widget> _buildHeroTeam() {
    final widgets = <Widget>[];
    const cellW = 80.0;
    const cellH = 100.0;
    const startX = 8.0;
    const startY = 60.0;
    const gapY = 6.0;

    for (var i = 0; i < _heroes.length; i++) {
      final hero = _heroes[i];
      final flashing = _flashHeroes.contains(i);
      final shield = _heroShieldFlash && hero.block > 0;

      widgets.add(
        Positioned(
          left: startX,
          top: startY + i * (cellH + gapY),
          width: cellW,
          height: cellH,
          child: _UnitWidget(
            name: hero.name,
            hp: hero.hp,
            maxHp: hero.maxHp,
            block: hero.block,
            strength: hero.strength,
            isAlive: hero.isAlive,
            color: flashing
                ? const Color(0xFFE2D9CD)
                : (shield ? _goldColor : _heroColor),
            barColor: _heroColor,
            shape: BoxShape.rectangle,
            hpBarWidth: 70,
            hpBarHeight: 6,
            bodySize: 42,
            fontSize: 9,
          ),
        ),
      );
    }
    return widgets;
  }

  // ==================== 敌方队伍（右侧单列）====================

  List<Widget> _buildEnemyTeam(bool inTargeting) {
    final widgets = <Widget>[];
    const cellW = 80.0;
    const cellH = 100.0;
    const gapY = 6.0;

    for (var i = 0; i < _enemies.length; i++) {
      final enemy = _enemies[i];
      final flashing = _flashEnemies.contains(i);
      final canTarget = inTargeting && enemy.isAlive;

      widgets.add(
        Positioned(
          right: 8,
          top: 60 + i * (cellH + gapY),
          width: cellW,
          height: cellH,
          child: GestureDetector(
            onTap: canTarget && _pendingAttackCard != null
                ? () => _executeCard(_pendingAttackCard!, targetEnemyIndex: i)
                : null,
            child: _UnitWidget(
              name: enemy.name,
              hp: enemy.hp,
              maxHp: enemy.maxHp,
              block: enemy.block,
              isAlive: enemy.isAlive,
              color: flashing ? const Color(0xFFE2D9CD) : const Color(0xFF6A0F0F),
              barColor: const Color(0xFF6A0F0F),
              shape: BoxShape.circle,
              hpBarWidth: 70,
              hpBarHeight: 6,
              bodySize: 42,
              fontSize: 9,
              intendedDamage: enemy.intendedDamage,
              highlight: canTarget,
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  // ==================== 底部操作区 ====================

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 20),
        decoration: BoxDecoration(
          color: const Color(0xDD1A1A2A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          border: const Border(top: BorderSide(color: Color(0x30D4A84B), width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: _goldColor, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$_energy / 3',
                      style: const TextStyle(
                        color: Color(0xFFE2D9CD),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '牌堆:${_drawPile.length}  弃:${_discardPile.length}',
                  style: TextStyle(color: const Color(0xFFE2D9CD).withAlpha(60), fontSize: 10),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPlayerTurn ? const Color(0xFFA11717) : const Color(0x406A0F0F),
                    foregroundColor: _isPlayerTurn ? const Color(0xFFE2D9CD) : const Color(0x556A0F0F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    elevation: 0,
                  ),
                  onPressed: _isPlayerTurn ? _endTurn : null,
                  child: const Text('结束回合', style: TextStyle(fontSize: 13, letterSpacing: 2)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 80,
              child: _handCards.isEmpty
                  ? Center(
                      child: Text(
                        '无手牌',
                        style: TextStyle(color: const Color(0xFFE2D9CD).withAlpha(40), fontSize: 11),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _handCards.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final card = _handCards[index];
                        final canPlay = _isPlayerTurn && _energy >= card.cost;
                        return _CardWidget(card: card, canPlay: canPlay, onTap: () => _playCard(card));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 结果弹窗 ====================

  Widget _buildResultOverlay() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xEE1A1A2A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _victory ? _goldColor : const Color(0xFFA11717), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _victory ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              color: _victory ? _goldColor : const Color(0xFFA11717),
              size: 48,
            ),
            const SizedBox(height: 10),
            Text(
              _victory ? '大获全胜！' : '兵败撤退',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _victory ? _goldColor : const Color(0xFFA11717),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text('再来一局'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA11717),
                    foregroundColor: const Color(0xFFE2D9CD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    elevation: 0,
                  ),
                  onPressed: _restart,
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.exit_to_app, size: 18),
                  label: const Text('返回'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE2D9CD),
                    side: const BorderSide(color: Color(0x40D4A84B)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 浮动文字 ====================

  Widget _buildFloatingText(_FloatingText ft) {
    return Positioned(
      left: ft.dx > 0 ? ft.dx + 20 : null,
      right: ft.dx < 0 ? -ft.dx + 10 : null,
      top: ft.dy < 0 ? -ft.dy : MediaQuery.of(context).size.height * 0.45,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: -36),
        duration: const Duration(milliseconds: 700),
        builder: (context, value, child) => Opacity(
          opacity: (1 - (value / -36)).clamp(0.0, 1.0),
          child: Transform.translate(offset: Offset(0, value), child: child),
        ),
        child: Text(
          ft.text,
          style: TextStyle(
            color: ft.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: const [Shadow(color: Colors.black87, blurRadius: 5)],
          ),
        ),
      ),
    );
  }
}

// =================================================================
// 统一单位组件（英雄/敌人）
// =================================================================

class _UnitWidget extends StatelessWidget {
  const _UnitWidget({
    required this.name,
    required this.hp,
    required this.maxHp,
    required this.block,
    required this.isAlive,
    required this.color,
    required this.barColor,
    required this.shape,
    required this.hpBarWidth,
    required this.hpBarHeight,
    required this.bodySize,
    required this.fontSize,
    this.strength = 0,
    this.intendedDamage = 0,
    this.highlight = false,
  });

  final String name;
  final int hp;
  final int maxHp;
  final int block;
  final int strength;
  final bool isAlive;
  final Color color;
  final Color barColor;
  final BoxShape shape;
  final double hpBarWidth;
  final double hpBarHeight;
  final double bodySize;
  final double fontSize;
  final int intendedDamage;
  final bool highlight;

  double get _ratio => maxHp <= 0 ? 0 : (hp / maxHp).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 意图
        if (intendedDamage > 0 && isAlive)
          Text('⚔$intendedDamage', style: const TextStyle(color: Color(0xFFFFAAAA), fontSize: 9)),
        // 名称
        Text(
          name,
          style: TextStyle(
            color: const Color(0xFFE2D9CD).withAlpha(isAlive ? 180 : 60),
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        // 身体
        Container(
          width: bodySize,
          height: bodySize,
          decoration: BoxDecoration(
            color: color.withAlpha(isAlive ? 200 : 60),
            borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(6),
            shape: shape,
            border: Border.all(
              color: highlight ? const Color(0xFFD4A84B) : const Color(0xFFE2D9CD).withAlpha(60),
              width: highlight ? 2.5 : 1,
            ),
            boxShadow: [
              if (highlight)
                BoxShadow(color: const Color(0xFFD4A84B).withAlpha(100), blurRadius: 10)
              else
                BoxShadow(color: color.withAlpha(60), blurRadius: 8),
            ],
          ),
          child: Center(
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                color: const Color(0xFFE2D9CD).withAlpha(isAlive ? 200 : 80),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        // 血条
        Container(
          width: hpBarWidth,
          height: hpBarHeight,
          decoration: BoxDecoration(
            color: const Color(0x33FFFFFF),
            borderRadius: BorderRadius.circular(hpBarHeight / 2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _ratio,
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(hpBarHeight / 2),
                ),
              ),
            ),
          ),
        ),
        // HP 数字
        Text(
          '$hp/$maxHp',
          style: TextStyle(color: const Color(0xFFE2D9CD).withAlpha(80), fontSize: 8),
        ),
        if (block > 0)
          Text('🛡$block', style: const TextStyle(color: Color(0xFFD4A84B), fontSize: 8)),
        if (strength > 0)
          Text('💪$strength', style: const TextStyle(color: Color(0xFFFF8C00), fontSize: 8)),
      ],
    );
  }
}

// =================================================================
// 手牌组件
// =================================================================

class _CardWidget extends StatelessWidget {
  const _CardWidget({required this.card, required this.canPlay, required this.onTap});

  final CardData card;
  final bool canPlay;
  final VoidCallback onTap;

  Color get _bgColor {
    if (!canPlay) return const Color(0xFF2A2A3A);
    return switch (card.type) {
      CardType.attack => const Color(0xFFA11717),
      CardType.skill => const Color(0xFF1A5C8A),
      CardType.power => const Color(0xFF7B3A8A),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canPlay ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 64,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: canPlay ? const Color(0x80D4A84B) : const Color(0x20FFFFFF)),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(color: Color(0xAA000000), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '${card.cost}',
                    style: TextStyle(
                      color: canPlay ? const Color(0xFFD4A84B) : const Color(0x55FFFFFF),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              card.name,
              style: TextStyle(color: const Color(0xFFE2D9CD).withAlpha(220), fontSize: 10, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            if (card.damage > 0)
              Text('${card.damage}⚔', style: const TextStyle(color: Color(0xAAE2D9CD), fontSize: 9)),
            if (card.block > 0)
              Text('${card.block}🛡', style: const TextStyle(color: Color(0xAAE2D9CD), fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// 战鼓背景绘制器
// =================================================================

class _BattleBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A0F0A), Color(0xFF2A1410)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    // 战场分割线
    final linePaint = Paint()
      ..color = const Color(0x15D4A84B)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 40),
      Offset(size.width / 2, size.height - 160),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =================================================================
// 浮动文字数据
// =================================================================

class _FloatingText {
  final String text;
  final Color color;
  final double dx;
  final double dy;
  const _FloatingText({required this.text, required this.color, required this.dx, required this.dy});
}
