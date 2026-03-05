import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart' hide Hero;
import '../models/models.dart';
import '../constants.dart';
import '../widgets/game_background.dart';

class CombatEntity {
  final String uid;
  final String name;
  final int level;
  final int hp;
  final int atk;
  final int spd;
  final String side;
  final RarityType rarity;
  final List<String> skills;
  final String image;
  int currentHp;
  int totalDamage;

  double offsetX = 0;
  double offsetY = 0;
  bool isCasting = false;
  String? activeSkill;

  CombatEntity({
    required this.uid,
    required this.name,
    required this.level,
    required this.hp,
    required this.atk,
    required this.spd,
    required this.side,
    required this.currentHp,
    required this.skills,
    this.totalDamage = 0,
    this.rarity = RarityType.R,
    this.image = '',
  });
}

enum CombatPlayStage { story, playing, victory, defeat }

class CombatEngineView extends StatefulWidget {
  final List<Hero> playerTeam;
  final Stage selectedStage;
  final VoidCallback onCombatEnd;

  const CombatEngineView({
    super.key,
    required this.playerTeam,
    required this.selectedStage,
    required this.onCombatEnd,
  });

  @override
  State<CombatEngineView> createState() => _CombatEngineViewState();
}

class _CombatEngineViewState extends State<CombatEngineView> {
  CombatPlayStage _combatStage = CombatPlayStage.story;
  final List<String> _combatLog = [];
  List<CombatEntity> _playerTeam = [];
  List<CombatEntity> _enemyTeam = [];
  int _currentTurn = 1;
  int _storyStep = 0;

  double _shakeIntensity = 0.0;
  bool _showSkillSplash = false;
  String _skillFocusName = "";

  @override
  void initState() {
    super.initState();
    _initializeCombat();
  }

  void _initializeCombat() {
    _playerTeam = widget.playerTeam
        .map(
          (h) => CombatEntity(
            uid: h.uid,
            name: h.name,
            level: h.level,
            hp: h.hp,
            atk: h.atk,
            spd: h.spd,
            side: 'player',
            currentHp: h.hp,
            rarity: h.rarity,
            skills: h.skills,
            image: h.image.isNotEmpty ? h.image : _getImageFromTemplate(h.templateId),
          ),
        )
        .toList();

    final int stageId = widget.selectedStage.id;
    final double diffMult = pow(1.45, stageId).toDouble();

    _enemyTeam = [
      CombatEntity(
        uid: 'boss_$stageId',
        name: stageId >= 10
            ? '【主宰】${widget.selectedStage.name.split(' ').last}'
            : '守卫·${widget.selectedStage.name.split(' ').last}',
        level: widget.selectedStage.recLevel,
        hp: (15000 * diffMult).round(),
        atk: (750 * diffMult).round(),
        spd: 80 + (stageId * 8),
        side: 'enemy',
        currentHp: (15000 * diffMult).round(),
        rarity: RarityType.UR,
        skills: ["破滅の一撃", "深淵の凝視"],
        image: '',
      ),
    ];
  }

  void _startCombatSimulation() async {
    while (_combatStage == CombatPlayStage.playing) {
      if (_playerTeam.every((e) => e.currentHp <= 0) ||
          _enemyTeam.every((e) => e.currentHp <= 0))
        break;
      await _simulateTurn();
      _currentTurn++;
      if (_currentTurn > 100) break;
    }
    _finalizeCombat();
  }

  // コア修正：グローバル速度排序、全出陣ヒーローが行動可能に
  Future<void> _simulateTurn() async {
    final List<CombatEntity> allEntities = [
      ..._playerTeam,
      ..._enemyTeam,
    ].where((e) => e.currentHp > 0).toList();

    // 速度順に行動順序を降序配列
    allEntities.sort((a, b) => b.spd.compareTo(a.spd));

    for (var attacker in allEntities) {
      if (attacker.currentHp <= 0 || _combatStage != CombatPlayStage.playing)
        continue;

      final targets = attacker.side == 'player' ? _enemyTeam : _playerTeam;
      final aliveTargets = targets.where((t) => t.currentHp > 0).toList();
      if (aliveTargets.isEmpty) break;

      final target = aliveTargets[Random().nextInt(aliveTargets.length)];
      await _performCombatAnimation(attacker, target);

      if (!mounted) return;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 200)); // アクション間隔
    }
  }

  Future<void> _performCombatAnimation(
    CombatEntity attacker,
    CombatEntity target,
  ) async {
    bool isSkill = Random().nextDouble() < 0.35;

    if (isSkill) {
      setState(() {
        _showSkillSplash = true;
        _skillFocusName = attacker.skills.isNotEmpty
            ? attacker.skills[0]
            : "极意";
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _showSkillSplash = false);
    }

    // 攻撃アクション
    if (mounted) {
      setState(() {
        attacker.offsetX = attacker.side == 'player' ? -40 : 40;
        attacker.isCasting = isSkill;
      });
    }
    await Future.delayed(const Duration(milliseconds: 100));

    // ヒット計算
    if (mounted) {
      setState(() {
        attacker.offsetY = attacker.side == 'player' ? -200 : 200;
        int dmg = (attacker.atk * (isSkill ? 3.8 : 1.2)).round();
        target.currentHp = max(0, target.currentHp - dmg);
        _shakeIntensity = isSkill ? 15.0 : 5.0;
        attacker.totalDamage += dmg;
        _combatLog.insert(
          0,
          "T$_currentTurn: ${attacker.name} が ${target.name} に攻撃、$dmg のダメージを与えた",
        );
      });
    }

    await Future.delayed(const Duration(milliseconds: 120));
    if (mounted) setState(() => _shakeIntensity = 0);

    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      setState(() {
        attacker.offsetX = 0;
        attacker.offsetY = 0;
        attacker.isCasting = false;
      });
    }
  }

  void _finalizeCombat() {
    bool win = _enemyTeam.every((e) => e.currentHp <= 0);
    if (mounted)
      setState(
        () => _combatStage = win
            ? CombatPlayStage.victory
            : CombatPlayStage.defeat,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050508),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        transform: Matrix4.translationValues(
          _shakeIntensity,
          _shakeIntensity,
          0,
        ),
        child: Stack(
          children: [
            _buildBattleBackground(),
            if (_combatStage == CombatPlayStage.story) _buildStoryOverlay(),
            if (_combatStage == CombatPlayStage.playing) _buildBattleScene(),
            if (_showSkillSplash) _buildSkillSplashOverlay(),
            if (_combatStage == CombatPlayStage.victory ||
                _combatStage == CombatPlayStage.defeat)
              _buildResultOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildBattleBackground() {
    return Stack(
      children: [
        Image.asset(
          BackgroundUtil.getBgByScene('combat'),
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.black.withValues(alpha: 0.15), // 中心更透明
                Colors.black.withValues(alpha: 0.25), // 中间过渡
                Colors.black.withValues(alpha: 0.35), // 边缘稍暗
              ],
            ),
          ),
        ),
        CustomPaint(painter: GridPainter(), size: Size.infinite),
      ],
    );
  }

  Widget _buildSkillSplashOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, val, child) => Transform.scale(
            scale: 0.7 + (val * 0.5),
            child: Opacity(
              opacity: val,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 80),
                  Text(
                    _skillFocusName,
                    style: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 8,
                      shadows: [Shadow(color: Colors.amber, blurRadius: 40)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryOverlay() {
    final story = widget.selectedStage.story;
    if (story.isEmpty) {
      Timer.run(
        () => setState(() {
          _combatStage = CombatPlayStage.playing;
          _startCombatSimulation();
        }),
      );
      return const SizedBox();
    }
    final dialog = story[_storyStep];
    return GestureDetector(
      onTap: () {
        if (_storyStep < story.length - 1) {
          setState(() => _storyStep++);
        } else {
          setState(() => _combatStage = CombatPlayStage.playing);
          _startCombatSimulation();
        }
      },
      child: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff1a1a22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dialog['speaker']!,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 24),
                    Text(
                      dialog['content']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "点击继续...",
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBattleScene() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 60),
          _buildTeamRow(_enemyTeam),
          const Spacer(),
          _buildTeamRow(_playerTeam),
          _buildCombatLogView(),
        ],
      ),
    );
  }

  Widget _buildTeamRow(List<CombatEntity> team) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: team
          .map(
            (e) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.translationValues(e.offsetX, e.offsetY, 0),
              child: _buildUnitCard(e),
            ),
          )
          .toList(),
    );
  }

  Widget _buildUnitCard(CombatEntity e) {
    bool isDead = e.currentHp <= 0;
    return Opacity(
      opacity: isDead ? 0.3 : 1.0,
      child: Column(
        children: [
          _buildHpBar(e),
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xff2d2d3d),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _getRarityColor(e.rarity), width: 3),
              boxShadow: e.isCasting
                  ? [
                      BoxShadow(
                        color: _getRarityColor(e.rarity).withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: e.image.isNotEmpty
                  ? Image.asset(
                      e.image,
                      fit: BoxFit.cover,
                      width: 68,
                      height: 68,
                    )
                  : Center(
                      child: Text(
                        e.name[0],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            e.name,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHpBar(CombatEntity e) {
    double ratio = (e.currentHp / e.hp).clamp(0.0, 1.0);
    return Container(
      width: 60,
      height: 6,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: ratio,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.greenAccent, Colors.green.shade800],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildCombatLogView() {
    return Container(
      height: 140,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.builder(
        itemCount: _combatLog.length,
        itemBuilder: (c, i) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            _combatLog[i],
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultOverlay() {
    bool win = _combatStage == CombatPlayStage.victory;
    return Container(
      color: Colors.black.withOpacity(0.9),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            win ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
            color: win ? Colors.amber : Colors.redAccent,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            win ? "凱旋而归" : "全軍壊滅",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: win ? Colors.amber : Colors.redAccent,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              side: const BorderSide(color: Colors.white30),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: widget.onCombatEnd,
            child: const Text(
              "戻る",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(RarityType r) {
    switch (r) {
      case RarityType.UR:
        return Colors.redAccent;
      case RarityType.SSR:
        return Colors.orangeAccent;
      case RarityType.SR:
        return Colors.purpleAccent;
      default:
        return Colors.blueAccent;
    }
  }

  String _getImageFromTemplate(String templateId) {
    final template = HERO_TEMPLATES.firstWhere(
      (t) => t.id == templateId,
      orElse: () => HERO_TEMPLATES.first,
    );
    return template.image.isEmpty ? HERO_TEMPLATES.first.image : template.image;
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 30)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 30)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
