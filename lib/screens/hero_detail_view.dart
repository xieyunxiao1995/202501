import 'package:flutter/material.dart' hide Hero;
import '../models/models.dart';
import '../state/game_state.dart';
import '../constants.dart';
import '../widgets/game_background.dart';

class HeroDetailView extends StatefulWidget {
  final Hero hero;
  final GameState gameState;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const HeroDetailView({
    super.key,
    required this.hero,
    required this.gameState,
    required this.onSave,
    required this.onBack,
  });

  @override
  State<HeroDetailView> createState() => _HeroDetailViewState();
}

class _HeroDetailViewState extends State<HeroDetailView> {
  late Hero _hero;
  bool _isUpgrading = false;

  @override
  void initState() {
    super.initState();
    _hero = widget.gameState.getHero(widget.hero.uid) ?? widget.hero;
    // 兜底：英雄に画像がない場合、templateId からテンプレートで取得
    if (_hero.image.isEmpty) {
      final template = HERO_TEMPLATES.firstWhere(
        (t) => t.id == _hero.templateId,
        orElse: () => HERO_TEMPLATES.first,
      );
      _hero = _hero.copyWith(image: template.image);
    }
  }

  Future<void> _levelUp() async {
    if (_isUpgrading) return;
    final cost = (_hero.level * 10).floor();
    if (widget.gameState.gold < cost || widget.gameState.exp < cost) {
      _showResourceAlert();
      return;
    }
    setState(() => _isUpgrading = true);
    widget.gameState.spendGold(cost);
    widget.gameState.spendExp(cost);
    _hero = _hero.copyWith(
      level: _hero.level + 1,
      hp: (_hero.hp * 1.05).floor(),
      atk: (_hero.atk * 1.05).floor(),
      def: (_hero.def * 1.05).floor(),
    );
    widget.gameState.updateHero(_hero);
    await widget.gameState.save();
    widget.onSave();
    setState(() => _isUpgrading = false);
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('レベルアップ成功！Lv.${_hero.level}')));
  }

  Future<void> _levelUpMultiple() async {
    if (_isUpgrading) return;
    var totalCost = 0;
    for (int i = 0; i < 5; i++) totalCost += ((_hero.level + i) * 10).floor();
    if (widget.gameState.gold < totalCost || widget.gameState.exp < totalCost) {
      _showResourceAlert();
      return;
    }
    setState(() => _isUpgrading = true);
    Hero updatedHero = _hero;
    for (int i = 0; i < 5; i++) {
      final cost = (updatedHero.level * 10).floor();
      widget.gameState.spendGold(cost);
      widget.gameState.spendExp(cost);
      updatedHero = updatedHero.copyWith(
        level: updatedHero.level + 1,
        hp: (updatedHero.hp * 1.05).floor(),
        atk: (updatedHero.atk * 1.05).floor(),
        def: (updatedHero.def * 1.05).floor(),
      );
    }
    _hero = updatedHero;
    widget.gameState.updateHero(_hero);
    await widget.gameState.save();
    widget.onSave();
    setState(() => _isUpgrading = false);
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('连升5级！Lv.${_hero.level}')));
  }

  void _showResourceAlert() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('リソース不足'),
        content: const Text('ゴールドまたは経験値が不足しています。探険に行ってリソースを稼ぎましょう！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cp = _hero.combatPower;
    final rColor = _getRarityColor(_hero.rarity);

    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('hero_detail'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('hero_detail'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: widget.onBack,
          ),
        ),
        body: Stack(
        children: [
          // コンテンツエリア
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildHeroVisual(rColor),
                    _buildCombatPower(cp),
                    _buildStatsPanel(),
                    _buildSkills(),
                    _buildUpgradeSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildHeroVisual(Color rColor) {
    return Container(
      width: 180,
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: rColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: rColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // 英雄画像
            if (_hero.image.isNotEmpty)
              Positioned.fill(
                child: Image.asset(
                  _hero.image,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [rColor.withOpacity(0.8), Colors.black87],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _hero.name.substring(0, 1),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w900,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _hero.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Lv.${_hero.level}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // 下部グラデーションマスク
            if (_hero.image.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _hero.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lv.${_hero.level}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatPower(int cp) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.redAccent,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            cp.toString(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '戦力',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('HP', _hero.hp, Icons.favorite, Colors.greenAccent),
          _buildStatItem(
            '攻撃',
            _hero.atk,
            Icons.fitness_center,
            Colors.redAccent,
          ),
          _buildStatItem('防御', _hero.def, Icons.shield, Colors.blueAccent),
          _buildStatItem('速度', _hero.spd, Icons.speed, Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSkills() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '天赋スキル',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                if (index < _hero.skills.length)
                  return _buildSkillCard(_hero.skills[index]);
                return _buildLockedSkillCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(String skillName) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade900, Colors.deepPurple.shade900],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
          const SizedBox(height: 6),
          Text(
            skillName,
            style: const TextStyle(color: Colors.white, fontSize: 10),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLockedSkillCard() {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.lock_outline, color: Colors.white24, size: 28),
      ),
    );
  }

  Widget _buildUpgradeSection() {
    final cost = (_hero.level * 10).floor();
    final canAfford =
        widget.gameState.gold >= cost && widget.gameState.exp >= cost;

    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildResourceIndicator(
                Icons.monetization_on,
                'ゴールド',
                widget.gameState.gold,
                cost,
                Colors.amber,
              ),
              const SizedBox(width: 24),
              _buildResourceIndicator(
                Icons.star,
                '経験値',
                widget.gameState.exp,
                cost,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUpgradeButton(
                '1 レベルアップ',
                canAfford && !_isUpgrading ? _levelUp : null,
                isPrimary: false,
              ),
              const SizedBox(width: 16),
              _buildUpgradeButton(
                '5 レベル連続アップ',
                canAfford && !_isUpgrading ? _levelUpMultiple : null,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceIndicator(
    IconData icon,
    String label,
    int current,
    int cost,
    Color color,
  ) {
    final canAfford = current >= cost;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          current.toString(),
          style: TextStyle(
            color: canAfford ? Colors.white : Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '/ $cost',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildUpgradeButton(
    String label,
    VoidCallback? onTap, {
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          color: onTap != null
              ? (isPrimary ? Colors.amber : Colors.blueGrey)
              : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(24),
          boxShadow: onTap != null && isPrimary
              ? [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: onTap != null ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }

  Color _getRarityColor(RarityType rarity) {
    switch (rarity) {
      case RarityType.UR:
        return const Color(0xffef4444);
      case RarityType.SSR:
        return const Color(0xfff97316);
      case RarityType.SR:
        return const Color(0xffa855f7);
      case RarityType.R:
        return const Color(0xff3b82f6);
    }
  }
}
